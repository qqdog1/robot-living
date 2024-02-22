import 'package:flutter/material.dart';

class TimeUtil {
  static String formatTimeOfDay(TimeOfDay time) {
    final String hour = time.hour.toString().padLeft(2, '0');
    final String minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  static TimeOfDay? stringToTimeOfDay(String date) {
    List<String> parts = date.split(':');
    if (parts.length != 2) {
      return null;
    }
    try {
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }
}