import 'package:flutter/material.dart';

/// Single key widget for pin pad
class PinpadKey extends StatefulWidget {
  // Default constructor for pin pad key with any child inside
  const PinpadKey({
    required this.child,
    required this.onTap,
    this.decoration,
    this.pressedDecoration,
    this.width,
    this.height,
    super.key,
  });

  // Constructor for pin pad key with any text widget inside
  factory PinpadKey.text(
    String text, {
    required VoidCallback onTap,
    TextStyle? textStyle,
    BoxDecoration? decoration,
    BoxDecoration? pressedDecoration,
    double? width,
    double? height,
  }) {
    return PinpadKey(
      onTap: onTap,
      decoration: decoration,
      pressedDecoration: pressedDecoration,
      width: width,
      height: height,
      child: Text(text, style: textStyle),
    );
  }

  final Widget child;
  final VoidCallback onTap;
  final BoxDecoration? decoration;
  final BoxDecoration? pressedDecoration;
  final double? width;
  final double? height;

  @override
  State<PinpadKey> createState() => _PinpadKeyState();
}

class _PinpadKeyState extends State<PinpadKey> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
        decoration: _isPressed ? widget.pressedDecoration : widget.decoration,
        child: Center(child: widget.child),
      ),
    );
  }
}
