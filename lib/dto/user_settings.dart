import 'dart:convert';
import 'daily_task_set.dart';

class UserSettings {
  String language;
  DailyTaskSet dailyTaskSet;

  UserSettings({required this.language, DailyTaskSet? dailyTaskSet})
      : dailyTaskSet = dailyTaskSet ?? DailyTaskSet(dailyTasks: []);

  UserSettings.fromJson(Map<String, dynamic> json)
      : language = json['language'],
        dailyTaskSet = DailyTaskSet.fromJson(json['dailyTaskSet'] as Map<String, dynamic>? ?? {});

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'dailyTaskSet': dailyTaskSet.toJson(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}