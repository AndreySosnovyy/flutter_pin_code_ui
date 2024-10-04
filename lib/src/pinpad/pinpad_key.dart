import 'package:flutter/material.dart';
import 'package:pin_ui/src/pinpad/widgets/pinpad_key_wrapper.dart';

/// {@template pin_ui.PinpadKey}
/// Custom pinpad key widget.
/// {@endtemplate}
class PinpadKey extends PinpadKeyBase {
  /// {@macro pin_ui.PinpadKey}
  const PinpadKey({
    required this.child,

    /// {@macro pin_ui.PinpadKeyBase.onTap}
    super.onTap,

    /// {@macro pin_ui.PinpadKeyBase.onTapStart}
    super.onTapStart,

    /// {@macro pin_ui.PinpadKeyBase.onTapEnd}
    super.onTapEnd,

    /// {@macro pin_ui.PinpadKeyBase.defaultDecoration}
    super.defaultDecoration,

    /// {@macro pin_ui.PinpadKeyBase.pressedDecoration}
    super.pressedDecoration,

    /// {@macro pin_ui.PinpadKeyBase.disabledDecoration}
    super.disabledDecoration,

    /// {@macro pin_ui.PinpadKeyBase.width}
    super.width,

    /// {@macro pin_ui.PinpadKeyBase.height}
    super.height,

    /// {@macro pin_ui.PinpadKeyBase.enabled}
    super.enabled,
    super.key,
  });

  /// Child widget to be displayed as pinpad key
  final Widget child;

  @override
  State<StatefulWidget> createState() => _PinpadKeyState();
}

class _PinpadKeyState extends State<PinpadKey> {
  @override
  Widget build(BuildContext context) {
    return PinpadKeyWrapper(
      onTap: widget.onTap,
      onTapStart: widget.onTapStart,
      onTapEnd: widget.onTapEnd,
      defaultDecoration: widget.defaultDecoration,
      pressedDecoration: widget.pressedDecoration,
      disabledDecoration: widget.disabledDecoration,
      width: widget.width,
      height: widget.height,
      enabled: widget.enabled,
      builder: (_) => widget.child,
    );
  }
}

/// {@template pin_ui.PinpadTextKey}
/// Text pinpad key widget with text.
/// {@endtemplate}
class PinpadTextKey extends PinpadKeyBase {
  /// {@macro pin_ui.PinpadTextKey}
  const PinpadTextKey(
    this.text, {
    this.defaultTextStyle,
    this.pressedTextStyle,
    this.disabledTextStyle,

    /// {@macro pin_ui.PinpadKeyBase.onTap}
    super.onTap,

    /// {@macro pin_ui.PinpadKeyBase.onTapStart}
    super.onTapStart,

    /// {@macro pin_ui.PinpadKeyBase.onTapEnd}
    super.onTapEnd,

    /// {@macro pin_ui.PinpadKeyBase.defaultDecoration}
    super.defaultDecoration,

    /// {@macro pin_ui.PinpadKeyBase.pressedDecoration}
    super.pressedDecoration,

    /// {@macro pin_ui.PinpadKeyBase.disabledDecoration}
    super.disabledDecoration,

    /// {@macro pin_ui.PinpadKeyBase.width}
    super.width,

    /// {@macro pin_ui.PinpadKeyBase.height}
    super.height,

    /// {@macro pin_ui.PinpadKeyBase.enabled}
    super.enabled,
    super.key,
  });

  /// Text to be displayed as pinpad key
  final String text;

  /// Default text style for child Text widget
  final TextStyle? defaultTextStyle;

  /// Pressed text style for child Text widget
  final TextStyle? pressedTextStyle;

  /// Disabled text style for child Text widget
  final TextStyle? disabledTextStyle;

  @override
  State<PinpadTextKey> createState() => _PinpadTextKeyState();
}

class _PinpadTextKeyState extends State<PinpadTextKey> {
  @override
  Widget build(BuildContext context) {
    return PinpadKeyWrapper(
      onTap: widget.onTap,
      onTapStart: widget.onTapStart,
      onTapEnd: widget.onTapEnd,
      defaultDecoration: widget.defaultDecoration,
      pressedDecoration: widget.pressedDecoration,
      disabledDecoration: widget.disabledDecoration,
      width: widget.width,
      height: widget.height,
      enabled: widget.enabled,
      builder: (isPressed) => Text(
        widget.text,
        style: widget.enabled
            ? isPressed
                ? widget.pressedTextStyle
                : widget.defaultTextStyle
            : widget.disabledTextStyle,
      ),
    );
  }
}
