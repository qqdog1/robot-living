import 'dart:convert';

import 'package:robot_living/const/daily_task_type.dart';
import 'package:robot_living/dto/task.dart';

class DurationTask extends Task {
  String start;
  String end;

  DurationTask(String name, this.start, this.end) : super(name: name, type: DailyTaskType.durationTask);

  DurationTask.fromJson(Map<String, dynamic> json)
      : start = json['start'],
        end = json['end'],
        super(name: json['name'], type: DailyTaskType.durationTask);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'start': start,
      'end': end,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
