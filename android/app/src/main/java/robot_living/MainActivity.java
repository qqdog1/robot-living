package robot_living;

import android.app.AlarmManager;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import androidx.core.app.NotificationCompat;
import androidx.work.OneTimeWorkRequest;
import androidx.work.WorkManager;

import java.util.Calendar;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "robot_inner";
    private static final String ENGINE_ID = "flutter_engine";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        createNotificationChannel();
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
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
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

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            alarmManager.setAlarmClock(new AlarmManager.AlarmClockInfo(calendar.getTimeInMillis(), pendingIntent), pendingIntent);
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), pendingIntent);
        } else {
            alarmManager.setExact(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), pendingIntent);
        }
    }
}
