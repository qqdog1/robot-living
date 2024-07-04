package robot_living;

import android.Manifest;
import android.app.AlarmManager;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.PowerManager;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.app.NotificationCompat;
import androidx.work.OneTimeWorkRequest;
import androidx.work.WorkManager;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import java.util.Calendar;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "robot_inner";
    private static final String ENGINE_ID = "flutter_engine";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        createNotificationChannel();
        requestExactAlarmPermission();
        disableBatteryOptimizations();
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        handleIntent(intent);
    }

    private void handleIntent(Intent intent) {
        if (intent.getData() != null && "robotliving".equals(intent.getData().getScheme()) && "notificationPage".equals(intent.getData().getHost())) {
            String id = intent.getData().getQueryParameter("id");
            if (id != null) {
                Log.i("MainActivity", "ID from URI: " + id);
                // getNextAndRegister(Integer.parseInt(id));
                // 跳到flutter特定頁面 現在先用不到
            } else {
                Log.i("MainActivity", "No ID found in the URI");
            }
        }
    }

    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = "Standard Notifications";
            String description = "Description for this channel";
            int importance = NotificationManager.IMPORTANCE_HIGH;
            NotificationChannel channel = new NotificationChannel("robot_inner", name, importance);
            channel.setDescription(description);
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        switch (call.method) {
                            case "createAlarm":
                                int id = call.argument("id");
                                int taskId = call.argument("taskId");
                                String title = call.argument("title");
                                String body = call.argument("body");
                                int weekday = call.argument("weekday");
                                int hour = call.argument("hour");
                                int minute = call.argument("minute");
                                setupAlarm(id, taskId, title, body, weekday, hour, minute);
                                result.success(true);
                                break;
                            case "cancelAlarm":
                                int cancelId = call.argument("id");
                                cancelAlarm(cancelId);
                                result.success(true);
                                break;
                            default:
                                result.notImplemented();
                                break;
                        }
                    }
                });
        FlutterEngineCache.getInstance().put(ENGINE_ID, flutterEngine);
    }

    private void cancelAlarm(int id) {
        Intent intent = new Intent(this, AlarmReceiver.class);
        intent.setAction("name.qd.robot_living.ALARM_ACTION");
        intent.putExtra("id", id);
        intent.putExtra("title", "dummy");
        intent.putExtra("body", "dummy");
        intent.putExtra("taskId", "dummy");
        PendingIntent pendingIntent = PendingIntent.getBroadcast(this, id, intent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
        AlarmManager alarmManager = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
        alarmManager.cancel(pendingIntent);
        pendingIntent.cancel();
        Log.d("canceled alarm", "" + id);
    }

    public void setupAlarm(int id, int taskId, String title, String body, int weekday, int hour, int minute) {
        Log.d("setupAlarm", "準備註冊通知: id: " + id + ", taskId: " + taskId + ", title: " + title + ", body: " + body +
                ", weekday: " + weekday + ", hour: " + hour + ", minute: " + minute);

        AlarmManager alarmManager = (AlarmManager) getSystemService(Context.ALARM_SERVICE);

        // 創建一個 Intent，它將觸發一個廣播接收器
        Intent intent = new Intent(this, AlarmReceiver.class);
        intent.setAction("name.qd.robot_living.ALARM_ACTION");
        intent.putExtra("title", title);
        intent.putExtra("body", body);
        intent.putExtra("id", id);
        intent.putExtra("taskId", taskId);

        PendingIntent pendingIntent = PendingIntent.getBroadcast(this, id, intent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);

        int androidWeekday = weekday + 1;
        androidWeekday = androidWeekday == 8 ? 1 : androidWeekday;

        // 設置觸發時間
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.DAY_OF_WEEK, androidWeekday);
        calendar.set(Calendar.HOUR_OF_DAY, hour);
        calendar.set(Calendar.MINUTE, minute);
        calendar.set(Calendar.SECOND, 0);

        // 檢查設置時間是否已經過去，若過去則設置為下一周
        if (calendar.getTimeInMillis() <= System.currentTimeMillis()) {
            calendar.add(Calendar.DAY_OF_YEAR, 7);
            Log.d("應為下周觸發", "加7天");
        }
        Log.d("register time", "註冊下次通知時間:" + calendar.get(Calendar.HOUR_OF_DAY) + ":" + calendar.get(Calendar.MINUTE));

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) { // Android 6.0 (API 23) and above
            Log.d("register", "使用android 6以上註冊方式");
            Log.d("canScheduleExactAlarms", String.valueOf(alarmManager.canScheduleExactAlarms()));
            alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), pendingIntent);
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) { // Android 5.0 (API 21) and above
            Log.d("register", "使用android 5以上註冊方式");
            alarmManager.setAlarmClock(new AlarmManager.AlarmClockInfo(calendar.getTimeInMillis(), pendingIntent), pendingIntent);
        } else { // Below Android 5.0
            Log.d("register", "使用android 5以前註冊方式");
            alarmManager.setExact(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), pendingIntent);
        }
    }

    private void disableBatteryOptimizations() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PowerManager pm = (PowerManager) getSystemService(Context.POWER_SERVICE);
            if (!pm.isIgnoringBatteryOptimizations(getPackageName())) {
                Intent intent = new Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
                intent.setData(Uri.parse("package:" + getPackageName()));
                startActivity(intent);
            }
        }
    }

    private void requestExactAlarmPermission() {
        if (Build.VERSION.SDK_INT >= 33) { // Android 13 (API 33) and above
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.POST_NOTIFICATIONS}, 1);
            }
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) { // Android 12 (API 31) and above
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.SCHEDULE_EXACT_ALARM) != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.SCHEDULE_EXACT_ALARM}, 1);
            }
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) { // Android 12 (API 31) and above
            AlarmManager alarmManager = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
            if (!alarmManager.canScheduleExactAlarms()) {
                Intent intent = new Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM);
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(intent);
            }
        }
    }
}
