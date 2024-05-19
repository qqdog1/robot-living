import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:robot_living/const/language.dart';
import 'package:robot_living/dto/notification_map.dart';

import '../dto/daily_task_set.dart';
import '../dto/user_settings.dart';

class UserSettingsCache {
  static final UserSettingsCache _instance = UserSettingsCache._internal();
  UserSettings userSettings = UserSettings(language: Language.chinese);
  String fileName = 'settings.txt';
  bool _initialized = false;

  factory UserSettingsCache() {
    return _instance;
  }

  static Future<UserSettingsCache> getInstance() async {
    if (!_instance._initialized) {
      await _instance._init();
      _instance._initialized = true;
    }
    return _instance;
  }

  Future<void> _init() async {
    final directory = await getApplicationSupportDirectory();
    final file = File('${directory.path}/$fileName');

    if (await file.exists()) {
      // file.delete();
      final content = await file.readAsString();
      Map<String, dynamic> jsonMap = jsonDecode(content);
      userSettings = UserSettings.fromJson(jsonMap);
    } else {
      _write();
    }
  }

  UserSettingsCache._internal();

  String getLanguage() {
    return userSettings.language;
  }

  void setLanguage(String language) {
    userSettings.language = language;
    _write();
  }

  DailyTaskSet getDailyTaskSet() {
    return userSettings.dailyTaskSet;
  }

  NotificationMap getNotificationMap() {
    return userSettings.notificationMap;
  }

  void setTaskAndNotify(DailyTaskSet dailyTaskSet, NotificationMap notificationMap) {
    userSettings.dailyTaskSet = dailyTaskSet;
    userSettings.notificationMap = notificationMap;
    _write();
  }

  Future<void> _write() async {
    final directory = await getApplicationSupportDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(userSettings.toString());
    printInBatches("寫檔完成: $userSettings");
  }

  void printInBatches(String data, {int batchSize = 500}) {
    for (int i = 0; i < data.length; i += batchSize) {
      print(data.substring(i, i + batchSize < data.length ? i + batchSize : data.length));
    }
  }
}