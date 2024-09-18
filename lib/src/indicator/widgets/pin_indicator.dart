import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_ui/src/indicator/animation_controller.dart';
import 'package:pin_ui/src/indicator/models/animation_data.dart';
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
        final currentDots = List.generate(
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
          builder: (i) => currentDots[i],
        );

        if (animation == null) return noAnimationPinIndicator;
        return switch (animation.data) {
          PinIndicatorNoAnimationData() => noAnimationPinIndicator,
          PinIndicatorInputInflateAnimationData() => InputInflatePinIndicator(
              key: ValueKey(animation.id),
              length: widget.length,
              currentPinLength: widget.currentLength,
              duration: animation.data.duration,
              builder: (i) => currentDots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorLoadingJumpAnimationData() => LoadingJumpPinIndicator(
              key: ValueKey(animation.id),
              length: widget.length,
              duration: animation.data.duration,
              builder: (i) => currentDots[i],
              spacing: widget.spacing,
              childSize: widget.size,
            ),
          PinIndicatorSuccessCollapseAnimationData() =>
            SuccessCollapsePinIndicator(
              key: ValueKey(animation.id),
              length: widget.length,
              childSize: widget.size,
              duration: animation.data.duration,
              builder: (i) => currentDots[i],
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
          PinIndicatorErrorShakeAnimationData() => ErrorShakePinIndicator(
              key: ValueKey(animation.id),
              length: widget.length,
              childSize: widget.size,
              duration: animation.data.duration,
              builder: (i) => currentDots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorClearFadeAnimationData() => ClearFadePinIndicator(
              key: ValueKey(animation.id),
              length: widget.length,
              duration: animation.data.duration,
              builderOld: (i) => currentDots[i],
              builderNew: (i) => defaultDots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorClearDropAnimationData() => ClearDropPinIndicator(
              key: ValueKey(animation.id),
              length: widget.length,
              duration: animation.data.duration,
              builderOld: (i) => currentDots[i],
              builderNew: (i) => defaultDots[i],
              spacing: widget.spacing,
              childSize: widget.size,
            ),
          PinIndicatorEraseDeflateAnimationData() => EraseDeflatePinIndicator(
              key: ValueKey(animation.id),
              length: widget.length,
              currentPinLength: widget.currentLength,
              duration: animation.data.duration,
              builder: (i) => currentDots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorIdleWaveAnimationData() => IdleWavePinIndicator(
              key: ValueKey(animation.id),
              length: widget.length,
              duration: animation.data.duration,
              builder: (i) => currentDots[i],
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
