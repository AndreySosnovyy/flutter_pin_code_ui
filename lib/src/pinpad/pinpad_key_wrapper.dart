import 'package:flutter/material.dart';

abstract class PinpadKeyBase extends StatefulWidget {
  const PinpadKeyBase({
    this.onTap,
    this.defaultDecoration,
    this.pressedDecoration,
    this.disabledDecoration,
    this.width,
    this.height,
    this.enabled = true,
    super.key,
  });

  final VoidCallback? onTap;
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
          child: Center(child: widget.builder(_isPressed)),
        ),
      ),
    );
  }
}
