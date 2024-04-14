import 'dart:convert';

import 'notification_object.dart';
class NotificationSet {
  List<NotificationObject> notificationObjects;

  NotificationSet({List<NotificationObject>? notifications}) : notificationObjects = notifications ?? [];

  NotificationSet.fromJson(Map<String, dynamic> json)
      : notificationObjects = (json['notificationObjects'] as List?)?.map((e) => NotificationObject.fromJson(e as Map<String, dynamic>)).toList() ?? [];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['notificationObjects'] = notificationObjects.map((notification) => notification.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}