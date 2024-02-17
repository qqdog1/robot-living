import 'dart:convert';

import 'package:robot_living/dto/task.dart';

class StartEndTask extends Task {
  String start;
  String end;

  StartEndTask(String name, this.start, this.end) : super(name, "startEndTask");

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'start': start,
      'end': end,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}