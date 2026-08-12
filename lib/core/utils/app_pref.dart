import 'package:shared_preferences/shared_preferences.dart';

class AppPref {
  static sharedPref(String key, bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(key, value);
  }

  static Future<bool> loadSharedPref(String key, bool dKey) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(key) ?? dKey;
  }

  static sharedPrefString(String key, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }

  static Future<String> loadSharedPrefString(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key) ?? "";
  }

  static sharedPrefInt(String key, int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(key, value);
  }

  static Future<int> loadSharedPrefInt(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(key) ?? 0;
  }


  static setSleepTime(bool isTimerOn, int sleepTime, int sleepTimeID) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("isTimerOn", isTimerOn);
    preferences.setInt("sleepTime", sleepTime);
    preferences.setInt("sleepTimeID", sleepTimeID);
  }
}
