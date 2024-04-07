import 'dart:convert';

import 'package:robot_living/dto/task.dart';

import '../const/daily_task_type.dart';

class SegmentedTask extends Task {
  String start;
  String end;
  int loopMin;

  SegmentedTask(String name, this.start, this.end, this.loopMin) : super(name, DailyTaskType.segmentedTask);

  SegmentedTask.fromJson(Map<String, dynamic> json)
      : start = json['start'],
        end = json['end'],
        loopMin = json['loopMin'],
        super(json['name'], DailyTaskType.segmentedTask);

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.toString().split('.').last,
      'start': start,
      'end': end,
      'loopMin': loopMin,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
