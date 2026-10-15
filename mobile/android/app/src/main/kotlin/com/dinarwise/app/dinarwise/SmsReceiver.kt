package com.sl.dinarwise.expensemanager

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony

class SmsReceiver : BroadcastReceiver() {
    companion object {
        var listener: ((sender: String, body: String, timestamp: Long) -> Unit)? = null
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Telephony.Sms.Intents.SMS_RECEIVED_ACTION) return
        val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent) ?: return
        if (messages.isEmpty()) return

        val sender = messages[0].displayOriginatingAddress ?: ""
        val bodyBuilder = StringBuilder()
        var timestamp: Long = System.currentTimeMillis()

        for (sms in messages) {
            bodyBuilder.append(sms.displayMessageBody)
            timestamp = sms.timestampMillis
        }

        listener?.invoke(sender, bodyBuilder.toString(), timestamp)
    }
}
