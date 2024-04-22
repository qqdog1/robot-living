package com.example.robot_living

import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.*


class MainActivity: FlutterActivity() {
    private val CHANNEL = "robot_inner";

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createNotificationChannel() // 调用创建通知渠道的方法
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent) // 更新当前的 Intent 为最新的
        handleIntent(intent) // 处理 Intent
    }

    private fun handleIntent(intent: Intent) {
        val uri = intent.data
        if (uri != null && "robotliving" == uri.scheme && "notificationPage" == uri.host) {
            // 从 URI 提取数据，例如 ID
            val id = uri.getQueryParameter("id")
            // 根据 ID 处理业务逻辑，比如导航到特定页面
            if (id != null) {
                flutterEngine?.let {
                    MethodChannel(it.dartExecutor.binaryMessenger, CHANNEL).invokeMethod("navigateToNotificationPage", id)
                } ?: Log.e("MainActivity", "Flutter engine not initialized when trying to navigate to notification page")
            } else {
                Log.i("MainActivity", "No ID found in the URI")
            }
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name: CharSequence = "Standard Notifications"
            val description = "Description for this channel"
            val importance = NotificationManager.IMPORTANCE_DEFAULT
            val channel = NotificationChannel("robot_inner", name, importance)
            channel.description = description
            val notificationManager: NotificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            when (call.method) {
                "createAlarm" -> {
                    val id = call.argument<Int>("id")!!
                    val title = call.argument<String>("title")!!
                    val body = call.argument<String>("body")!!
                    val weekday = call.argument<Int>("weekday")!!
                    val hour = call.argument<Int>("hour")!!
                    val minute = call.argument<Int>("minute")!!
                    setupAlarm(id, title, body, weekday, hour, minute)
                    result.success(true)
                }
                "cancelAlarm" -> {
                    val id = call.argument<Int>("id")!!
                    cancelAlarm(id)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun setupAlarm(id: Int, title: String, body: String, weekday: Int, hour: Int, minute: Int) {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager

        // 創建一個Intent，它將觸發一個廣播接收器
        val intent = Intent(this, AlarmReceiver::class.java).apply {
            action = "com.example.robot_living.ALARM_ACTION"
            putExtra("title", title)
            putExtra("body", body)
            putExtra("id", id)  // 可用於區分不同的通知
        }
        val pendingIntent = PendingIntent.getBroadcast(this, id, intent, PendingIntent.FLAG_UPDATE_CURRENT)

        // 設置觸發時間
        val calendar = Calendar.getInstance().apply {
            set(Calendar.DAY_OF_WEEK, weekday)
            set(Calendar.HOUR_OF_DAY, hour)
            set(Calendar.MINUTE, minute)
            set(Calendar.SECOND, 0)
        }

        // 檢查設置時間是否已經過去，若過去則設置為下一周
        if (calendar.timeInMillis <= System.currentTimeMillis()) {
            calendar.add(Calendar.DAY_OF_YEAR, 7)
        }
        alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, calendar.timeInMillis, pendingIntent)
    }

    private fun cancelAlarm(id: Int) {
        val intent = Intent(this, AlarmReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(this, id, intent, PendingIntent.FLAG_UPDATE_CURRENT)
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.cancel(pendingIntent)
        pendingIntent.cancel()
    }
}
