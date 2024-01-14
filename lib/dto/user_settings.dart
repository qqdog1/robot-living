import 'dart:convert';

class UserSettings {
  // 使用者是否已經開過設定畫面顯示過popup
  bool isSettingsPage;

  UserSettings(this.isSettingsPage);

  Map<String, dynamic> toJson() {
    return {
      'isSettingsPage': isSettingsPage,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}