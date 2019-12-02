/**
 *
 * Eddie, enguagns2@gmail.com
 *
 */

import 'package:chatbydatabase/view/base.dart';

/// Defines the mixin of all view models
///
/// Manages widget state using the [StateExtension] class instance.
mixin ViewModel {
  /// Whether the current model is updated and needs to repaint corresponding
  /// layout.
  bool _dirty = false;

  /// The state reference which is used to manage widget layout. Check null
  /// before calling its methods.
  StateExtension _state;

  StateExtension get state {
    if (_state != null)
      return _state;
    else
      throw new Exception("Should not refer to state object when it is not "
          "explicitly initialized.");
  }

  set state(StateExtension s) {
    if (s != null)
      this._state = s;
    else
      throw new Exception("Should not assign null to state object");
  }

  /// Mark the current view model to be repaint when all operations done.
  void markDirty() {
    _dirty = true;
  }

  /// Inform the state object to update state.
  void relayout() {
    if (_dirty) {
      _dirty = false;
      state?.triggerUpdate();
    }
  }
}
