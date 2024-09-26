import 'package:flutter/material.dart';
import 'package:pin_ui/src/pinpad/pinpad_key_wrapper.dart';

class PinpadKey extends PinpadKeyBase {
  const PinpadKey({
    required this.child,
    super.onTap,
    super.onTapStart,
    super.onTapEnd,
    super.defaultDecoration,
    super.pressedDecoration,
    super.disabledDecoration,
    super.width,
    super.height,
    super.enabled,
    super.key,
  });

  final Widget child;

  @override
  State<StatefulWidget> createState() {
    return _PinpadKeyState();
  }
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

class PinpadTextKey extends PinpadKeyBase {
  const PinpadTextKey(
    this.text, {
    this.defaultTextStyle,
    this.pressedTextStyle,
    this.disabledTextStyle,
    super.onTap,
    super.onTapStart,
    super.onTapEnd,
    super.defaultDecoration,
    super.pressedDecoration,
    super.disabledDecoration,
    super.width,
    super.height,
    super.enabled,
    super.key,
  });

  final String text;
  final TextStyle? defaultTextStyle;
  final TextStyle? pressedTextStyle;
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
