import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceRepository {
  Future<void> saveData(Map<String, dynamic> answers) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('answers', jsonEncode(answers));
    } catch (e) {
      print("Error saving data: $e");
    }
  }

  Future<Map<String, dynamic>> getSaveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Map<String, dynamic>? res = jsonDecode(prefs.getString('answers') ?? '');
      return res ?? {};
    } catch (e) {
      return {};
    }
  }
}
