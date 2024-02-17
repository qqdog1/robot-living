import 'dart:convert';

import 'package:robot_living/dto/task.dart';

class OneTimeTask extends Task {
  String time;

  OneTimeTask(String name, this.time) : super(name, "oneTimeTask");

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'time': time,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}