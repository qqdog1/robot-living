import 'package:awesome_notifications/awesome_notifications.dart';

import '../const/system_const.dart';

class NotificationUtil {
  static void createNotification(int id, String title, String body, int weekday, int hour, int minute, bool repeat) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id, // 通知ID，用於取消通知
        channelKey: SystemConst.notificationChannel,
        title: title,
        body: body,
      ),
      schedule: NotificationCalendar(
        weekday: weekday,
        hour: hour,
        minute: minute,
        second: 0,
        millisecond: 0,
        repeats: repeat, // 設定重複
      ),
    );
  }

  static void cancelNotification(int id) {
    AwesomeNotifications().cancel(id);
  }
}