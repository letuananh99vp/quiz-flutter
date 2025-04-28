import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceRepository {
  Future<void> saveData(String key, Map<String, dynamic> answers) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, jsonEncode(answers));
    } catch (e) {
      print("Error saving data: $e");
    }
  }

  Future<Map<String, dynamic>> getSaveData(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Map<String, dynamic>? res = jsonDecode(prefs.getString(key) ?? '');
      return res ?? {};
    } catch (e) {
      return {};
    }
  }

  Future<void> removeData(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } catch (e) {
      print("Error removing data: $e");
    }
  }
}
