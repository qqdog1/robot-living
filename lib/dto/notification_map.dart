import 'dart:convert';

import 'notification_object.dart';
class NotificationMap {
  Map<int, NotificationObject> map;

  NotificationMap({Map<int, NotificationObject>? map}) : map = map ?? {};

  NotificationMap.fromJson(Map<String, dynamic> json)
      : map = json['notificationMap'] != null
      ? { for (var e in json['notificationMap']) e['taskId'] as int : NotificationObject.fromJson(e as Map<String, dynamic>) }
      : {};

  Map<String, dynamic> toJson() {
    return {
      'notificationMap': map.entries.map((e) => e.value.toJson()).toList()
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}