package com.sl.dinarwise.expensemanager

import android.app.Activity
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.os.Handler
import android.os.Looper
import androidx.exifinterface.media.ExifInterface
import com.google.android.gms.tasks.Tasks
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.text.TextRecognition
import com.google.mlkit.vision.text.latin.TextRecognizerOptions
import com.googlecode.tesseract.android.TessBaseAPI
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicBoolean

/** Never logs OCR, receipt paths, or exceptions. */
class SmartReceiptBridge(private val activity: Activity, messenger: BinaryMessenger) {
    private val channel = MethodChannel(messenger, "dinarwise/smart_receipt")
    private val worker = Executors.newSingleThreadExecutor()
    private val main = Handler(Looper.getMainLooper())
    private val busy = AtomicBoolean(false)
    private var closed = false

    init {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "ocr" -> run(result) { recognize(
                    call.argument<String>("path") ?: "",
                    call.argument<String>("script") ?: "auto") }
                else -> result.notImplemented()
            }
        }
    }

    private fun run(result: MethodChannel.Result, work: () -> Any?) {
        if (!busy.compareAndSet(false, true)) {
            result.error("scan_busy", null, null); return
        }
        worker.execute {
            try {
                val value = work()
                main.post { if (!closed) result.success(value) }
            } catch (_: Exception) {
                main.post { if (!closed) result.error("scan_failed", null, null) }
            } catch (_: LinkageError) {
                main.post { if (!closed) result.error("device_unsupported", null, null) }
            } catch (_: OutOfMemoryError) {
                main.post { if (!closed) result.error("device_memory", null, null) }
            } finally { busy.set(false) }
        }
    }

    private fun bitmap(path: String): Bitmap {
        val file = File(path).canonicalFile
        val roots = listOfNotNull(File(activity.applicationInfo.dataDir), activity.externalCacheDir)
        require(roots.any { file.path.startsWith(it.canonicalPath + File.separator) })
        require(file.isFile && file.length() <= 25L * 1024 * 1024)
        val bounds = BitmapFactory.Options().apply { inJustDecodeBounds = true }
        BitmapFactory.decodeFile(path, bounds)
        require(bounds.outWidth > 0 && bounds.outHeight > 0)
        var sample = 1
        while (maxOf(bounds.outWidth, bounds.outHeight) / sample > 2400) sample *= 2
        val decoded = BitmapFactory.decodeFile(path, BitmapFactory.Options().apply {
            inSampleSize = sample
        }) ?: error("image_invalid")
        val exif = ExifInterface(path)
        val matrix = Matrix()
        if (exif.isFlipped) matrix.postScale(-1f, 1f)
        matrix.postRotate(exif.rotationDegrees.toFloat())
        if (matrix.isIdentity) return decoded
        return Bitmap.createBitmap(decoded, 0, 0, decoded.width, decoded.height, matrix, true)
            .also { if (it !== decoded) decoded.recycle() }
    }

    private fun recognize(path: String, script: String): Map<String, String> {
        val image = bitmap(path)
        try {
            if (script == "arabic") return mapOf("text" to arabic(image), "engine" to "tesseract")
            val recognizer = TextRecognition.getClient(TextRecognizerOptions.DEFAULT_OPTIONS)
            val latin = try {
                Tasks.await(recognizer.process(InputImage.fromBitmap(image, 0)), 45, TimeUnit.SECONDS)
            } finally { recognizer.close() }
            // ML Kit cannot reliably flag missing Arabic. Sparse output is a
            // conservative fallback; an explicit Arabic/mixed control is provided.
            val needsArabic = script == "auto" && (
                latin.text.count { it.isLetter() } < 40 ||
                !Regex("(?i)(total|amount|vat|tax)").containsMatchIn(latin.text) ||
                latin.textBlocks.any { it.recognizedLanguage.startsWith("ar") })
            if (needsArabic) {
                val mixed = arabic(image)
                if (Regex("[\u0600-\u06ff]").containsMatchIn(mixed) || latin.text.isBlank()) {
                    return mapOf("text" to mixed, "engine" to "tesseract")
                }
            }
            return mapOf("text" to latin.text, "engine" to "mlkit")
        } finally { image.recycle() }
    }

    private fun arabic(image: Bitmap): String {
        val root = File(activity.noBackupFilesDir, "receipt-ocr")
        val data = File(root, "tessdata").apply { mkdirs() }
        for (language in listOf("ara", "eng")) {
            val target = File(data, "$language.traineddata")
            if (!target.exists()) {
                val temp = File(data, "$language.partial")
                activity.assets.open("tessdata/$language.traineddata").use { input ->
                    temp.outputStream().use { input.copyTo(it) }
                }
                check(temp.renameTo(target))
            }
        }
        val tess = TessBaseAPI()
        try {
            check(tess.init(root.absolutePath, "ara+eng"))
            tess.setPageSegMode(TessBaseAPI.PageSegMode.PSM_AUTO)
            tess.setImage(image)
            return tess.getUTF8Text() ?: ""
        } finally { tess.recycle() }
    }

    fun close() {
        closed = true
        channel.setMethodCallHandler(null)
        worker.shutdown()
    }
}
