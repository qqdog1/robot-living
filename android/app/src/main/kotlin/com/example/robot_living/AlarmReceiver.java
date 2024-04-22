package com.example.robot_living;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;

public class AlarmReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        String title = intent.getStringExtra("title");
        String body = intent.getStringExtra("body");
        int id = intent.getIntExtra("id", 0);

        Intent notificationIntent = new Intent(Intent.ACTION_VIEW);
        Uri data = Uri.parse("robotliving://notificationPage?id=" + id);
        notificationIntent.setData(data);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.DONUT) {
            notificationIntent.setPackage(context.getPackageName());  // 确保只有你的应用响应这个 Intent
        }
        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        // 创建并显示通知
        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, "robot_inner")
                .setSmallIcon(R.drawable.ic_launcher)
                .setContentTitle(title)
                .setContentText(body)
                .setContentIntent(pendingIntent)
                .setAutoCancel(true);

        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        notificationManager.notify(1, builder.build());
    }
}
