import 'dart:convert';

import 'package:robot_living/dto/task.dart';

class SegmentedTask extends Task {
  String start;
  String end;
  int loopMin;

  SegmentedTask(String name, this.start, this.end, this.loopMin) : super(name, "segmentedTask");

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
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