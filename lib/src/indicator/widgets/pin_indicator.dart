import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_ui/src/indicator/animation_controller.dart';
import 'package:pin_ui/src/indicator/animations.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/clear_drop_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/clear_fade_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/erase_deflate_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/error_shake_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/idle_wave_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/input_inflate_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/loading_jump_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/success_collapse_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';

const BoxDecoration _dotDefaultDefaultDecoration =
    BoxDecoration(shape: BoxShape.circle, color: Colors.black12);

const BoxDecoration _dotDefaultSuccessDecoration =
    BoxDecoration(shape: BoxShape.circle, color: Colors.green);

const BoxDecoration _dotDefaultErrorDecoration =
    BoxDecoration(shape: BoxShape.circle, color: Colors.red);

const BoxDecoration _dotDefaultInputDecoration =
    BoxDecoration(shape: BoxShape.circle, color: Colors.blue);

// TODO(Sosnovyy): fix 'AnimationController.animateTo() called after AnimationController.dispose()' when clicking fast input
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
  BoxDecoration _getDecorationForDotIndexed(int index) {
    if (widget.isSuccess) return widget.successDecoration;
    if (widget.isError) return widget.errorDecoration;
    if (index < widget.currentLength) return widget.inputDecoration;
    return widget.defaultDecoration;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller ?? PinIndicatorAnimationController(),
      builder: (context, animation, child) {
        final dots = List.generate(
          widget.length,
          (i) => _PinIndicatorDot(
            size: widget.size,
            decoration: _getDecorationForDotIndexed(i),
          ),
        );
        final defaultDots = List.generate(
          widget.length,
          (i) => _PinIndicatorDot(
            size: widget.size,
            decoration: widget.defaultDecoration,
          ),
        );
        final noAnimationPinIndicator = NoAnimationPinIndicator(
          length: widget.length,
          spacing: widget.spacing,
          builder: (i) => dots[i],
        );

        if (animation == null) return noAnimationPinIndicator;
        return switch (animation) {
          PinIndicatorInputInflateAnimation() => InputInflatePinIndicator(
              key: UniqueKey(),
              length: widget.length,
              currentPinLength: widget.currentLength,
              duration: animation.duration,
              builder: (i) => dots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorLoadingJumpAnimation() => LoadingJumpPinIndicator(
              key: UniqueKey(),
              length: widget.length,
              duration: animation.duration,
              builder: (i) => dots[i],
              spacing: widget.spacing,
              childSize: widget.size,
            ),
          PinIndicatorSuccessCollapseAnimation() => SuccessCollapsePinIndicator(
              key: UniqueKey(),
              length: widget.length,
              childSize: widget.size,
              duration: animation.duration,
              builder: (i) => dots[i],
              spacing: widget.spacing,
              collapsedChild: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: widget.size * 2.3,
                    height: widget.size * 2.3,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Icon(
                    CupertinoIcons.checkmark_alt_circle_fill,
                    color: Colors.green,
                    size: widget.size * 3,
                  ),
                ],
              ),
            ),
          PinIndicatorErrorShakeAnimation() => ErrorShakePinIndicator(
              key: UniqueKey(),
              length: widget.length,
              childSize: widget.size,
              duration: animation.duration,
              builder: (i) => dots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorClearFadeAnimation() => ClearFadePinIndicator(
              key: UniqueKey(),
              length: widget.length,
              duration: animation.duration,
              builderOld: (i) => dots[i],
              builderNew: (i) => defaultDots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorClearDropAnimation() => ClearDropPinIndicator(
              key: UniqueKey(),
              length: widget.length,
              duration: animation.duration,
              builderOld: (i) => dots[i],
              builderNew: (i) => defaultDots[i],
              spacing: widget.spacing,
              childSize: widget.size,
            ),
          PinIndicatorEraseDeflateAnimation() => EraseDeflatePinIndicator(
              key: UniqueKey(),
              length: widget.length,
              currentPinLength: widget.currentLength,
              duration: animation.duration,
              builder: (i) => dots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorIdleWaveAnimation() => IdleWavePinIndicator(
              key: UniqueKey(),
              length: widget.length,
              duration: animation.duration,
              builder: (i) => dots[i],
              spacing: widget.spacing,
            ),
        };
      },
    );
  }
}

class _PinIndicatorDot extends StatelessWidget {
  const _PinIndicatorDot({
    required this.decoration,
    required this.size,
  });

  final BoxDecoration decoration;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: decoration,
      ),
    );
  }
}
