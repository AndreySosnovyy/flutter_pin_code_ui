import 'package:flutter/material.dart';
import 'package:pin_ui/src/pinpad/widgets/press_detector_builder.dart';

abstract class PinpadKeyBase extends StatefulWidget {
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

  final VoidCallback? onTap;
  final VoidCallback? onTapStart;
  final VoidCallback? onTapEnd;
  final BoxDecoration? defaultDecoration;
  final BoxDecoration? pressedDecoration;
  final BoxDecoration? disabledDecoration;
  final double? width;
  final double? height;
  final bool enabled;
}

class PinpadKeyWrapper extends PinpadKeyBase {
  const PinpadKeyWrapper({
    required this.builder,
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

  final Function(bool isPressed) builder;

  @override
  State<PinpadKeyWrapper> createState() => _PinpadKeyWrapperState();
}

class _PinpadKeyWrapperState extends State<PinpadKeyWrapper> {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
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
    );
  }
}
