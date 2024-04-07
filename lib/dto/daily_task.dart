import 'dart:convert';

import 'package:robot_living/dto/task.dart';

class DailyTask {
  String? name;
  List<bool>? triggered;
  List<Task> tasks;

  DailyTask({this.name, List<Task>? tasks}) : tasks = tasks ?? [];

  @override
  void initState() {
    triggered = [false, false, false, false, false, false, false];
  }

  DailyTask.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        triggered = List<bool>.from(json['triggered']),
        tasks = (json['tasks'] as List)
            .map((taskJson) => Task.fromJson(taskJson))
            .toList();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (name != null) {
      data['name'] = name;
    }
    data['triggered'] = triggered;
    data['tasks'] = tasks.map((task) => task.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
