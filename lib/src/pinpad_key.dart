import 'package:flutter/cupertino.dart';

const double defaultKeyWidth = 52;
const double defaultKeyHeight = 52;

/// Single key widget for pin pad
class PinpadKey extends StatefulWidget {
  // Default constructor for pin pad key with any child inside
  const PinpadKey({
    required this.child,
    required this.onTap,
    this.onLongPress,
    this.defaultDecoration,
    this.pressedDecoration,
    this.width = defaultKeyWidth,
    this.height = defaultKeyHeight,
    super.key,
  });

  // Constructor for pin pad key with any text widget inside
  factory PinpadKey.text(
    String text, {
    required VoidCallback onTap,
    TextStyle? textStyle,
    VoidCallback? onLongPress,
    BoxDecoration? defaultDecoration,
    BoxDecoration? pressedDecoration,
    double width = defaultKeyWidth,
    double height = defaultKeyHeight,
  }) {
    return PinpadKey(
      onTap: onTap,
      onLongPress: onLongPress,
      defaultDecoration: defaultDecoration,
      width: width,
      height: height,
      child: Text(text, style: textStyle),
    );
  }

  final Widget child;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final BoxDecoration? defaultDecoration;
  final BoxDecoration? pressedDecoration;
  final double width;
  final double height;

  @override
  State<PinpadKey> createState() => _PinpadKeyState();
}

class _PinpadKeyState extends State<PinpadKey> {
  // TODO(Sosnovyy): implement pressed animation
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: widget.width,
        height: widget.height,
        decoration: widget.defaultDecoration,
        child: Center(child: widget.child),
      ),
    );
  }
}
