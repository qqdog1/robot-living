import 'dart:convert';

class NotificationObject {
  int? id;
  String title;
  String body;
  int? weekday;
  int hour;
  int minute;
  bool repeat;
  bool crossDay;

  NotificationObject({
    this.id,
    required this.title,
    required this.body,
    this.weekday,
    required this.hour,
    required this.minute,
    this.repeat = true,
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
        title = json['title'],
        body = json['body'],
        weekday = json['weekday'],
        hour = json['hour'],
        minute = json['minute'],
        repeat = json['repeat'],
        crossDay = json['crossDay'] ?? false;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'weekday': weekday,
      'hour': hour,
      'minute': minute,
      'repeat': repeat,
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
      title: title,
      body: body,
      weekday: weekday,
      hour: hour,
      minute: minute,
      repeat: repeat,
      crossDay: crossDay,
    );
  }
}
