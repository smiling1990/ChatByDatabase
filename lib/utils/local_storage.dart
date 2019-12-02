/**
 *
 * Eddie, enguagns2@gmail.com
 *
 */

import 'dart:async';
import '../utils/common_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Created On 2019/12/2
/// Description:
/// Use sharedPreferences for local storage
class LocalStorage {
  /// Save data
  static save(String key, value) async {
    assert(value != null);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is String) {
      prefs.setString(key, value);
    } else if (value is int) {
      prefs.setInt(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is List<String>) {
      prefs.setStringList(key, value);
    }
  }

  /// Get data
  static Future get(String key) async {
    if (CommonUtils.isNullOrEmpty(key)) return null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  /// Remove data
  static remove(String key) async {
    if (CommonUtils.isNullOrEmpty(key)) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
