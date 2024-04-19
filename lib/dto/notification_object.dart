import 'dart:convert';

class NotificationObject {
  int? id;
  int taskId;
  String title;
  String body;
  int? weekday;
  int hour;
  int minute;
  bool crossDay;

  NotificationObject({
    this.id,
    required this.taskId,
    required this.title,
    required this.body,
    this.weekday,
    required this.hour,
    required this.minute,
    this.crossDay = false,
  });

  void setId(int id) {
    this.id = id;
  }

  void setTitle(String title) {
    this.title = title;
  }

  void setWeekday(int weekday) {
    this.weekday = weekday;
  }

  NotificationObject.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        taskId = json['taskId'],
        title = json['title'],
        body = json['body'],
        weekday = json['weekday'],
        hour = json['hour'],
        minute = json['minute'],
        crossDay = json['crossDay'] ?? false;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskId': taskId,
      'title': title,
      'body': body,
      'weekday': weekday,
      'hour': hour,
      'minute': minute,
      'crossDay': crossDay,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  NotificationObject copy() {
    return NotificationObject(
      id: id,
      taskId: taskId,
      title: title,
      body: body,
      weekday: weekday,
      hour: hour,
      minute: minute,
      crossDay: crossDay,
    );
  }
}
