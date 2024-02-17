import 'dart:convert';

import 'package:robot_living/dto/task.dart';

class DailyTask {
  String name;
  List<Task> tasks;

  DailyTask({required this.name, List<Task>? tasks}) : tasks = tasks ?? [];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
