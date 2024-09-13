import 'package:flutter/material.dart';
import 'package:pin_ui/src/indicator/animation_controller.dart';
import 'package:pin_ui/src/indicator/animations.dart';
import 'package:pin_ui/src/indicator/widgets/animated_builders/erase_deflate.dart';
import 'package:pin_ui/src/indicator/widgets/animated_builders/input_inflate.dart';
import 'package:pin_ui/src/indicator/widgets/pin_indicator_builder.dart';
import 'package:pin_ui/src/indicator/widgets/pin_indicator_dot.dart';

// TODO(Sosnovyy): add decoration properties instead of colors
class PinIndicator extends StatefulWidget {
  const PinIndicator({
    required this.length,
    required this.currentLength,
    required this.isError,
    required this.isSuccess,
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
              color: _getColorForIndex(i),
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
