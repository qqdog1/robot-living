import 'dart:convert';
import 'daily_task_set.dart';
import 'notification_set.dart';

class UserSettings {
  String language;
  DailyTaskSet dailyTaskSet;
  NotificationSet notificationSet;

  UserSettings({required this.language, DailyTaskSet? dailyTaskSet, NotificationSet? notificationSet})
      : dailyTaskSet = dailyTaskSet ?? DailyTaskSet(dailyTasks: []),
        notificationSet = notificationSet ?? NotificationSet(notifications: []);

  UserSettings.fromJson(Map<String, dynamic> json)
      : language = json['language'],
        dailyTaskSet = DailyTaskSet.fromJson(json['dailyTaskSet'] as Map<String, dynamic>? ?? {}),
        notificationSet = NotificationSet.fromJson(json['notificationSet'] as Map<String, dynamic>? ?? {});

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'dailyTaskSet': dailyTaskSet.toJson(),
      'notificationSet': notificationSet.toJson(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}