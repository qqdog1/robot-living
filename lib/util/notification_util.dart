import 'package:flutter/cupertino.dart';
import 'package:robot_living/const/daily_task_type.dart';
import 'package:robot_living/dto/daily_task_set.dart';
import 'package:robot_living/dto/duration_task.dart';
import 'package:robot_living/dto/one_time_task.dart';
import 'package:robot_living/dto/segmented_task.dart';

import '../dto/daily_task.dart';
import '../dto/notification_object.dart';
import '../dto/notification_map.dart';
import '../dto/task.dart';
import '../service/platform_channel.dart';

class NotificationUtil {
  static void setAndroidAlarm(int id, int taskId, String title, String body, int weekday, int hour, int minute) async {
    try {
      await PlatformChannel.createAlarm(
        id,
        taskId,
        title,
        body,
        weekday,
        hour,
        minute
      );
    } catch (e) {
      print("Failed to set the alarm: $e");
    }
  }

  static void cancelAndroidAlarm(int id) async {
    try {
      await PlatformChannel.cancelAlarm(
        id,
      );
    } catch (e) {
      print("Failed to cancel the alarm: $e");
    }
  }

  static void registerNext(List<NotificationObject> lst, BuildContext context) {
    DateTime now = DateTime.now();
    int shortestMinutes = 60 * 24 * 7;

    NotificationObject? nextNotification;
    NotificationObject? zeroGapNotification;

    for (var notification in lst) {
      int gapMin = getGapMinutes(now, notification);
      if (gapMin < shortestMinutes && gapMin != 0) {
        shortestMinutes = gapMin;
        nextNotification = notification.copy();
      } else if (gapMin == 0) {
        zeroGapNotification = notification.copy();
      }
    }

    if (nextNotification == null && zeroGapNotification != null) {
      nextNotification = zeroGapNotification;
    }

    if (nextNotification != null) {
      print("準備由flutter端向android註冊: $nextNotification");
      setAndroidAlarm(nextNotification.id!, nextNotification.taskId, nextNotification.title, nextNotification.body, nextNotification.weekday!,
          nextNotification.hour, nextNotification.minute);
    }
  }

  static int getGapMinutes(DateTime now, NotificationObject notificationObject) {
    int diffDay = notificationObject.weekday! - now.weekday;
    int diffHour = notificationObject.hour - now.hour;
    int diffMin = notificationObject.minute - now.minute;
    if (diffMin < 0) {
      diffMin = diffMin + 60;
      diffHour = diffHour - 1;
    }
    if (diffHour < 0) {
      diffHour = diffHour + 24;
      diffDay = diffDay - 1;
    }
    if (diffDay < 0) diffDay = diffDay + 7;
    return (((diffDay * 24) + diffHour) * 60) + diffMin;
  }

  static NotificationMap toNotificationMap(DailyTaskSet dailyTaskSet) {
    List<NotificationObject> lst = [];
    Map<int, List<NotificationObject>> map = {};
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
                adjustedWeekday = 7;
              }
              // android 原生星期日是1 星期一是2
              // flutter 星期日是7
              // 在flutter處不動 應該要在原生註冊處改
              // adjustedWeekday = adjustedWeekday + 1;
              copyNof.setWeekday(adjustedWeekday);
              lst.add(copyNof);
            }
          }
        }
      }
    }
    int id = 1;
    for (NotificationObject notification in lst) {
      notification.setId(id);
      if (!map.containsKey(notification.taskId)) {
        map.putIfAbsent(notification.taskId, () => []);
      }
      map[notification.taskId]?.add(notification);
      id++;
    }
    return NotificationMap(map: map);
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

  static List<NotificationObject> durationTaskToNotificationList(DurationTask durationTask) {
    List<NotificationObject> notifications = [];
    List<String> startTimes = durationTask.start.split(":");
    List<String> endTimes = durationTask.end.split(":");
    int startHour = int.parse(startTimes[0]);
    int startMinute = int.parse(startTimes[1]);
    int endHour = int.parse(endTimes[0]);
    int endMinute = int.parse(endTimes[1]);
    bool crossDay = endHour < startHour || (endHour == startHour && endMinute < startMinute);
    notifications.add(NotificationObject(
        taskId: durationTask.id!,
        title: "${durationTask.name} start",
        body: "",
        hour: int.parse(startTimes[0]),
        minute: int.parse(startTimes[1])));
    notifications.add(NotificationObject(
        taskId: durationTask.id!,
        title: "${durationTask.name} end",
        body: "",
        hour: int.parse(endTimes[0]),
        minute: int.parse(endTimes[1]),
        crossDay: crossDay));
    return notifications;
  }

  static List<NotificationObject> segmentedTaskToNotificationList(SegmentedTask segmentedTask) {
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

    DateTime currentTime = startTime.add(Duration(minutes: segmentedTask.loopMin));

    int index = 1;
    while (currentTime.isBefore(endTime) || currentTime.isAtSameMomentAs(endTime)) {
      notifications.add(NotificationObject(
          taskId: segmentedTask.id!,
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

  static List<NotificationObject> oneTimeTaskToNotificationList(OneTimeTask oneTimeTask) {
    List<NotificationObject> notifications = [];
    List<String> times = oneTimeTask.time.split(":");
    notifications.add(NotificationObject(
        taskId: oneTimeTask.id!,
        title: oneTimeTask.name,
        body: "",
        hour: int.parse(times[0]),
        minute: int.parse(times[1])));
    return notifications;
  }

  static String? getCurrentExecuting(DailyTaskSet dailyTaskSet) {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;

    if (currentWeekday == 7) currentWeekday = 0;

    for (DailyTask dailyTask in dailyTaskSet.dailyTasks) {
      if (dailyTask.triggered![currentWeekday]) {
        for (Task task in dailyTask.tasks) {
          if (task.type == DailyTaskType.durationTask) {
            DurationTask durationTask = task as DurationTask;
            if (durationTask.isCurrentTimeInRange()) {
              return durationTask.name;
            }
          }
        }
      }
    }

    return null;
  }
}
