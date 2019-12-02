/**
 *
 * Eddie, enguagns2@gmail.com
 *
 */

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Created On 2019/12/2
/// Description:
///
class ToastUtils {
  static showToast({
    @required String msg,
    Toast toastLength = Toast.LENGTH_SHORT,
    int timeInSecForIos = 1,
    double fontSize = 16.0,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
  }) {
    if (msg == null) return;
    if (msg.trim().isEmpty) return;
    if (msg.contains('_')) {
      msg = msg.replaceAll('_', ' ');
      // First word to upper case
      msg = msg.replaceRange(0, 1, msg.substring(0, 1).toUpperCase());
    }
    Fluttertoast.showToast(
      msg: msg,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIos: timeInSecForIos,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }
}
