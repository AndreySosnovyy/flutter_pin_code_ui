import 'package:flutter/material.dart';
import 'package:pin_ui/src/indicator/animation_controller.dart';
import 'package:pin_ui/src/indicator/animations.dart';
import 'package:pin_ui/src/indicator/widgets/animated_builders/erase_deflate.dart';
import 'package:pin_ui/src/indicator/widgets/animated_builders/input_inflate.dart';
import 'package:pin_ui/src/indicator/widgets/pin_indicator_builder.dart';
import 'package:pin_ui/src/indicator/widgets/pin_indicator_dot.dart';

const BoxDecoration _dotDefaultDefaultDecoration =
    BoxDecoration(shape: BoxShape.circle, color: Colors.black12);

const BoxDecoration _dotDefaultSuccessDecoration =
    BoxDecoration(shape: BoxShape.circle, color: Colors.green);

const BoxDecoration _dotDefaultErrorDecoration =
    BoxDecoration(shape: BoxShape.circle, color: Colors.red);

const BoxDecoration _dotDefaultInputDecoration =
    BoxDecoration(shape: BoxShape.circle, color: Colors.blue);

class PinIndicator extends StatefulWidget {
  const PinIndicator({
    required this.length,
    required this.currentLength,
    required this.isError,
    required this.isSuccess,
    this.controller,
    this.errorDecoration = _dotDefaultErrorDecoration,
    this.successDecoration = _dotDefaultSuccessDecoration,
    this.inputDecoration = _dotDefaultInputDecoration,
    this.defaultDecoration = _dotDefaultDefaultDecoration,
    this.spacing = 24.0,
    this.size = 14.0,
    super.key,
  });

  final PinIndicatorAnimationController? controller;
  final int length;
  final int currentLength;
  final bool isError;
  final bool isSuccess;
  final BoxDecoration successDecoration;
  final BoxDecoration errorDecoration;
  final BoxDecoration defaultDecoration;
  final BoxDecoration inputDecoration;
  final double spacing;
  final double size;

  @override
  State<PinIndicator> createState() => _PinIndicatorState();
}

class _PinIndicatorState extends State<PinIndicator> {
  BoxDecoration _getDecorationForIndex(int index) {
    if (widget.isSuccess) return widget.successDecoration;
    if (widget.isError) return widget.errorDecoration;
    if (index < widget.currentLength) return widget.inputDecoration;
    return widget.defaultDecoration;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller ?? ValueNotifier(null),
      builder: (context, animation, child) {
        return PinIndicatorBuilder(
          length: widget.length,
          spacing: widget.spacing,
          builder: (context, i) {
            final dot = PinIndicatorDot(
              size: widget.size,
              decoration: _getDecorationForIndex(i),
            );
            return switch (animation) {
              PinInputInflateAnimation() => i == widget.currentLength - 1
                  ? InputInflateAnimated(
                      duration: animation.duration,
                      child: dot,
                    )
                  : dot,
              PinLoadingJumpAnimation() => dot,
              PinSuccessCollapseAnimation() => dot,
              PinErrorShakeAnimation() => dot,
              PinClearDropAnimation() => dot,
              PinEraseDeflateAnimation() => i == widget.currentLength
                  ? EraseDeflateAnimated(
                      duration: animation.duration,
                      child: dot,
                    )
                  : dot,
              _ => dot,
            };
            // if (_hasLoadingAnimationController) {
            //   return switch (widget.controller!._config.loadingAnimation!) {
            //     PinLoadingAnimation.jump => AnimatedBuilder(
            //       animation: _loadingAnimationController!,
            //       child: dot,
            //       builder: (context, child) {
            //         final offset =
            //             _loadingAnimationController!.value * 64;
            //         return Transform.translate(
            //           offset: Offset(0, -offset),
            //           child: dot,
            //         );
            //       },
            //     ),
            //   };
            // }
          },
        );
      },
    );
  }
}
