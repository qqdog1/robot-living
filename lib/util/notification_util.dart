import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:robot_living/const/daily_task_type.dart';
import 'package:robot_living/dto/daily_task_set.dart';
import 'package:robot_living/dto/duration_task.dart';
import 'package:robot_living/dto/one_time_task.dart';
import 'package:robot_living/dto/segmented_task.dart';

import '../const/system_const.dart';
import '../dto/daily_task.dart';
import '../dto/notification_object.dart';
import '../dto/notification_set.dart';
import '../dto/task.dart';

class NotificationUtil {
  static void createNotification(int id, String title, String body, int weekday,
      int hour, int minute, bool repeat) {
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

  static NotificationSet toNotificationSet(DailyTaskSet dailyTaskSet) {
    List<NotificationObject> notificationObjects = [];
    for (DailyTask dailyTask in dailyTaskSet.dailyTasks) {
      for (Task task in dailyTask.tasks) {
        List<NotificationObject> nof = toNotificationList(task);
        List<bool> triggered = dailyTask.triggered!;
        for (int index = 0; index < 7; index++) {
          if (triggered[index]) {
            for (NotificationObject notificationObject in nof) {
              NotificationObject copyNof = notificationObject.copy();
              int adjustedWeekday = index;
              if (notificationObject.crossDay) {
                adjustedWeekday = (index + 1) % 7; // 週日跨至週一需循環
              }
              if (adjustedWeekday == 0) {
                adjustedWeekday = 7; // awesome notification 星期日是7
              }
              copyNof.setWeekday(adjustedWeekday);
              notificationObjects.add(copyNof);
            }
          }
        }
      }
    }
    int id = 1;
    for (NotificationObject notification in notificationObjects) {
      notification.setId(id++);
    }
    return NotificationSet(notifications: notificationObjects);
  }

  static List<NotificationObject> toNotificationList(Task task) {
    switch (task.type) {
      case DailyTaskType.durationTask:
        return durationTaskToNotificationList(task as DurationTask);
      case DailyTaskType.segmentedTask:
        return segmentedTaskToNotificationList(task as SegmentedTask);
      case DailyTaskType.oneTimeTask:
        return oneTimeTaskToNotificationList(task as OneTimeTask);
    }
  }

  static List<NotificationObject> durationTaskToNotificationList(
      DurationTask durationTask) {
    List<NotificationObject> notifications = [];
    List<String> startTimes = durationTask.start.split(":");
    List<String> endTimes = durationTask.end.split(":");
    int startHour = int.parse(startTimes[0]);
    int startMinute = int.parse(startTimes[1]);
    int endHour = int.parse(endTimes[0]);
    int endMinute = int.parse(endTimes[1]);
    bool crossDay = endHour < startHour ||
        (endHour == startHour && endMinute < startMinute);
    notifications.add(NotificationObject(
        title: "${durationTask.name} start",
        body: "",
        hour: int.parse(startTimes[0]),
        minute: int.parse(startTimes[1])));
    notifications.add(NotificationObject(
        title: "${durationTask.name} end",
        body: "",
        hour: int.parse(endTimes[0]),
        minute: int.parse(endTimes[1]),
        crossDay: crossDay));
    return notifications;
  }

  static List<NotificationObject> segmentedTaskToNotificationList(
      SegmentedTask segmentedTask) {
    List<NotificationObject> notifications = [];

    // 解析開始和結束時間
    List<String> startTimeParts = segmentedTask.start.split(":");
    List<String> endTimeParts = segmentedTask.end.split(":");

    int startHour = int.parse(startTimeParts[0]);
    int startMinute = int.parse(startTimeParts[1]);
    int endHour = int.parse(endTimeParts[0]);
    int endMinute = int.parse(endTimeParts[1]);

    // 創建開始和結束時間
    DateTime startTime = DateTime(2020, 1, 1, startHour, startMinute); // 使用假日期
    DateTime endTime = DateTime(2020, 1, 1, endHour, endMinute); // 使用假日期

    // 處理跨日情況
    if (endTime.isBefore(startTime)) {
      endTime = endTime.add(const Duration(days: 1));
    }

    DateTime currentTime =
        startTime.add(Duration(minutes: segmentedTask.loopMin));

    int index = 1;
    while (currentTime.isBefore(endTime) ||
        currentTime.isAtSameMomentAs(endTime)) {
      notifications.add(NotificationObject(
          title: "${segmentedTask.name} $index",
          body: "",
          hour: currentTime.hour,
          minute: currentTime.minute,
          crossDay: currentTime.day != startTime.day // 標記是否跨日
          ));

      currentTime = currentTime.add(Duration(minutes: segmentedTask.loopMin));
      index++;
    }

    return notifications;
  }

  static List<NotificationObject> oneTimeTaskToNotificationList(
      OneTimeTask oneTimeTask) {
    List<NotificationObject> notifications = [];
    List<String> times = oneTimeTask.time.split(":");
    notifications.add(NotificationObject(
        title: oneTimeTask.name,
        body: "",
        hour: int.parse(times[0]),
        minute: int.parse(times[1])));
    return notifications;
  }
}
