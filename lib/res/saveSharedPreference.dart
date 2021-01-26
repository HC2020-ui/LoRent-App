import 'package:shared_preferences/shared_preferences.dart';

class SaveSharedPreference {
  static Future<bool> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString("uid", userId);
  }

  static Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("uid");
  }

  static Future<bool> savePhoneNumber(String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString("phone", phoneNumber);
  }

  static Future<String> getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("phone");
  }

  static Future<bool> saveUserName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString("username", name);
  }

  static Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("username");
  }

  static Future<bool> saveUserEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString("email", email);
  }

  static Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }
}
