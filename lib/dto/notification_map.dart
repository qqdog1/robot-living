import 'dart:convert';

import 'notification_object.dart';
class NotificationMap {
  Map<int, List<NotificationObject>> map;

  NotificationMap({Map<int, List<NotificationObject>>? map}) : map = map ?? {};

  NotificationMap.fromJson(Map<String, dynamic> json)
      : map = json['notificationMap'] != null
      ? { for (var item in json['notificationMap']) item['taskId'] as int : (item['notifications'] as List)
          .map((e) => NotificationObject.fromJson(e as Map<String, dynamic>))
          .toList() }
      : {};

  Map<String, dynamic> toJson() {
    return {
      'notificationMap': map.entries.map((e) => {
        'taskId': e.key,
        'notifications': e.value.map((no) => no.toJson()).toList()
      }).toList()
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  List<NotificationObject> getAllValues() {
    List<NotificationObject> lst = [];
    for (List<NotificationObject> lstValues in map.values) {
      lst.addAll(lstValues);
    }
    return lst;
  }
}