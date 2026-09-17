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
    private val smsPermissionRequest = 7102
    private var smsPermissionResult: MethodChannel.Result? = null
    private var sharedReceiptChannel: MethodChannel? = null
    private var smsDetectionChannel: MethodChannel? = null
    private var pendingReceiptPath: String? = null
    private var pendingNotificationPayload: String? = null
    private var pendingVoiceExpenseLaunch = false
    private var smartReceiptBridge: SmartReceiptBridge? = null
    private var voiceExpenseBridge: VoiceExpenseBridge? = null

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        handleNotificationIntent(intent)
        handleVoiceExpenseIntent(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        smartReceiptBridge = SmartReceiptBridge(this, flutterEngine.dartExecutor.binaryMessenger)
        voiceExpenseBridge = VoiceExpenseBridge(this, flutterEngine.dartExecutor.binaryMessenger)
        if (pendingVoiceExpenseLaunch) {
            voiceExpenseBridge?.setPendingWidgetLaunch(true)
            pendingVoiceExpenseLaunch = false
        }
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

        smsDetectionChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "dinarwise/sms_detection"
        ).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "isSupported" -> {
                        result.success(isReceiveSmsDeclared())
                    }
                    "getInitialNotificationPayload" -> {
                        val p = pendingNotificationPayload
                        pendingNotificationPayload = null
                        result.success(p)
                    }
                    "hasPermission" -> {
                        if (!isReceiveSmsDeclared()) {
                            result.success(false)
                        } else {
                            val smsGranted = androidx.core.content.ContextCompat.checkSelfPermission(
                                this@MainActivity,
                                android.Manifest.permission.RECEIVE_SMS
                            ) == android.content.pm.PackageManager.PERMISSION_GRANTED
                            result.success(smsGranted)
                        }
                    }
                    "requestPermission" -> {
                        if (!isReceiveSmsDeclared()) {
                            result.success(mapOf("granted" to false, "permanentlyDenied" to false))
                        } else {
                            val permsNeeded = mutableListOf<String>()
                            if (androidx.core.content.ContextCompat.checkSelfPermission(
                                    this@MainActivity,
                                    android.Manifest.permission.RECEIVE_SMS
                                ) != android.content.pm.PackageManager.PERMISSION_GRANTED
                            ) {
                                permsNeeded.add(android.Manifest.permission.RECEIVE_SMS)
                            }
                            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.TIRAMISU) {
                                if (androidx.core.content.ContextCompat.checkSelfPermission(
                                        this@MainActivity,
                                        android.Manifest.permission.POST_NOTIFICATIONS
                                    ) != android.content.pm.PackageManager.PERMISSION_GRANTED
                                ) {
                                    permsNeeded.add(android.Manifest.permission.POST_NOTIFICATIONS)
                                }
                            }

                            if (permsNeeded.isEmpty()) {
                                result.success(mapOf("granted" to true, "permanentlyDenied" to false))
                            } else {
                                smsPermissionResult = result
                                androidx.core.app.ActivityCompat.requestPermissions(
                                    this@MainActivity,
                                    permsNeeded.toTypedArray(),
                                    smsPermissionRequest
                                )
                            }
                        }
                    }
                    "openAppSettings" -> {
                        try {
                            val intent = Intent(android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                                data = Uri.fromParts("package", packageName, null)
                            }
                            startActivity(intent)
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("open_settings_failed", e.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
        }

        if (isReceiveSmsDeclared()) {
            SmsReceiver.listener = { sender, body, timestamp ->
                runOnUiThread {
                    smsDetectionChannel?.invokeMethod(
                        "onSmsReceived",
                        mapOf(
                            "sender" to sender,
                            "body" to body,
                            "timestamp" to timestamp
                        )
                    )
                }
            }
        }
    }

    private fun handleNotificationIntent(intent: Intent?) {
        val payload = intent?.getStringExtra("payload") ?: return
        if (smsDetectionChannel != null) {
            smsDetectionChannel?.invokeMethod("onNotificationOpened", payload)
        } else {
            pendingNotificationPayload = payload
        }
    }

    private fun isReceiveSmsDeclared(): Boolean {
        return try {
            val packageInfo = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.TIRAMISU) {
                packageManager.getPackageInfo(
                    packageName,
                    android.content.pm.PackageManager.PackageInfoFlags.of(android.content.pm.PackageManager.GET_PERMISSIONS.toLong())
                )
            } else {
                @Suppress("DEPRECATION")
                packageManager.getPackageInfo(packageName, android.content.pm.PackageManager.GET_PERMISSIONS)
            }
            packageInfo.requestedPermissions?.contains(android.Manifest.permission.RECEIVE_SMS) == true
        } catch (_: Exception) {
            false
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleNotificationIntent(intent)
        handleVoiceExpenseIntent(intent)
        val path = receiptPath(intent) ?: return
        if (sharedReceiptChannel == null) {
            pendingReceiptPath = path
        } else {
            sharedReceiptChannel?.invokeMethod("sharedReceipt", path)
        }
    }

    private fun handleVoiceExpenseIntent(intent: Intent?) {
        if (intent == null) return
        val action = intent.action
        val extraAction = intent.getStringExtra("action")
        if (action == VoiceExpenseWidgetProvider.ACTION_VOICE_EXPENSE || extraAction == "voice_expense") {
            if (voiceExpenseBridge != null) {
                voiceExpenseBridge?.triggerWidgetLaunch()
            } else {
                pendingVoiceExpenseLaunch = true
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
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

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == smsPermissionRequest) {
            val smsIndex = permissions.indexOf(android.Manifest.permission.RECEIVE_SMS)
            val smsGranted = smsIndex != -1 && grantResults.getOrNull(smsIndex) == android.content.pm.PackageManager.PERMISSION_GRANTED
            val permanentlyDenied = if (smsIndex != -1 && !smsGranted) {
                !androidx.core.app.ActivityCompat.shouldShowRequestPermissionRationale(
                    this,
                    android.Manifest.permission.RECEIVE_SMS
                )
            } else {
                false
            }
            smsPermissionResult?.success(
                mapOf(
                    "granted" to smsGranted,
                    "permanentlyDenied" to permanentlyDenied
                )
            )
            smsPermissionResult = null
        }
        voiceExpenseBridge?.handleRequestPermissionsResult(requestCode, permissions, grantResults)
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        SmsReceiver.listener = null
        smsDetectionChannel = null
        smartReceiptBridge?.close()
        smartReceiptBridge = null
        voiceExpenseBridge = null
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
