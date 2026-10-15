package com.sl.dinarwise.expensemanager

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

/**
 * Native Android Home Screen Quick Widget Provider for DinarWise.
 *
 * Provides instant launcher actions:
 * - Camera: Smart Bill scan
 * - Media: Receipt image picker
 * - Voice: Voice Expense
 */
class DinarWiseWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        const val ACTION_WIDGET_CAMERA = "com.sl.dinarwise.ACTION_WIDGET_CAMERA"
        const val ACTION_WIDGET_MEDIA = "com.sl.dinarwise.ACTION_WIDGET_MEDIA"
        const val ACTION_WIDGET_VOICE = "com.sl.dinarwise.ACTION_WIDGET_VOICE"
        const val ACTION_WIDGET_SEARCH = "com.sl.dinarwise.ACTION_WIDGET_SEARCH"

        private const val REQUEST_CODE_MAIN = 7119
        private const val REQUEST_CODE_CAMERA = 7120
        private const val REQUEST_CODE_MEDIA = 7121
        private const val REQUEST_CODE_VOICE = 7122
        private const val REQUEST_CODE_SEARCH = 7123

        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val mainIntent = Intent(context, MainActivity::class.java).apply {
                action = Intent.ACTION_MAIN
                addCategory(Intent.CATEGORY_LAUNCHER)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP
            }
            val mainPendingIntent = PendingIntent.getActivity(
                context,
                REQUEST_CODE_MAIN,
                mainIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val searchIntent = Intent(context, MainActivity::class.java).apply {
                action = ACTION_WIDGET_SEARCH
                putExtra("widget_action", ACTION_WIDGET_SEARCH)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP
            }
            val searchPendingIntent = PendingIntent.getActivity(
                context,
                REQUEST_CODE_SEARCH,
                searchIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val cameraIntent = Intent(context, MainActivity::class.java).apply {
                action = ACTION_WIDGET_CAMERA
                putExtra("widget_action", ACTION_WIDGET_CAMERA)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP
            }
            val cameraPendingIntent = PendingIntent.getActivity(
                context,
                REQUEST_CODE_CAMERA,
                cameraIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val mediaIntent = Intent(context, MainActivity::class.java).apply {
                action = ACTION_WIDGET_MEDIA
                putExtra("widget_action", ACTION_WIDGET_MEDIA)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP
            }
            val mediaPendingIntent = PendingIntent.getActivity(
                context,
                REQUEST_CODE_MEDIA,
                mediaIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val voiceIntent = Intent(context, MainActivity::class.java).apply {
                action = ACTION_WIDGET_VOICE
                putExtra("widget_action", ACTION_WIDGET_VOICE)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP
            }
            val voicePendingIntent = PendingIntent.getActivity(
                context,
                REQUEST_CODE_VOICE,
                voiceIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val views = RemoteViews(context.packageName, R.layout.dinarwise_quick_widget).apply {
                setOnClickPendingIntent(R.id.widget_brand_section, mainPendingIntent)
                setOnClickPendingIntent(R.id.widget_search_bar, searchPendingIntent)
                setOnClickPendingIntent(R.id.widget_action_camera, cameraPendingIntent)
                setOnClickPendingIntent(R.id.widget_action_media, mediaPendingIntent)
                setOnClickPendingIntent(R.id.widget_action_voice, voicePendingIntent)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
