import 'dart:convert';

import 'package:robot_living/const/daily_task_type.dart';

class Task {
  String name;
  DailyTaskType type;

  Task(this.name, this.type);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.toString().split('.').last,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}