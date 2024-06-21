import 'package:flutter_test/flutter_test.dart';
import 'package:robot_living/dto/notification_object.dart';
import 'package:robot_living/util/notification_util.dart';
  void main() {
    test('test gap minutes calculation', () {
      DateTime dateTime = DateTime.now();
      NotificationObject notificationObject10079 = NotificationObject(taskId: 1, title: 'test start', body: 'body', weekday: dateTime.weekday, hour: dateTime.hour, minute: dateTime.minute+3, crossDay: true);
      // print(NotificationUtil.getGapMinutes(dateTime, notificationObject10079));
      //
      NotificationObject notificationObject1 = NotificationObject(taskId: 1, title: 'test end', body: 'body', weekday: dateTime.weekday+1, hour: dateTime.hour+1, minute: dateTime.minute-3);
      // print(NotificationUtil.getGapMinutes(dateTime, notificationObject1));


      DateTime testDateTime = DateTime(2024, 4, 28, 22, 00, 00, 00, 00);
      print(testDateTime.weekday);
    });
  }