/**
 *
 * Eddie, enguagns2@gmail.com
 *
 */

import 'package:flutter/widgets.dart';

/// An extension of original [State] abstract class
///
/// This extension enables the calling of protected [setState] method.
abstract class StateExtension<T> extends State {
  /// Trigger protected [setState] method and relayout the UI.
  triggerUpdate() {
    this.setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
