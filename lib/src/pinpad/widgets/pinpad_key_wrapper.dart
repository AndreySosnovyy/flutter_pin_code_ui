import 'package:flutter/material.dart';
import 'package:pin_ui/src/pinpad/widgets/point_detector_builder.dart';
import 'package:pin_ui/src/pinpad/widgets/press_detector_builder.dart';

/// {@template pin_ui.PinpadKeyBase}
/// Base that provide set of properties for pinpad-related widgets
/// {@endtemplate}
abstract class PinpadKeyBase extends StatefulWidget {
  /// {@macro pin_ui.PinpadKeyBase}
  const PinpadKeyBase({
    this.onTap,
    this.defaultDecoration,
    this.pressedDecoration,
    this.disabledDecoration,
    this.width,
    this.height,
    this.enabled = true,
    this.onTapStart,
    this.onTapEnd,
    super.key,
  });

  /// {@template pin_ui.PinpadKeyBase.onTap}
  /// onTap callback
  /// {@endtemplate}
  final VoidCallback? onTap;

  /// {@template pin_ui.PinpadKeyBase.onTapStart}
  /// Callback that is called when the  is pressed.
  /// {@endtemplate}
  final VoidCallback? onTapStart;

  /// {@template pin_ui.PinpadKeyBase.onTapEnd}
  /// Callback that is called when the key is released.
  /// {@endtemplate}
  final VoidCallback? onTapEnd;

  /// {@template pin_ui.PinpadKeyBase.defaultDecoration}
  /// Decoration that will be applied when the key is not pressed
  /// {@endtemplate}
  final BoxDecoration? defaultDecoration;

  /// {@template pin_ui.PinpadKeyBase.pressedDecoration}
  /// Decoration that will be applied when the key is pressed
  /// {@endtemplate}
  final BoxDecoration? pressedDecoration;

  /// {@template pin_ui.PinpadKeyBase.disabledDecoration}
  /// Decoration that will be applied when the key is disabled
  /// {@endtemplate}
  final BoxDecoration? disabledDecoration;

  /// {@template pin_ui.PinpadKeyBase.width}
  /// Width of the key
  /// {@endtemplate}
  final double? width;

  /// {@template pin_ui.PinpadKeyBase.height}
  /// Height of the key
  /// {@endtemplate}
  final double? height;

  /// {@template pin_ui.PinpadKeyBase.enabled}
  /// If key is enabled
  /// {@endtemplate}
  final bool enabled;
}

/// {@template pin_ui.PinpadKeyWrapper}
/// Pinpad key wrapper for handling tap logic
/// {@endtemplate}
class PinpadKeyWrapper extends PinpadKeyBase {
  /// {@macro pin_ui.PinpadKeyWrapper}
  const PinpadKeyWrapper({
    required this.builder,

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

  /// Key builder function
  final Function(bool isPressed) builder;

  @override
  State<PinpadKeyWrapper> createState() => _PinpadKeyWrapperState();
}

class _PinpadKeyWrapperState extends State<PinpadKeyWrapper> {
  @override
  Widget build(BuildContext context) {
    // TODO(Sosnovyy): complete decorations logic with isPointed value when it's ready
    return PointDetectorBuilder(
      shape: widget.defaultDecoration?.shape ?? BoxShape.circle,
      builder: (context, isPointed) => IgnorePointer(
        ignoring: !widget.enabled,
        child: PressDetectorBuilder(
          onTap: widget.onTap,
          onPressStart: widget.onTapStart,
          onPressEnd: widget.onTapEnd,
          builder: (context, isPressed) => AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: widget.width,
            height: widget.height,
            decoration: widget.enabled
                ? isPressed
                    ? widget.pressedDecoration
                    : widget.defaultDecoration
                : widget.disabledDecoration,
            child: Center(child: widget.builder(isPressed)),
          ),
        ),
      ),
    );
  }
}
