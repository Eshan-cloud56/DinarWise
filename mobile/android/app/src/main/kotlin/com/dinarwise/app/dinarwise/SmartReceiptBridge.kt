package com.sl.dinarwise.expensemanager

import android.app.Activity
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.os.Build
import android.os.Handler
import android.os.Looper
import androidx.exifinterface.media.ExifInterface
import com.google.android.gms.tasks.Tasks
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.text.TextRecognition
import com.google.mlkit.vision.text.latin.TextRecognizerOptions
import com.googlecode.tesseract.android.TessBaseAPI
import com.google.ai.edge.litertlm.*
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import java.io.File
import java.security.MessageDigest
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicBoolean

/** Never logs prompts, OCR, paths, exceptions or model output. */
class SmartReceiptBridge(private val activity: Activity, messenger: BinaryMessenger) {
    private val channel = MethodChannel(messenger, "dinarwise/smart_receipt")
    private val progressChannel = EventChannel(messenger, "dinarwise/smart_receipt_progress")
    private var progressSink: EventChannel.EventSink? = null
    private val worker = Executors.newSingleThreadExecutor()
    private val main = Handler(Looper.getMainLooper())
    private val busy = AtomicBoolean(false)
    private var importResult: MethodChannel.Result? = null
    private var importDigest: String? = null
    private var closed = false
    private var engine: Engine? = null
    private var initializedDigest: String? = null
    private val modelDir get() = File(activity.noBackupFilesDir, "receipt-model")
    private val model get() = File(modelDir, "gemma-3n-e2b.litertlm")
    private val digestFile get() = File(modelDir, "verified-sha256")

    init {
        progressChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                progressSink = events
            }
            override fun onCancel(arguments: Any?) { progressSink = null }
        })
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "modelStatus" -> {
                    val digest = call.argument<String>("sha256")
                    when {
                        !Build.SUPPORTED_ABIS.contains("arm64-v8a") ->
                            result.success("unsupported")
                        !installed(digest) -> result.success("missing")
                        else -> run(result) {
                            ensureEngine(digest!!)
                            "ready"
                        }
                    }
                }
                "importModel" -> {
                    if ((activity.applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE) == 0) {
                        result.error("development_only", null, null)
                        return@setMethodCallHandler
                    }
                    val digest = call.argument<String>("sha256") ?: ""
                    if (!digest.matches(Regex("[a-f0-9]{64}")) ||
                        !busy.compareAndSet(false, true)) {
                        result.error("model_unavailable", null, null)
                    } else {
                        importResult = result
                        importDigest = digest
                        try {
                            activity.startActivityForResult(Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
                                type = "*/*"
                                addCategory(Intent.CATEGORY_OPENABLE)
                            }, REQUEST_MODEL)
                        } catch (_: Exception) {
                            importResult = null
                            busy.set(false)
                            result.error("model_import_failed", null, null)
                        }
                    }
                }
                "ocr" -> run(result) { recognize(
                    call.argument<String>("path") ?: "",
                    call.argument<String>("script") ?: "auto") }
                "infer" -> run(result) {
                    val digest = call.argument<String>("sha256") ?: ""
                    check(installed(digest))
                    val prompt = call.argument<String>("prompt") ?: ""
                    require(prompt.length in 1..24000)
                    ensureEngine(digest).createConversation(ConversationConfig(
                            samplerConfig = SamplerConfig(topK = 1, topP = 1.0, temperature = 0.0),
                            maxOutputToken = 1024,
                            automaticToolCalling = false,
                        )).use { conversation ->
                            conversation.sendMessage(prompt).toString()
                        }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun installed(digest: String?): Boolean = digest != null &&
        digest.matches(Regex("[a-f0-9]{64}")) && model.isFile && model.length() > 0 &&
        digestFile.isFile && digestFile.readText() == digest

    /** Called only after the private model and its verified digest marker exist. */
    private fun ensureEngine(digest: String): Engine {
        check(installed(digest))
        if (engine != null && initializedDigest == digest) return engine!!
        engine?.close()
        engine = null
        initializedDigest = null
        Engine.setNativeMinLogSeverity(LogSeverity.INFINITY)
        return Engine(EngineConfig(
            modelPath = model.absolutePath,
            backend = Backend.CPU(),
            maxNumTokens = 4096,
            cacheDir = modelDir.absolutePath,
        )).also {
            it.initialize()
            engine = it
            initializedDigest = digest
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

    fun onActivityResult(request: Int, resultCode: Int, data: Intent?): Boolean {
        if (request != REQUEST_MODEL) return false
        val callback = importResult ?: return true
        val digest = importDigest ?: ""
        importResult = null
        val uri = data?.data
        if (resultCode != Activity.RESULT_OK || uri == null) {
            busy.set(false)
            callback.error("model_import_cancelled", null, null)
            return true
        }
        worker.execute {
            modelDir.mkdirs()
            val pending = File(modelDir, "model.partial")
            try {
                val hash = MessageDigest.getInstance("SHA-256")
                val expectedBytes = activity.contentResolver
                    .openAssetFileDescriptor(uri, "r")?.use { it.length } ?: -1L
                activity.contentResolver.openInputStream(uri)!!.use { input ->
                    pending.outputStream().use { output ->
                        val buffer = ByteArray(1024 * 1024)
                        var bytes = 0L
                        while (true) {
                            val read = input.read(buffer)
                            if (read < 0) break
                            bytes += read
                            require(bytes <= 6L * 1024 * 1024 * 1024)
                            require(!closed)
                            output.write(buffer, 0, read)
                            hash.update(buffer, 0, read)
                            if (bytes % (16 * 1024 * 1024) < read) {
                                main.post { if (!closed) progressSink?.success(mapOf(
                                    "bytes" to bytes, "total" to expectedBytes)) }
                            }
                        }
                    }
                }
                val actual = hash.digest().joinToString("") { "%02x".format(it) }
                check(actual == digest)
                engine?.close()
                engine = null
                initializedDigest = null
                model.delete()
                check(pending.renameTo(model))
                digestFile.writeText(digest)
                ensureEngine(digest)
                main.post { if (!closed) callback.success(null) }
            } catch (_: Exception) {
                main.post { if (!closed) callback.error("model_import_failed", null, null) }
            } finally {
                pending.delete()
                busy.set(false)
            }
        }
        return true
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
        progressChannel.setStreamHandler(null)
        worker.execute {
            engine?.close()
            engine = null
            initializedDigest = null
        }
        worker.shutdown()
    }
    companion object { const val REQUEST_MODEL = 7102 }
}
