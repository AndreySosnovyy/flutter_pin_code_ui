import 'package:flutter/material.dart';

/// A builder that builds widget depending on if it is being pressed or not.
typedef PressBuilder = Widget Function(BuildContext context, bool isPressed);

/// {@template press_detector_builder}
/// Widget that rebuilds every time it is being pressed and released.
/// {@endtemplate}
class PressDetectorBuilder extends StatefulWidget {
  /// {@macro press_detector_builder}
  const PressDetectorBuilder({
    required this.builder,
    this.onTap,
    this.onPressStart,
    this.onPressEnd,
    super.key,
  });

  /// Builder method to layout child depending on if it is being pressed or not.
  final PressBuilder builder;

  /// Callback that will be triggered when widget created via [builder] was tapped.
  final VoidCallback? onTap;

  /// Callback that will be triggered when widget created via [builder] was pressed.
  final VoidCallback? onPressStart;

  /// Callback that will be triggered when widget created via [builder] was released.
  final VoidCallback? onPressEnd;

  @override
  State<PressDetectorBuilder> createState() => _PressDetectorBuilderState();
}

class _PressDetectorBuilderState extends State<PressDetectorBuilder> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onPanStart: (_) {
        widget.onPressStart?.call();
        setState(() => _isPressed = true);
      },
      onPanDown: (_) {
        widget.onPressStart?.call();
        setState(() => _isPressed = true);
      },
      onPanEnd: (_) {
        widget.onPressEnd?.call();
        setState(() => _isPressed = false);
      },
      onPanCancel: () {
        widget.onPressEnd?.call();
        setState(() => _isPressed = false);
      },
      child: widget.builder(context, _isPressed),
    );
  }
}
