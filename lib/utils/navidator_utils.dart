/**
 *
 * Eddie, enguagns2@gmail.com
 *
 */

import 'package:flutter/material.dart';

/// Created On 2019/12/2
/// Description:
/// Navigation utils duo to unified management
class NavigatorUtils {
  /// Replace by route name
  static pushReplacementNamed(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  /// Replace by widget
  static pushReplacement(BuildContext context, Widget widget) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return widget;
    }));
  }

  /// Push page of no-parameter
  static pushNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  /// Push page of widget
  /// Can set parameter
  /// Animation: Intent animation
  static push(BuildContext context, Widget widget, {bool animation = false}) {
    if (animation) {
      Navigator.push<String>(
          context,
          PageRouteBuilder(pageBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          }, transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: const Offset(0.0, 0.0),
              ).animate(animation),
              child: child,
            );
          }));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => widget),
      );
    }
  }

  /// Push And remove page
  static pushAndRemove(BuildContext context, Widget widget) {
    // Close all before
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return widget;
    }), (route) => route == null);
  }

  /// Push named and remove page
  static pushNamedAndRemoveUntil(BuildContext context, String name) {
    // Close all before
    Navigator.pushNamedAndRemoveUntil(context, name, (route) => route == null);
  }

  /// Close current page
  static pop(BuildContext context) {
    Navigator.pop(context);
  }

  /// Pop until a widget
  static popAndRemove(BuildContext context, String routeName) {
    // Close all before a route
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }
}
