import 'dart:convert';

class Task {
  String name;
  String type;

  Task(this.name, this.type);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}