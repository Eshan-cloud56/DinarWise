package com.sl.dinarwise.expensemanager

import android.Manifest
import android.app.Activity
import android.os.Handler
import android.os.Looper
import androidx.core.app.ActivityCompat
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class VoiceExpenseBridge(
    private val activity: Activity,
    messenger: BinaryMessenger
) {
    private val channel = MethodChannel(messenger, "dinarwise/voice_expense")
    private val voiceRecorder = VoiceRecorder(activity)
    private val whisperBridge = WhisperBridge(activity)
    private val mainHandler = Handler(Looper.getMainLooper())
    private var pendingPermissionResult: MethodChannel.Result? = null
    private var hasPendingWidgetLaunch = false

    private var lastAudioResult: AudioCaptureResult? = null

    init {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "consumeWidgetLaunch" -> {
                    val pending = hasPendingWidgetLaunch
                    hasPendingWidgetLaunch = false
                    result.success(pending)
                }
                "hasPermission" -> {
                    result.success(voiceRecorder.hasPermission())
                }
                "requestPermission" -> {
                    if (voiceRecorder.hasPermission()) {
                        result.success(true)
                        return@setMethodCallHandler
                    }
                    pendingPermissionResult = result
                    ActivityCompat.requestPermissions(
                        activity,
                        arrayOf(Manifest.permission.RECORD_AUDIO),
                        RECORD_AUDIO_REQUEST_CODE
                    )
                }
                "startRecording" -> {
                    val success = voiceRecorder.startRecording { error ->
                        mainHandler.post {
                            channel.invokeMethod("onRecordingError", error.message)
                        }
                    }
                    result.success(success)
                }
                "stopAndTranscribe" -> {
                    val language = call.argument<String>("language")
                    val model = call.argument<String>("model") ?: "base"
                    val prompt = call.argument<String>("prompt")
                    val audioResult = voiceRecorder.stopRecording()
                    if (audioResult == null || audioResult.samples.isEmpty()) {
                        result.error("empty_audio", "No audio recorded", null)
                        return@setMethodCallHandler
                    }
                    lastAudioResult = audioResult

                    whisperBridge.transcribe(
                        audioData = audioResult.samples,
                        language = language,
                        initialPrompt = prompt,
                        modelType = model,
                        audioStats = audioResult
                    ) { transcribeResult ->
                        mainHandler.post {
                            transcribeResult.fold(
                                onSuccess = { data -> result.success(data) },
                                onFailure = { err -> result.error("transcribe_failed", err.message, null) }
                            )
                        }
                    }
                }
                "retranscribeLastAudio" -> {
                    val audioResult = lastAudioResult
                    if (audioResult == null || audioResult.samples.isEmpty()) {
                        result.error("no_cached_audio", "No previous audio recording found to re-test", null)
                        return@setMethodCallHandler
                    }
                    val language = call.argument<String>("language")
                    val model = call.argument<String>("model") ?: "base"
                    val prompt = call.argument<String>("prompt")

                    whisperBridge.transcribe(
                        audioData = audioResult.samples,
                        language = language,
                        initialPrompt = prompt,
                        modelType = model,
                        audioStats = audioResult
                    ) { transcribeResult ->
                        mainHandler.post {
                            transcribeResult.fold(
                                onSuccess = { data -> result.success(data) },
                                onFailure = { err -> result.error("transcribe_failed", err.message, null) }
                            )
                        }
                    }
                }
                "testConsecutive3x" -> {
                    val audioResult = lastAudioResult
                    if (audioResult == null || audioResult.samples.isEmpty()) {
                        result.error("no_cached_audio", "No previous audio recording found to test", null)
                        return@setMethodCallHandler
                    }
                    val language = call.argument<String>("language")
                    val model = call.argument<String>("model") ?: "base"
                    val prompt = call.argument<String>("prompt")

                    whisperBridge.transcribeConsecutive3x(
                        audioData = audioResult.samples,
                        language = language,
                        initialPrompt = prompt,
                        modelType = model,
                        audioStats = audioResult
                    ) { testResult ->
                        mainHandler.post {
                            testResult.fold(
                                onSuccess = { data -> result.success(data) },
                                onFailure = { err -> result.error("test_failed", err.message, null) }
                            )
                        }
                    }
                }
                "cancelRecording" -> {
                    voiceRecorder.cancelRecording()
                    lastAudioResult = null
                    result.success(null)
                }
                "release" -> {
                    whisperBridge.release()
                    lastAudioResult = null
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    fun handleRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        if (requestCode == RECORD_AUDIO_REQUEST_CODE) {
            val granted = grantResults.isNotEmpty() && grantResults[0] == android.content.pm.PackageManager.PERMISSION_GRANTED
            pendingPermissionResult?.success(granted)
            pendingPermissionResult = null
            return true
        }
        return false
    }

    fun setPendingWidgetLaunch(pending: Boolean) {
        hasPendingWidgetLaunch = pending
    }

    fun triggerWidgetLaunch() {
        mainHandler.post {
            channel.invokeMethod("onWidgetLaunch", null)
        }
    }

    companion object {
        const val RECORD_AUDIO_REQUEST_CODE = 7105
    }
}
