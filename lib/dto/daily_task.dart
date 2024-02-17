import 'dart:convert';

import 'package:robot_living/dto/task.dart';

class DailyTask {
  String? name;
  List<Task> tasks;

  DailyTask({this.name, List<Task>? tasks}) : tasks = tasks ?? [];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (name != null) {
      data['name'] = name;
    }
    data['tasks'] = tasks.map((task) => task.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
