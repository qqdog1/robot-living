import 'dart:convert';

class Notification {
  int id;
  String title;
  String body;
  int weekday;
  int hour;
  int minute;
  bool repeat;

  Notification(this.id, this.title, this.body, this.weekday, this.hour,
      this.minute, this.repeat);

  Notification.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        body = json['body'],
        weekday = json['weekday'],
        hour = json['hour'],
        minute = json['minute'],
        repeat = json['repeat'];

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
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
