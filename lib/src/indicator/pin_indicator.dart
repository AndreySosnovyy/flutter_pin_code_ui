import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_ui/src/indicator/animations_config.dart';
import 'package:pin_ui/src/indicator/pin_indicator_animation_value.dart';

part 'pin_indicator_animation_controller.dart';

class PinIndicator extends StatefulWidget {
  const PinIndicator({
    required this.length,
    required this.currentLength,
    required this.isError,
    required this.isSuccess,
    this.animationsConfig,
    this.controller,
    this.errorColor = Colors.red,
    this.successColor = Colors.green,
    this.inputColor = Colors.blue,
    this.defaultColor = Colors.black12,
    this.spacing = 24.0,
    this.size = 14.0,
    super.key,
  });

  final PinIndicatorAnimationController? controller;
  final PinIndicatorAnimationsConfig? animationsConfig;
  final int length;
  final int currentLength;
  final bool isError;
  final bool isSuccess;
  final Color successColor;
  final Color errorColor;
  final Color defaultColor;
  final Color inputColor;
  final double spacing;
  final double size;

  @override
  State<PinIndicator> createState() => _PinIndicatorState();
}

class _PinIndicatorState extends State<PinIndicator> {
  Color _getColorForIndex(int index) {
    if (widget.isSuccess) return widget.successColor;
    if (widget.isError) return widget.errorColor;
    if (index < widget.currentLength) return widget.inputColor;
    return widget.defaultColor;
  }

  @override
  void initState() {
    if (widget.controller != null) {
      widget.controller!._setConfig(
          widget.animationsConfig ?? PinIndicatorAnimationsConfig.defaults());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < widget.length; i++)
          Padding(
            padding: EdgeInsets.only(
                right: i == widget.length - 1 ? 0 : widget.spacing),
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getColorForIndex(i),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
