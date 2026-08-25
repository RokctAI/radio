// Copyright (c) 2026 RokctAI
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


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
