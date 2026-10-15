package com.sl.dinarwise.expensemanager

import android.content.Context
import android.content.pm.ApplicationInfo
import android.os.SystemClock
import android.util.Log
import java.io.File
import java.io.FileOutputStream
import java.util.concurrent.Executors

class WhisperBridge(private val context: Context) {
    private val worker = Executors.newSingleThreadExecutor()
    private var contextPtr: Long = 0L
    private var currentModelType: String = ""
    private var modelLoadDurationMs: Long = 0L
    private var modelFileSizeBytes: Long = 0L

    @Synchronized
    private fun ensureContext(modelType: String = "base"): Long {
        val requestedModel = if (modelType.equals("tiny", ignoreCase = true)) "tiny" else "base"
        val hasRequested = try {
            context.assets.open("models/ggml-$requestedModel.bin").close()
            true
        } catch (_: Exception) {
            false
        }
        val targetModel = if (hasRequested) requestedModel else "tiny"
        val modelFileName = "ggml-$targetModel.bin"

        if (contextPtr != 0L && currentModelType == targetModel) {
            return contextPtr
        }

        if (contextPtr != 0L) {
            WhisperLib.freeContext(contextPtr)
            contextPtr = 0L
            Log.i(TAG, "Freed previous Whisper context ($currentModelType)")
        }

        val startLoad = SystemClock.elapsedRealtime()
        val modelsDir = File(context.filesDir, "models")
        if (!modelsDir.exists()) modelsDir.mkdirs()

        val modelFile = File(modelsDir, modelFileName)
        if (!modelFile.exists() || modelFile.length() < 1000) {
            Log.i(TAG, "Copying $modelFileName from assets to ${modelFile.absolutePath}...")
            context.assets.open("models/$modelFileName").use { input ->
                FileOutputStream(modelFile).use { output ->
                    input.copyTo(output)
                }
            }
        }

        modelFileSizeBytes = modelFile.length()
        contextPtr = WhisperLib.initContext(modelFile.absolutePath)
        currentModelType = targetModel
        modelLoadDurationMs = SystemClock.elapsedRealtime() - startLoad
        Log.i(TAG, "Whisper model ($targetModel) loaded in ${modelLoadDurationMs}ms (size=${modelFileSizeBytes / (1024 * 1024)}MB, ptr=$contextPtr)")
        return contextPtr
    }

    private fun getMemoryUsageMb(): Double {
        return try {
            val runtime = Runtime.getRuntime()
            val usedBytes = runtime.totalMemory() - runtime.freeMemory()
            usedBytes.toDouble() / (1024.0 * 1024.0)
        } catch (_: Exception) {
            0.0
        }
    }

    fun transcribe(
        audioData: FloatArray,
        language: String? = null,
        initialPrompt: String? = null,
        modelType: String? = "base",
        audioStats: AudioCaptureResult? = null,
        callback: (Result<Map<String, Any?>>) -> Unit
    ) {
        worker.execute {
            try {
                val ptr = ensureContext(modelType ?: "base")
                if (ptr == 0L) {
                    callback(Result.failure(RuntimeException("Whisper context initialization failed for model $modelType")))
                    return@execute
                }

                val startInference = SystemClock.elapsedRealtime()
                val nThreads = minOf(4, Runtime.getRuntime().availableProcessors())
                val res = WhisperLib.fullTranscribe(ptr, nThreads, audioData, language, initialPrompt)
                val durationMs = SystemClock.elapsedRealtime() - startInference

                if (res != 0) {
                    Log.w(TAG, "Whisper transcription returned code $res")
                    callback(Result.failure(RuntimeException("Inference failed with code $res")))
                    return@execute
                }

                val detectedLanguage = WhisperLib.getDetectedLanguage(ptr)
                val segmentCount = WhisperLib.getTextSegmentCount(ptr)
                val segments = ArrayList<String>()
                val sb = StringBuilder()
                for (i in 0 until segmentCount) {
                    val rawSeg = WhisperLib.getTextSegment(ptr, i)
                    val seg = rawSeg.replace("[BLANK_AUDIO]", "").replace(Regex("""\[.*?\]"""), "").trim()
                    if (seg.isNotEmpty()) {
                        segments.add(seg)
                        sb.append(seg).append(" ")
                    }
                }

                val transcript = sb.toString().trim()
                val audioDurationMs = audioStats?.durationMs ?: ((audioData.size.toLong() * 1000L) / 16000L)
                val peak = audioStats?.peakAmplitude ?: 0.0f
                val rms = audioStats?.rmsAmplitude ?: 0.0f
                val modelSizeMb = modelFileSizeBytes.toDouble() / (1024.0 * 1024.0)
                val memUsageMb = getMemoryUsageMb()

                // In debug builds only: log full diagnostics for offline transcription inspection
                val isDebug = (context.applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE) != 0
                if (isDebug) {
                    Log.d("VoiceExpenseDebug", "=== Stage 1 Base/Tiny STT Comparison Diagnostics ===")
                    Log.d("VoiceExpenseDebug", "Model: $currentModelType (${String.format("%.1f", modelSizeMb)} MB), Memory: ${String.format("%.1f", memUsageMb)} MB")
                    Log.d("VoiceExpenseDebug", "Prompt: \"${initialPrompt ?: "none"}\"")
                    Log.d("VoiceExpenseDebug", "Mode: language=${language ?: "auto"} (detected: $detectedLanguage)")
                    Log.d("VoiceExpenseDebug", "Timing: audio=${audioDurationMs}ms, inference=${durationMs}ms, modelLoad=${modelLoadDurationMs}ms")
                    Log.d("VoiceExpenseDebug", "Audio levels: peak=$peak, rms=$rms")
                    Log.d("VoiceExpenseDebug", "Raw Whisper transcript: \"$transcript\"")
                    segments.forEachIndexed { idx, s ->
                        Log.d("VoiceExpenseDebug", "  Segment #$idx: \"$s\"")
                    }
                }

                Log.i(TAG, "Transcription completed ($currentModelType) in ${durationMs}ms with $segmentCount segments (lang=$detectedLanguage)")

                val result = mapOf(
                    "transcript" to transcript,
                    "detectedLanguage" to detectedLanguage,
                    "audioDurationMs" to audioDurationMs,
                    "durationMs" to durationMs,
                    "modelLoadMs" to modelLoadDurationMs,
                    "segmentCount" to segmentCount,
                    "segments" to segments,
                    "peakAmplitude" to peak.toDouble(),
                    "rmsAmplitude" to rms.toDouble(),
                    "modelName" to currentModelType,
                    "modelSizeMb" to modelSizeMb,
                    "memoryUsageMb" to memUsageMb,
                    "initialPrompt" to (initialPrompt ?: "")
                )
                callback(Result.success(result))
            } catch (e: Exception) {
                Log.e(TAG, "Whisper transcription exception", e)
                callback(Result.failure(e))
            }
        }
    }

    fun transcribeConsecutive3x(
        audioData: FloatArray,
        language: String? = null,
        initialPrompt: String? = null,
        modelType: String? = "base",
        audioStats: AudioCaptureResult? = null,
        callback: (Result<Map<String, Any?>>) -> Unit
    ) {
        worker.execute {
            try {
                val ptr = ensureContext(modelType ?: "base")
                if (ptr == 0L) {
                    callback(Result.failure(RuntimeException("Whisper context init failed for model $modelType")))
                    return@execute
                }
                val nThreads = minOf(4, Runtime.getRuntime().availableProcessors())
                val runs = ArrayList<Map<String, Any?>>()

                for (runIndex in 1..3) {
                    val start = SystemClock.elapsedRealtime()
                    val res = WhisperLib.fullTranscribe(ptr, nThreads, audioData, language, initialPrompt)
                    val durationMs = SystemClock.elapsedRealtime() - start

                    if (res != 0) {
                        callback(Result.failure(RuntimeException("Run $runIndex failed with code $res")))
                        return@execute
                    }

                    val segCount = WhisperLib.getTextSegmentCount(ptr)
                    val sb = StringBuilder()
                    for (i in 0 until segCount) {
                        val rawSeg = WhisperLib.getTextSegment(ptr, i)
                        val cleaned = rawSeg.replace("[BLANK_AUDIO]", "").replace(Regex("""\[.*?\]"""), "").trim()
                        if (cleaned.isNotEmpty()) sb.append(cleaned).append(" ")
                    }
                    val t = sb.toString().trim()
                    runs.add(mapOf(
                        "run" to runIndex,
                        "transcript" to t,
                        "durationMs" to durationMs
                    ))
                    val isDebug = (context.applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE) != 0
                    if (isDebug) {
                        Log.i(TAG, "Consecutive Run #$runIndex: \"$t\" (${durationMs}ms)")
                    } else {
                        Log.i(TAG, "Consecutive Run #$runIndex: ${durationMs}ms")
                    }
                }

                val run1 = runs[0]["transcript"] as String
                val run2 = runs[1]["transcript"] as String
                val run3 = runs[2]["transcript"] as String
                val isIdentical = (run1 == run2 && run2 == run3)

                val result = mapOf(
                    "isIdentical" to isIdentical,
                    "runs" to runs,
                    "run1" to run1,
                    "run2" to run2,
                    "run3" to run3,
                    "dur1" to (runs[0]["durationMs"] as Long),
                    "dur2" to (runs[1]["durationMs"] as Long),
                    "dur3" to (runs[2]["durationMs"] as Long)
                )
                callback(Result.success(result))
            } catch (e: Exception) {
                Log.e(TAG, "Consecutive 3x test exception", e)
                callback(Result.failure(e))
            }
        }
    }

    @Synchronized
    fun release() {
        if (contextPtr != 0L) {
            WhisperLib.freeContext(contextPtr)
            contextPtr = 0L
            currentModelType = ""
            Log.i(TAG, "Whisper context freed")
        }
    }

    companion object {
        private const val TAG = "WhisperBridge"
    }
}
