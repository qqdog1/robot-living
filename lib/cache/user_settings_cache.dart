import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:robot_living/const/language.dart';

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
      final content = await file.readAsString();
      Map<String, dynamic> jsonMap = jsonDecode(content);
      userSettings = UserSettings.fromJson(jsonMap);
    } else {
      _write();
    }
  }

  UserSettingsCache._internal() {
    _init();
  }

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

  void setDailyTaskSet(DailyTaskSet dailyTaskSet) {
    userSettings.dailyTaskSet = dailyTaskSet;
    _write();
  }

  Future<void> _write() async {
    final directory = await getApplicationSupportDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(userSettings.toString());
    print("write file: " + userSettings.toString());
  }
}