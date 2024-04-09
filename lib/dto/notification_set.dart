import 'dart:convert';

import 'notification.dart';
class NotificationSet {
  List<Notification> notifications;

  NotificationSet({List<Notification>? notifications}) : notifications = notifications ?? [];

  NotificationSet.fromJson(Map<String, dynamic> json)
      : notifications = (json['notifications'] as List?)?.map((e) => Notification.fromJson(e as Map<String, dynamic>)).toList() ?? [];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['notifications'] = notifications.map((notification) => notification.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}