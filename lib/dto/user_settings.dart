import 'dart:convert';
import 'daily_task_set.dart';
import 'notification_map.dart';

class UserSettings {
  String language;
  DailyTaskSet dailyTaskSet;
  NotificationMap notificationMap;

  UserSettings({required this.language, DailyTaskSet? dailyTaskSet, NotificationMap? notificationMap})
      : dailyTaskSet = dailyTaskSet ?? DailyTaskSet(dailyTasks: []),
        notificationMap = notificationMap ?? NotificationMap(map: {});

  UserSettings.fromJson(Map<String, dynamic> json)
      : language = json['language'],
        dailyTaskSet = DailyTaskSet.fromJson(json['dailyTaskSet'] as Map<String, dynamic>? ?? {}),
        notificationMap = NotificationMap.fromJson(json['notificationMap'] as Map<String, dynamic>? ?? {});

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'dailyTaskSet': dailyTaskSet.toJson(),
      'notificationMap': notificationMap.toJson(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}