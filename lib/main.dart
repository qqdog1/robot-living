import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() {
  AwesomeNotifications().initialize(
    'resource://drawable/ic_launcher', // 替換為您的app icon
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
      )
    ],
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Awesome Notifications Test"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            scheduleNotification();
          },
          child: Text('Schedule Notification'),
        ),
      ),
    );
  }

  void scheduleNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'Hello Awesome Notifications!',
        body: 'This is a scheduled notification',
        displayOnForeground: true
      ),
      schedule: NotificationInterval(interval: 5, repeats: false),
    );
  }
}