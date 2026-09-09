package com.sl.dinarwise.expensemanager

import android.content.Intent
import android.net.Uri
import android.app.Activity
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterFragmentActivity() {
    private val pickFileRequest = 7101
    private var pickFileResult: MethodChannel.Result? = null
    private var sharedReceiptChannel: MethodChannel? = null
    private var pendingReceiptPath: String? = null
    private var smartReceiptBridge: SmartReceiptBridge? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        smartReceiptBridge = SmartReceiptBridge(this, flutterEngine.dartExecutor.binaryMessenger)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "dinarwise/file_share"
        ).setMethodCallHandler { call, result ->
            if (call.method != "share") {
                result.notImplemented()
                return@setMethodCallHandler
            }
            try {
                val filePath = call.argument<String>("path")!!
                val mimeType = call.argument<String>("mimeType") ?: "application/octet-stream"
                val uri = FileProvider.getUriForFile(
                    this,
                    "${applicationContext.packageName}.fileprovider",
                    File(filePath)
                )
                val intent = Intent(Intent.ACTION_SEND).apply {
                    type = mimeType
                    putExtra(Intent.EXTRA_STREAM, uri)
                    addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                }
                startActivity(Intent.createChooser(intent, "DinarWise"))
                result.success(null)
            } catch (error: Exception) {
                result.error("share_failed", error.message, null)
            }
        }
        sharedReceiptChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "dinarwise/shared_receipt"
        ).apply {
            setMethodCallHandler { call, result ->
                if (call.method == "getInitial") {
                    result.success(pendingReceiptPath ?: receiptPath(intent))
                    pendingReceiptPath = null
                } else {
                    result.notImplemented()
                }
            }
        }
        pendingReceiptPath = receiptPath(intent)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "dinarwise/file_picker"
        ).setMethodCallHandler { call, result ->
            if (call.method != "pick" || pickFileResult != null) {
                result.notImplemented()
                return@setMethodCallHandler
            }
            pickFileResult = result
            val mimeType = call.argument<String>("mimeType") ?: "*/*"
            startActivityForResult(
                Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
                    type = mimeType
                    addCategory(Intent.CATEGORY_OPENABLE)
                },
                pickFileRequest
            )
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val path = receiptPath(intent) ?: return
        if (sharedReceiptChannel == null) {
            pendingReceiptPath = path
        } else {
            sharedReceiptChannel?.invokeMethod("sharedReceipt", path)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (smartReceiptBridge?.onActivityResult(requestCode, resultCode, data) == true) return
        if (requestCode != pickFileRequest) return
        val callback = pickFileResult ?: return
        pickFileResult = null
        if (resultCode != Activity.RESULT_OK || data?.data == null) {
            callback.success(null)
            return
        }
        try {
            val uri = data.data!!
            val output = File(cacheDir, "import-${System.currentTimeMillis()}")
            contentResolver.openInputStream(uri)?.use { input ->
                output.outputStream().use { stream -> input.copyTo(stream) }
            } ?: throw IllegalStateException("Unable to read selected file")
            callback.success(output.absolutePath)
        } catch (error: Exception) {
            callback.error("pick_failed", error.message, null)
        }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        smartReceiptBridge?.close()
        smartReceiptBridge = null
        super.cleanUpFlutterEngine(flutterEngine)
    }

    private fun receiptPath(intent: Intent?): String? {
        if (intent?.action != Intent.ACTION_SEND || intent.type?.startsWith("image/") != true) {
            return null
        }
        @Suppress("DEPRECATION")
        val uri = intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM) ?: return null
        return try {
            val output = File(cacheDir, "shared-receipt-${System.currentTimeMillis()}.jpg")
            contentResolver.openInputStream(uri)?.use { input ->
                output.outputStream().use { stream -> input.copyTo(stream) }
            } ?: return null
            output.absolutePath
        } catch (_: Exception) {
            null
        }
    }
}
