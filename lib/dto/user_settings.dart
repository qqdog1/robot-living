import 'dart:convert';

class UserSettings {
  String language;

  UserSettings(this.language);

  Map<String, dynamic> toJson() {
    return {
      'language': language,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}