import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage{
  static setItem(String key, String value) async {
    SharedPreferences s = await SharedPreferences.getInstance();
    s.setString(key, value);
  }
  static getItem(String key) async {
    SharedPreferences s = await SharedPreferences.getInstance();
    return s.getString(key);
  }
  static hasItem(String key) async {
    SharedPreferences s = await SharedPreferences.getInstance();
    return s.containsKey(key);
  }
}