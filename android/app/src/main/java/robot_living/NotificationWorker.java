package robot_living;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Build;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.work.Worker;
import androidx.work.WorkerParameters;

import name.qd.robot_living.R;

import robot_living.dto.Notification;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Locale;

import javax.xml.transform.Result;

public class NotificationWorker extends Worker {

    public NotificationWorker(@NonNull Context context, @NonNull WorkerParameters workerParams) {
        super(context, workerParams);
    }

    @NonNull
    @Override
    public Result doWork() {
        Log.d("onHandleWork", "doWork");
        int taskId = getInputData().getInt("taskId", 0);
        // get next with same task id
        getNextAndRegister(taskId);
        return Result.success();
    }

    public void setupAlarm(int id, int taskId, String title, String body, int weekday, int hour, int minute, int second) {
        Log.d("setupAlarm", "準備註冊通知: id: " + id + ", taskId: " + taskId + ", title: " + title + ", body: " + body +
                ", weekday: " + weekday + ", hour: " + hour + ", minute: " + minute + ", second: " + second);

        AlarmManager alarmManager = (AlarmManager) getApplicationContext().getSystemService(Context.ALARM_SERVICE);

        // 創建一個 Intent，它將觸發一個廣播接收器
        Intent intent = new Intent(getApplicationContext(), AlarmReceiver.class);
        intent.setAction("name.qd.robot_living.ALARM_ACTION");
        intent.putExtra("title", title);
        intent.putExtra("body", body);
        intent.putExtra("id", id);
        intent.putExtra("taskId", taskId);

        PendingIntent pendingIntent = PendingIntent.getBroadcast(getApplicationContext(), id, intent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);

        int androidWeekday = weekday + 1;
        androidWeekday = androidWeekday == 8 ? 1 : androidWeekday;

        // 設置觸發時間
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.DAY_OF_WEEK, androidWeekday);
        calendar.set(Calendar.HOUR_OF_DAY, hour);
        calendar.set(Calendar.MINUTE, minute);
        calendar.set(Calendar.SECOND, second);

        // 檢查設置時間是否已經過去，若過去則設置為下一周
        if (calendar.getTimeInMillis() <= System.currentTimeMillis()) {
            calendar.add(Calendar.DAY_OF_YEAR, 7);
            Log.d("NextWeek", "應為下周觸發,加7天");
        }
        Log.d("register time", "註冊下次通知時間:" + calendar.getTime());

//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) { // Android 6.0 (API 23) and above
//            Log.d("register", "使用android 6以上註冊方式");
//            alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), pendingIntent);
//        } else
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) { // Android 5.0 (API 21) and above
            Log.d("register", "使用android 5以上註冊方式");
            alarmManager.setAlarmClock(new AlarmManager.AlarmClockInfo(calendar.getTimeInMillis(), pendingIntent), pendingIntent);
        } else { // Below Android 5.0
            Log.d("register", "使用android 5以前註冊方式");
            alarmManager.setExact(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), pendingIntent);
        }
    }

    private void getNextAndRegister(int taskId) {
        String fileContent = readFromFile(getApplicationContext(), "settings.txt");
        if (fileContent != null && !fileContent.equals("")) {
            JSONObject userSettings = null;
            try {
                userSettings = new JSONObject(fileContent);
                // 查找下一個通知
                ArrayList<Notification> list = parseNotificationList(userSettings, taskId);
                if (list != null) {
                    Notification notification = getNextNotification(list);
                    if (notification != null) {
                        setupAlarm(notification.getId(), notification.getTaskId(), notification.getTitle(), notification.getBody(),
                                notification.getWeekday(), notification.getHour(), notification.getMinute(), notification.getSecond());
                    }
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    }

    private String readFromFile(Context context, String fileName) {
        File directory = context.getFilesDir();
        File file = new File(directory, fileName);
        StringBuilder stringBuilder = new StringBuilder();
        try {
            FileInputStream fis = new FileInputStream(file);
            InputStreamReader isr = new InputStreamReader(fis);
            BufferedReader reader = new BufferedReader(isr);
            String line;
            while ((line = reader.readLine()) != null) {
                stringBuilder.append(line);
            }
            reader.close();
            isr.close();
            fis.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return stringBuilder.toString();
    }

    private ArrayList<Notification> parseNotificationList(JSONObject userSettings, int targetTaskId) {
        try {
            JSONObject notificationMap = userSettings.getJSONObject("notificationMap");
            JSONArray mapArray = notificationMap.getJSONArray("notificationMap");
            ArrayList<Notification> lst = new ArrayList<>();
            for (int i = 0; i < mapArray.length(); i++) {
                JSONObject entity = mapArray.getJSONObject(i);
                int taskId = entity.getInt("taskId");
                if (taskId != targetTaskId) continue;
                JSONArray nofArray = entity.getJSONArray("notifications");
                for (int j = 0; j < nofArray.length(); j++) {
                    JSONObject nof = nofArray.getJSONObject(j);
                    int id = nof.getInt("id");
                    Notification notification = new Notification();
                    notification.setId(id);
                    notification.setTaskId(taskId);
                    notification.setTitle(nof.getString("title"));
                    notification.setBody(nof.getString("body"));
                    notification.setWeekday(nof.getInt("weekday"));
                    notification.setHour(nof.getInt("hour"));
                    notification.setMinute(nof.getInt("minute"));
                    notification.setSecond(nof.getInt("second"));
                    lst.add(notification);
                }
            }
            return lst;
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Notification getNextNotification(ArrayList<Notification> notifications) {
        Calendar now = Calendar.getInstance();
        int shortestMinutes = 60 * 24 * 7;
        Notification nextNotification = null;
        Notification zeroGapNotification = null;

        for (Notification notification : notifications) {
            int gapMin = getGapMinutes(now, notification);
            if (gapMin < shortestMinutes && gapMin != 0) {
                shortestMinutes = gapMin;
                nextNotification = notification;
            } else if (gapMin == 0) {
                zeroGapNotification = notification;
            }
        }

        if (nextNotification == null && zeroGapNotification != null) {
            nextNotification = zeroGapNotification;
        }

        return nextNotification;
    }

    private int getGapMinutes(Calendar calendar, Notification notification) {
        int diffDay = notification.getWeekday() == 7 ? -calendar.get(Calendar.DAY_OF_WEEK) + 1
                : notification.getWeekday() - calendar.get(Calendar.DAY_OF_WEEK) + 1;
        int diffHour = notification.getHour() - calendar.get(Calendar.HOUR_OF_DAY);
        int diffMin = notification.getMinute() - calendar.get(Calendar.MINUTE);
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
