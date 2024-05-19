package com.example.robot_living;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.util.Log;

import androidx.core.app.NotificationCompat;
import androidx.work.OneTimeWorkRequest;
import androidx.work.WorkManager;

public class AlarmReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        String title = intent.getStringExtra("title");
        String body = intent.getStringExtra("body");
        int id = intent.getIntExtra("id", 0);
        int taskId = intent.getIntExtra("taskId", 0);

        registerNext(context, taskId);
        showNotification(context, id, title, body);
    }

    private void registerNext(Context context, int taskId) {
        Log.d("registerNext", "準備下一則通知");
        OneTimeWorkRequest workRequest = new OneTimeWorkRequest.Builder(NotificationWorker.class)
                .setInputData(new androidx.work.Data.Builder()
                        .putInt("taskId", taskId)
                        .build())
                .build();
        WorkManager.getInstance(context).enqueue(workRequest);
    }

    private void showNotification(Context context, int id, String title, String body) {
        Intent notificationIntent = new Intent(Intent.ACTION_VIEW);
        // 目前不需要
//        Uri data = Uri.parse("robotliving://notificationPage?id=" + id);
//        notificationIntent.setData(data);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.DONUT) {
            notificationIntent.setPackage(context.getPackageName());  // 确保只有你的应用响应这个 Intent
        }
        PendingIntent pendingIntent = PendingIntent.getActivity(context, id, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        // 创建并显示通知
        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, "robot_inner")
                .setSmallIcon(R.drawable.ic_launcher)
                .setContentTitle(title)
                .setContentText(body)
                .setContentIntent(pendingIntent)
                .setAutoCancel(true);

        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        notificationManager.notify(id, builder.build());
    }
}
