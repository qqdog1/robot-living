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
import com.example.robot_living.dto.Notification
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONException
import org.json.JSONObject
import java.io.*
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
            val id = uri.getQueryParameter("id")
            if (id != null) {
                // 讀檔
                var fileContent = readFromFile(this, "settings.txt")
                if (fileContent.isNotEmpty()) {
                    // 查下一個通知
                    val lst = parseNotificationList(fileContent, Integer.parseInt(id))
                    if (lst != null) {
                        Log.i("list", lst.size.toString())
                        val notification = getNextNotification(lst)
                        if (notification != null) {
                            Log.i("setup next", notification.id.toString())
                            setupAlarm(notification.id, notification.title, notification.body, notification.weekday, notification.hour, notification.minute)
                        }
                    }
                }
                // 跳到flutter特定頁面 現在先用不到
//                flutterEngine?.let {
//                    MethodChannel(it.dartExecutor.binaryMessenger, CHANNEL).invokeMethod("navigateToNotificationPage", id)
//                } ?: Log.e("MainActivity", "Flutter engine not initialized when trying to navigate to notification page")
            } else {
                Log.i("MainActivity", "No ID found in the URI")
            }
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name: CharSequence = "Standard Notifications"
            val description = "Description for this channel"
            val importance = NotificationManager.IMPORTANCE_HIGH
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

        var androidWeekday = weekday + 1

        // 設置觸發時間
        val calendar = Calendar.getInstance().apply {
            set(Calendar.DAY_OF_WEEK, androidWeekday)
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

    private fun readFromFile(context: Context, fileName: String?): String {
        val directory = context.filesDir
        val file = File(directory, fileName)
        val stringBuilder = StringBuilder()
        try {
            val fis = FileInputStream(file)
            val isr = InputStreamReader(fis)
            val reader = BufferedReader(isr)
            var line: String?
            while (reader.readLine().also { line = it } != null) {
                stringBuilder.append(line)
            }
            reader.close()
            isr.close()
            fis.close()
        } catch (e: IOException) {
            e.printStackTrace()
        }
        return stringBuilder.toString()
    }

    private fun parseNotificationList(jsonString: String, id: Int) : MutableList<Notification>? {
        Log.i("data", jsonString)
        try {
            var targetTaskId: Int = 0
            // parsing json to map
            val userSettings = JSONObject(jsonString)
            val notificationMap = userSettings.getJSONObject("notificationMap")
            val mapArray = notificationMap.getJSONArray("notificationMap")
            val map = HashMap<Int, MutableList<Notification>>()
            for (i in 0 until mapArray.length()) {
                val entity = mapArray.getJSONObject(i)
                val taskId = entity.getInt("taskId")
                val lst = map.getOrPut(taskId) { mutableListOf() }
                val nofArray = entity.getJSONArray("notifications")

                for (j in 0 until nofArray.length()) {
                    val nof = nofArray.getJSONObject(j)
                    val nofId = nof.getInt("id")
                    if (nofId == id) {
                        targetTaskId = taskId
                    }
                    lst.add(Notification().apply {
                        this.id = nofId
                        this.title = nof.getString("title")
                        this.body = nof.getString("body")
                        this.weekday = nof.getInt("weekday")
                        this.hour = nof.getInt("hour")
                        this.minute = nof.getInt("minute")
                    })
                }
            }
            //
            return map[targetTaskId]
        } catch (e: JSONException) {
            e.printStackTrace()
        }
        return null
    }

    private fun getNextNotification(notifications: MutableList<Notification>) : Notification? {
        val now = Calendar.getInstance()
        var shortestMinutes = 60 * 24 * 7
        var nextNotification: Notification? = null
        var zeroGapNotification: Notification? = null

        for (notification : Notification in notifications ) {
            val gapMin = getGapMinutes(now, notification)
            if (gapMin < shortestMinutes && gapMin != 0) {
                shortestMinutes = gapMin
                nextNotification = notification
            } else if (gapMin == 0) {
                zeroGapNotification = notification
            }
        }

        if (nextNotification == null && zeroGapNotification != null) {
            nextNotification = zeroGapNotification
        }

        return nextNotification
    }

    private fun getGapMinutes(calendar: Calendar, notification: Notification) : Int {
        var diffDay = if (notification.weekday == 7) - calendar.get(Calendar.DAY_OF_WEEK) + 1
        else notification.weekday - calendar.get(Calendar.DAY_OF_WEEK) + 1
        var diffHour = notification.hour - calendar.get(Calendar.HOUR_OF_DAY)
        var diffMin = notification.minute - calendar.get(Calendar.MINUTE)
        if (diffMin < 0) {
            diffMin += 60;
            diffHour -= 1;
        }
        if (diffHour < 0) {
            diffHour += 24;
            diffDay -= 1;
        }
        if (diffDay < 0) diffDay += 7;
        return (((diffDay * 24) + diffHour) * 60) + diffMin;
    }
}
