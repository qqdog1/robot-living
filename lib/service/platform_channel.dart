import 'package:flutter/services.dart';

class PlatformChannel {
  static const MethodChannel _channel = MethodChannel('robot_inner');

  static Future<bool> createAlarm(int id, int taskId, String title, String body, int weekday, int hour, int minute, int second) async {
    try {
      final bool result = await _channel.invokeMethod('createAlarm', {
        'id': id,
        'taskId': taskId,
        'title': title,
        'body': body,
        'weekday': weekday,
        'hour': hour,
        'minute': minute,
        "second": second,
      });
      return result;
    } catch (e) {
      throw Exception('Failed to create alarm: $e');
    }
  }

  static Future<bool> cancelAlarm(int id) async {
    try {
      final bool result = await _channel.invokeMethod('cancelAlarm', {
        'id': id,
      });
      return result;
    } catch (e) {
      throw Exception('Failed to cancel alarm: $e');
    }
  }
}