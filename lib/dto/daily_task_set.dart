import 'dart:convert';

import 'daily_task.dart';

class DailyTaskSet {
  List<DailyTask> dailyTasks;

  DailyTaskSet({List<DailyTask>? dailyTasks}) : dailyTasks = dailyTasks ?? [];

  DailyTaskSet.fromJson(Map<String, dynamic> json)
      : dailyTasks = (json['dailyTasks'] as List?)?.map((e) => DailyTask.fromJson(e as Map<String, dynamic>)).toList() ?? [];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['dailyTasks'] = dailyTasks.map((dailyTask) => dailyTask.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
