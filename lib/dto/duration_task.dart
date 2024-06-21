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

  bool isCurrentTimeInRange() {
    DateTime now = DateTime.now();
    DateTime startTime = _getDateTimeFromTimeString(start);
    DateTime endTime = _getDateTimeFromTimeString(end);

    if (endTime.isBefore(startTime)) {
      endTime = endTime.add(const Duration(days: 1));
    }

    return (now.isAfter(startTime) || now.isAtSameMomentAs(startTime)) &&
        (now.isBefore(endTime));
  }

  DateTime _getDateTimeFromTimeString(String time) {
    final parts = time.split(':');
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
  }
}
