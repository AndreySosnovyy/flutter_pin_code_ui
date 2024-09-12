import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_ui/src/indicator/animation_controller_providers.dart';
import 'package:pin_ui/src/indicator/animation_controller_value.dart';
import 'package:pin_ui/src/indicator/animations_config.dart';
import 'package:pin_ui/src/indicator/transitions/input_inflate_transition.dart';
import 'package:pin_ui/src/indicator/widgets/pin_indicator_dot.dart';

part '../animation_controller.dart';

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

  bool get hasController => widget.controller != null;

  bool get hasInputAnimationController =>
      widget.controller?.value.inputAnimationController != null;

  AnimationController? get inputAnimationController =>
      widget.controller?.value.inputAnimationController;

  bool get hasLoadingAnimationController =>
      widget.controller?.value.loadingAnimationController != null;

  AnimationController? get loadingAnimationController =>
      widget.controller?.value.loadingAnimationController;

  bool get hasSuccessAnimationController =>
      widget.controller?.value.successAnimationController != null;

  AnimationController? get successAnimationController =>
      widget.controller?.value.successAnimationController;

  bool get hasErrorAnimationController =>
      widget.controller?.value.errorAnimationController != null;

  AnimationController? get errorAnimationController =>
      widget.controller?.value.errorAnimationController;

  bool get hasClearAnimationController =>
      widget.controller?.value.clearAnimationController != null;

  AnimationController? get clearAnimationController =>
      widget.controller?.value.clearAnimationController;

  bool get hasEraseAnimationController =>
      widget.controller?.value.eraseAnimationController != null;

  AnimationController? get eraseAnimationController =>
      widget.controller?.value.eraseAnimationController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < widget.length; i++)
          Padding(
            padding: EdgeInsets.only(
                right: i == widget.length - 1 ? 0 : widget.spacing),
            child: hasController &&
                    hasInputAnimationController &&
                    i == widget.currentLength - 1
                ? AnimatedBuilder(
                    animation: inputAnimationController!,
                    builder: (context, _) {
                      return InputInflateTransition(
                        animation: inputAnimationController!,
                        child: PinIndicatorDot(
                          size: widget.size,
                          color: Color.lerp(
                            _getColorForIndex(i),
                            _getColorForIndex(i),
                            inputAnimationController!.value,
                          )!,
                        ),
                      );
                    },
                  )
                : PinIndicatorDot(
                    size: widget.size,
                    color: _getColorForIndex(i),
                  ),
          ),
      ],
    );
  }
}
