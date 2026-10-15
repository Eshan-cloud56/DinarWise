package com.sl.dinarwise.expensemanager

import android.os.Build
import android.util.Log
import java.io.File

object WhisperLib {
    private const val TAG = "WhisperLib"

    init {
        var loaded = false
        val primaryAbi = Build.SUPPORTED_ABIS.firstOrNull() ?: ""
        if (primaryAbi == "arm64-v8a") {
            val cpuInfo = cpuInfo()
            if (cpuInfo?.contains("fphp") == true) {
                try {
                    System.loadLibrary("whisper_v8fp16_va")
                    loaded = true
                    Log.i(TAG, "Loaded optimized whisper_v8fp16_va")
                } catch (_: UnsatisfiedLinkError) {}
            }
        } else if (primaryAbi == "armeabi-v7a") {
            val cpuInfo = cpuInfo()
            if (cpuInfo?.contains("vfpv4") == true) {
                try {
                    System.loadLibrary("whisper_vfpv4")
                    loaded = true
                    Log.i(TAG, "Loaded optimized whisper_vfpv4")
                } catch (_: UnsatisfiedLinkError) {}
            }
        }

        if (!loaded) {
            try {
                System.loadLibrary("whisper")
                Log.i(TAG, "Loaded standard whisper library")
            } catch (e: UnsatisfiedLinkError) {
                Log.e(TAG, "Failed to load whisper library", e)
            }
        }
    }

    private fun cpuInfo(): String? {
        return try {
            File("/proc/cpuinfo").inputStream().bufferedReader().use { it.readText() }
        } catch (_: Exception) {
            null
        }
    }

    external fun initContext(modelPath: String): Long
    external fun freeContext(contextPtr: Long)
    external fun fullTranscribe(contextPtr: Long, numThreads: Int, audioData: FloatArray, language: String? = null, initialPrompt: String? = null): Int
    external fun getDetectedLanguage(contextPtr: Long): String
    external fun getTextSegmentCount(contextPtr: Long): Int
    external fun getTextSegment(contextPtr: Long, index: Int): String
    external fun getSystemInfo(): String
}
