import 'package:flutter/material.dart';

/// {@template press_detector_builder}
/// Widget that rebuilds every time it is being pressed and released.
/// {@endtemplate}
class PressDetectorBuilder extends StatefulWidget {
  /// {@macro press_detector_builder}
  const PressDetectorBuilder({
    /// {@macro press_detector_builder.builder}
    required this.builder,

    /// {@macro press_detector_builder.onTap}
    this.onTap,

    /// {@macro press_detector_builder.onPressStart}
    this.onPressStart,

    /// {@macro press_detector_builder.onPressEnd}
    this.onPressEnd,
    super.key,
  });

  /// {@template press_detector_builder.builder}
  /// Builder method to layout child depending on if it is being pressed or not.
  /// {@endtemplate}
  final Widget Function(BuildContext context, bool isPressed) builder;

  /// {@template press_detector_builder.onTap}
  /// Callback that will be triggered when widget created via [builder] was tapped.
  /// {@endtemplate}
  final VoidCallback? onTap;

  /// {@template press_detector_builder.onPressStart}
  /// Callback that will be triggered when widget created via [builder] was pressed.
  /// {@endtemplate}
  final VoidCallback? onPressStart;

  /// {@template press_detector_builder.onPressEnd}
  /// Callback that will be triggered when widget created via [builder] was released.
  /// {@endtemplate}
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
      onPanStart: (_) => setState(() {
        widget.onPressStart?.call();
        _isPressed = true;
      }),
      onPanDown: (_) => setState(() {
        widget.onPressStart?.call();
        _isPressed = true;
      }),
      onPanEnd: (_) => setState(() {
        widget.onPressEnd?.call();
        _isPressed = false;
      }),
      onPanCancel: () => setState(() {
        widget.onPressEnd?.call();
        _isPressed = false;
      }),
      child: widget.builder(context, _isPressed),
    );
  }
}
