import 'dart:convert';

import 'package:robot_living/const/daily_task_type.dart';
import 'package:robot_living/dto/one_time_task.dart';
import 'package:robot_living/dto/segmented_task.dart';

import 'duration_task.dart';

abstract class Task {
  String name;
  DailyTaskType type;

  Task(this.name, this.type);

  factory Task.fromJson(Map<String, dynamic> json) {
    final type = DailyTaskType.values
        .firstWhere((e) => e.toString().split('.').last == json['type']);

    switch (type) {
      case DailyTaskType.segmentedTask:
        return SegmentedTask.fromJson(json);
      case DailyTaskType.durationTask:
        return DurationTask.fromJson(json);
      case DailyTaskType.oneTimeTask:
        return OneTimeTask.fromJson(json);
      default:
        throw UnimplementedError('Task type $type is not supported');
    }
  }

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
