package com.sl.dinarwise.expensemanager

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.content.pm.PackageManager
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder
import android.util.Log
import androidx.core.content.ContextCompat
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicBoolean
import kotlin.math.abs
import kotlin.math.sqrt

data class AudioCaptureResult(
    val samples: FloatArray,
    val peakAmplitude: Float,
    val rmsAmplitude: Float,
    val durationMs: Long
)

class VoiceRecorder(private val activity: Activity) {
    private var recordThread: RecordThread? = null
    private val isRecording = AtomicBoolean(false)

    fun hasPermission(): Boolean {
        return ContextCompat.checkSelfPermission(
            activity,
            Manifest.permission.RECORD_AUDIO
        ) == PackageManager.PERMISSION_GRANTED
    }

    @Synchronized
    fun startRecording(onError: (Exception) -> Unit): Boolean {
        if (!hasPermission()) {
            onError(SecurityException("Microphone permission not granted"))
            return false
        }

        // Android 14+ foreground validation: verify activity is valid and visible
        if (activity.isFinishing || activity.isDestroyed) {
            onError(IllegalStateException("Cannot record audio while activity is not foregrounded"))
            return false
        }

        if (isRecording.getAndSet(true)) {
            return true // already recording
        }

        val thread = RecordThread(onError)
        recordThread = thread
        thread.start()

        // Wait until AudioRecord is initialized and capturing so the first word is never truncated
        val initialized = thread.readyLatch.await(1500, TimeUnit.MILLISECONDS)
        if (!initialized || thread.initError != null) {
            isRecording.set(false)
            recordThread = null
            onError(thread.initError ?: IllegalStateException("AudioRecord startup timed out"))
            return false
        }

        Log.i(TAG, "Audio recording active at 16kHz mono (hardware active)")
        return true
    }

    @Synchronized
    fun stopRecording(): AudioCaptureResult? {
        if (!isRecording.getAndSet(false)) {
            return null
        }

        val thread = recordThread ?: return null
        thread.stopRecording()
        try {
            thread.join(2000)
        } catch (_: InterruptedException) {}

        val result = thread.getAudioResult()
        recordThread = null
        Log.i(TAG, "Audio recording stopped, captured ${result.samples.size} samples (${result.durationMs}ms, peak=${result.peakAmplitude}, rms=${result.rmsAmplitude})")
        return result
    }

    @Synchronized
    fun cancelRecording() {
        if (isRecording.getAndSet(false)) {
            recordThread?.stopRecording()
            recordThread = null
            Log.i(TAG, "Audio recording cancelled")
        }
    }

    private class RecordThread(private val onError: (Exception) -> Unit) : Thread("DinarWiseAudioRecord") {
        private val quit = AtomicBoolean(false)
        val readyLatch = CountDownLatch(1)
        var initError: Exception? = null
        private val sampleBuffer = ArrayList<Short>(16000 * 5) // Pre-allocate ~5 seconds

        @SuppressLint("MissingPermission")
        override fun run() {
            var audioRecord: AudioRecord? = null
            try {
                val sampleRate = 16000
                val channelConfig = AudioFormat.CHANNEL_IN_MONO
                val audioFormat = AudioFormat.ENCODING_PCM_16BIT
                val minBufferSize = AudioRecord.getMinBufferSize(sampleRate, channelConfig, audioFormat)
                val bufferSize = maxOf(minBufferSize * 2, 4096)
                val chunk = ShortArray(bufferSize / 2)

                // Prefer VOICE_RECOGNITION for tuned speech recognition / noise suppression, fallback to MIC
                audioRecord = try {
                    AudioRecord(
                        MediaRecorder.AudioSource.VOICE_RECOGNITION,
                        sampleRate,
                        channelConfig,
                        audioFormat,
                        bufferSize
                    ).takeIf { it.state == AudioRecord.STATE_INITIALIZED }
                } catch (_: Exception) { null }

                if (audioRecord == null) {
                    audioRecord = AudioRecord(
                        MediaRecorder.AudioSource.MIC,
                        sampleRate,
                        channelConfig,
                        audioFormat,
                        bufferSize
                    )
                }

                if (audioRecord.state != AudioRecord.STATE_INITIALIZED) {
                    throw IllegalStateException("AudioRecord initialization failed")
                }

                audioRecord.startRecording()
                readyLatch.countDown()

                while (!quit.get()) {
                    val readCount = audioRecord.read(chunk, 0, chunk.size)
                    if (readCount > 0) {
                        synchronized(sampleBuffer) {
                            for (i in 0 until readCount) {
                                sampleBuffer.add(chunk[i])
                            }
                        }
                    } else if (readCount < 0) {
                        throw RuntimeException("AudioRecord read error: $readCount")
                    }
                }
            } catch (e: Exception) {
                initError = e
                readyLatch.countDown()
                onError(e)
            } finally {
                try {
                    audioRecord?.stop()
                } catch (_: Exception) {}
                try {
                    audioRecord?.release()
                } catch (_: Exception) {}
            }
        }

        fun stopRecording() {
            quit.set(true)
        }

        fun getAudioResult(): AudioCaptureResult {
            synchronized(sampleBuffer) {
                val rawSize = sampleBuffer.size
                var peak = 0.0f
                var sumSquares = 0.0

                val rawFloats = FloatArray(rawSize) { i ->
                    val raw = sampleBuffer[i]
                    val floatVal = (raw.toFloat() / 32767.0f).coerceIn(-1.0f, 1.0f)
                    val absVal = abs(floatVal)
                    if (absVal > peak) peak = absVal
                    sumSquares += (floatVal * floatVal).toDouble()
                    floatVal
                }
                val fullRms = if (rawSize > 0) sqrt(sumSquares / rawSize).toFloat() else 0.0f
                sampleBuffer.clear()

                // Smart trailing silence trimming:
                // If recording is long enough (>1.5s), find the last speech window
                // and trim excessive trailing silence, leaving a 350ms (5,600 samples) safety cushion.
                val finalFloats: FloatArray
                val finalSize: Int
                if (rawSize > 24000 && peak > 0.05f) {
                    val windowSize = 800 // 50ms at 16kHz
                    val threshold = maxOf(0.015f, peak * 0.06f)
                    var lastSpeechIdx = rawSize - 1
                    var w = rawSize - windowSize
                    while (w >= 16000) { // maintain at least 1.0s for Whisper
                        var wSum = 0.0
                        for (j in w until (w + windowSize)) {
                            val s = rawFloats[j]
                            wSum += (s * s).toDouble()
                        }
                        val wRms = sqrt(wSum / windowSize).toFloat()
                        if (wRms >= threshold) {
                            lastSpeechIdx = minOf(rawSize, w + windowSize + 5600) // +350ms cushion
                            break
                        }
                        w -= windowSize
                    }
                    finalSize = minOf(rawSize, maxOf(16000, lastSpeechIdx))
                    finalFloats = if (finalSize < rawSize) rawFloats.copyOfRange(0, finalSize) else rawFloats
                    if (finalSize < rawSize) {
                        Log.i(TAG, "Trimmed trailing silence: from $rawSize samples (${(rawSize*1000L)/16000L}ms) to $finalSize samples (${(finalSize*1000L)/16000L}ms)")
                    }
                } else {
                    finalFloats = rawFloats
                    finalSize = rawSize
                }

                val durationMs = (finalSize.toLong() * 1000L) / 16000L
                return AudioCaptureResult(finalFloats, peak, fullRms, durationMs)
            }
        }
    }

    companion object {
        private const val TAG = "VoiceRecorder"
    }
}
