import 'package:flutter/material.dart';

// TODO(Sosnovyy): refactor to avoid duplicate code

class PinpadKey extends StatefulWidget {
  const PinpadKey({
    required this.child,
    required this.onTap,
    this.defaultDecoration,
    this.pressedDecoration,
    this.disabledDecoration,
    this.width,
    this.height,
    this.enabled = true,
    super.key,
  });

  final Widget child;
  final VoidCallback onTap;
  final BoxDecoration? defaultDecoration;
  final BoxDecoration? pressedDecoration;
  final BoxDecoration? disabledDecoration;
  final double? width;
  final double? height;
  final bool enabled;

  @override
  State<PinpadKey> createState() => _PinpadKeyState();
}

class _PinpadKeyState extends State<PinpadKey> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.enabled,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onPanStart: (_) => setState(() => _isPressed = true),
        onPanDown: (_) => setState(() => _isPressed = true),
        onPanEnd: (_) => setState(() => _isPressed = false),
        onPanCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: widget.width,
          height: widget.height,
          decoration: widget.enabled
              ? _isPressed
                  ? widget.pressedDecoration
                  : widget.defaultDecoration
              : widget.disabledDecoration,
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}

class PinpadTextKey extends StatefulWidget {
  const PinpadTextKey(
    this.text, {
    required this.onTap,
    this.defaultTextStyle,
    this.pressedTextStyle,
    this.disabledTextStyle,
    this.defaultDecoration,
    this.pressedDecoration,
    this.disabledDecoration,
    this.width,
    this.height,
    this.enabled = true,
    super.key,
  });

  final String text;
  final TextStyle? defaultTextStyle;
  final TextStyle? pressedTextStyle;
  final TextStyle? disabledTextStyle;
  final VoidCallback onTap;
  final BoxDecoration? defaultDecoration;
  final BoxDecoration? pressedDecoration;
  final BoxDecoration? disabledDecoration;
  final double? width;
  final double? height;
  final bool enabled;

  @override
  State<PinpadTextKey> createState() => _PinpadTextKeyState();
}

class _PinpadTextKeyState extends State<PinpadTextKey> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    print('widget.enabled = ${widget.enabled}');
    return IgnorePointer(
      ignoring: !widget.enabled,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onPanStart: (_) => setState(() => _isPressed = true),
        onPanDown: (_) => setState(() => _isPressed = true),
        onPanEnd: (_) => setState(() => _isPressed = false),
        onPanCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: widget.width,
          height: widget.height,
          decoration: widget.enabled
              ? _isPressed
                  ? widget.pressedDecoration
                  : widget.defaultDecoration
              : widget.disabledDecoration,
          child: Center(
            child: Text(
              widget.text,
              style: widget.enabled
                  ? _isPressed
                      ? widget.pressedTextStyle
                      : widget.defaultTextStyle
                  : widget.disabledTextStyle,
            ),
          ),
        ),
      ),
    );
  }
}
