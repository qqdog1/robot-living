import 'package:flutter_test/flutter_test.dart';
import 'package:robot_living/dto/notification_object.dart';
import 'package:robot_living/util/notification_util.dart';
  void main() {
    test('test gap minutes calculation', () {
      DateTime dateTime = DateTime.now();
      NotificationObject notificationObject10079 = NotificationObject(taskId: 1, title: 'test', body: 'body', weekday: dateTime.weekday, hour: dateTime.hour, minute: dateTime.minute-1);
      print(NotificationUtil.getGapMinutes(dateTime, notificationObject10079));

      NotificationObject notificationObject1 = NotificationObject(taskId: 1, title: 'test', body: 'body', weekday: dateTime.weekday, hour: dateTime.hour, minute: dateTime.minute+1);
      print(NotificationUtil.getGapMinutes(dateTime, notificationObject1));
    });
  }