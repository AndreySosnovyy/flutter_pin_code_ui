import 'package:flutter/cupertino.dart';

/// {@template pin_ui.PinpadExtraKey}
/// Class representing data for extra pinpad key widget.
/// {@endtemplate}
class PinpadExtraKey {
  /// {@macro pin_ui.PinpadExtraKey}
  PinpadExtraKey({
    /// {@macro pinpad.pinpad_extra_key.child}
    required this.child,

    /// {@macro pinpad.pinpad_extra_key.onTap}
    required this.onTap,
  });

  /// {@template pinpad.pinpad_extra_key.child}
  /// Widget that will be displayed as an extra key with all.
  /// It will be decorated according to the provided set of properties for pinpad.
  /// {@endtemplate}
  final Widget child;

  /// {@template pinpad.pinpad_extra_key.onTap}
  /// Callback for extra key that will be called when it is tapped.
  /// {@endtemplate}
  final void Function() onTap;
}
