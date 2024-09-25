import 'package:flutter/material.dart';
import 'package:pin_ui/src/indicator/animation_controller.dart';
import 'package:pin_ui/src/indicator/models/animation_data.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/clear/clear_drop_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/clear/clear_fade_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/erase/erase_deflate_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/erase/erase_fade_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/erase/erase_take_off_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/error/error_blink_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/error/error_brownian_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/error/error_jiggle_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/error/error_shake_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/idle/idle_flash_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/idle/idle_pulse_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/idle/idle_wave_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/input/input_fade_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/input/input_fall_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/input/input_inflate_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/loading/loading_collapse_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/loading/loading_jump_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/loading/loading_travel_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/loading/loading_wave_deflate_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/loading/loading_wave_inflate_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/success/success_collapse_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/success/success_fill_last_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/success/success_fill_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/success/success_kick_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/default_animation_children/pin_loading_collapse_child.dart';
import 'package:pin_ui/src/indicator/widgets/default_animation_children/pin_success_collapse_child.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/pin_indicator_dot.dart';

class PinIndicator extends StatefulWidget {
  const PinIndicator({
    required this.length,
    required this.currentLength,
    required this.isError,
    required this.isSuccess,
    this.controller,
    this.errorDecoration,
    this.successDecoration,
    this.inputDecoration,
    this.defaultDecoration,
    this.spacing = 24.0,
    this.size = 14.0,

    /// {@macro pin_ui.PinIndicator.successCollapseAnimationChild}
    this.loadingCollapseAnimationChild,

    /// {@macro pin_ui.PinIndicator.successCollapseAnimationChild}
    this.successCollapseAnimationChild,
    super.key,
  })  : assert(length >= currentLength),
        assert(length > 3),
        assert(spacing > 0),
        assert(size > 0);

  final PinIndicatorAnimationController? controller;
  final int length;
  final int currentLength;
  final bool isError;
  final bool isSuccess;
  final BoxDecoration? successDecoration;
  final BoxDecoration? errorDecoration;
  final BoxDecoration? defaultDecoration;
  final BoxDecoration? inputDecoration;
  final double spacing;
  final double size;

  /// {@template pin_ui.PinIndicator.successCollapseAnimationChild}
  /// Widget that will appear on the screen after all indicator items are
  /// collapsed in case of PinSuccessAnimation.collapse is chosen.
  /// {@endtemplate}
  final Widget? successCollapseAnimationChild;

  /// {@template pin_ui.PinIndicator.loadingCollapseAnimationChild}
  /// Widget that will appear on the screen after all indicator items are
  /// collapsed in case of PinLoadingAnimation.collapse is chosen.
  /// {@endtemplate}
  final Widget? loadingCollapseAnimationChild;

  @override
  State<PinIndicator> createState() => _PinIndicatorState();
}

class _PinIndicatorState extends State<PinIndicator> {
  BoxDecoration get successDecoration =>
      widget.successDecoration ??
      const BoxDecoration(shape: BoxShape.circle, color: Colors.green);

  BoxDecoration get errorDecoration =>
      widget.errorDecoration ??
      const BoxDecoration(shape: BoxShape.circle, color: Colors.red);

  BoxDecoration get defaultDecoration =>
      widget.defaultDecoration ??
      const BoxDecoration(shape: BoxShape.circle, color: Colors.black12);

  BoxDecoration get inputDecoration =>
      widget.inputDecoration ??
      const BoxDecoration(shape: BoxShape.circle, color: Colors.blue);

  late final defaultDots = List.generate(
    widget.length,
    (i) => PinIndicatorDot(
      size: widget.size,
      decoration: defaultDecoration,
    ),
  );
  late final inputDots = List.generate(
    widget.length,
    (i) => PinIndicatorDot(
      size: widget.size,
      decoration: inputDecoration,
    ),
  );

  BoxDecoration _getDecorationForDotIndexed(int index) {
    if (widget.isSuccess) return successDecoration;
    if (widget.isError) return errorDecoration;
    if (index < widget.currentLength) return inputDecoration;
    return defaultDecoration;
  }

  @override
  Widget build(BuildContext context) {
    final currentDots = List.generate(
      widget.length,
      (i) => PinIndicatorDot(
        size: widget.size,
        decoration: _getDecorationForDotIndexed(i),
      ),
    );
    final noAnimationPinIndicator = NoAnimationPinIndicator(
      length: widget.length,
      spacing: widget.spacing,
      builder: (i) => currentDots[i],
    );
    return ValueListenableBuilder(
      valueListenable: widget.controller ?? PinIndicatorAnimationController(),
      builder: (context, animation, child) {
        if (animation == null) return noAnimationPinIndicator;
        final animationKey = ValueKey(animation.id);
        final animationDuration =
            animation.data.duration * animation.durationMultiplier;
        return switch (animation.data) {
          PinIndicatorNoAnimationData() => noAnimationPinIndicator,
          PinIndicatorInputInflateAnimationData() => InputInflatePinIndicator(
              key: animationKey,
              length: widget.length,
              currentPinLength: widget.currentLength,
              duration: animationDuration,
              builder: (i) => currentDots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorInputFallAnimationData() => InputFallPinIndicator(
              key: animationKey,
              length: widget.length,
              currentPinLength: widget.currentLength,
              duration: animationDuration,
              builder: (i) => currentDots[i],
              builderDefault: (i) => defaultDots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorInputFadeAnimationData() => InputFadePinIndicator(
              key: animationKey,
              length: widget.length,
              currentPinLength: widget.currentLength,
              duration: animationDuration,
              builder: (i) => currentDots[i],
              builderDefault: (i) => defaultDots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorLoadingJumpAnimationData() => LoadingJumpPinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builder: (i) => currentDots[i],
              spacing: widget.spacing,
              childSize: widget.size,
            ),
          PinIndicatorLoadingWaveInflateAnimationData() =>
            LoadingWaveInflatePinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builder: (i) => currentDots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorLoadingWaveDeflateAnimationData() =>
            LoadingWaveDeflatePinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builder: (i) => currentDots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorLoadingTravelAnimationData() => LoadingTravelPinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builder: (i) => currentDots[i],
              spacing: widget.spacing,
              childSize: widget.size,
            ),
          PinIndicatorLoadingCollapseAnimationData() =>
            LoadingCollapsePinIndicator(
              key: animationKey,
              length: widget.length,
              childSize: widget.size,
              duration: animationDuration,
              builder: (i) => currentDots[i],
              spacing: widget.spacing,
              loadingIndicator: widget.loadingCollapseAnimationChild ??
                  DefaultPinLoadingCollapseAnimationChild(
                    anchorSize: widget.size,
                  ),
            ),
          PinIndicatorSuccessCollapseAnimationData() =>
            SuccessCollapsePinIndicator(
              key: animationKey,
              length: widget.length,
              childSize: widget.size,
              duration: animationDuration,
              builder: (i) => currentDots[i],
              spacing: widget.spacing,
              collapsedChild: widget.successCollapseAnimationChild ??
                  DefaultPinSuccessCollapseAnimationChild(
                    anchorSize: widget.size,
                  ),
            ),
          PinIndicatorSuccessFillAnimationData() => SuccessFillPinIndicator(
              key: animationKey,
              length: widget.length,
              childSize: widget.size,
              duration: animationDuration,
              builder: (i) => currentDots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorSuccessFillLastAnimationData() =>
            SuccessFillLastPinIndicator(
              key: animationKey,
              length: widget.length,
              childSize: widget.size,
              duration: animationDuration,
              builder: (i) => currentDots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorSuccessKickAnimationData() => SuccessKickPinIndicator(
              key: animationKey,
              length: widget.length,
              childSize: widget.size,
              duration: animationDuration,
              builder: (i) => currentDots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorErrorShakeAnimationData() => ErrorShakePinIndicator(
              key: animationKey,
              length: widget.length,
              childSize: widget.size,
              duration: animationDuration,
              builder: (i) => currentDots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorErrorBlinkAnimationData() => ErrorBlinkPinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builder: (i) => currentDots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorErrorJiggleAnimationData() => ErrorJigglePinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builder: (i) => currentDots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorErrorBrownianAnimationData() => ErrorBrownianPinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builder: (i) => currentDots[i],
              spacing: widget.spacing,
              childSize: widget.size,
            ),
          PinIndicatorClearFadeAnimationData() => ClearFadePinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builderOld: (i) => currentDots[i],
              builderNew: (i) => defaultDots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorClearDropAnimationData() => ClearDropPinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builderOld: (i) => currentDots[i],
              builderNew: (i) => defaultDots[i],
              spacing: widget.spacing,
              childSize: widget.size,
            ),
          PinIndicatorEraseDeflateAnimationData() => EraseDeflatePinIndicator(
              key: animationKey,
              length: widget.length,
              currentPinLength: widget.currentLength,
              duration: animationDuration,
              builder: (i) => currentDots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorEraseTakeOffAnimationData() => EraseTakeOffPinIndicator(
              key: animationKey,
              length: widget.length,
              currentPinLength: widget.currentLength,
              duration: animationDuration,
              builder: (i) => currentDots[i],
              builderInput: (i) => inputDots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorEraseFadeAnimationData() => EraseFadePinIndicator(
              key: animationKey,
              length: widget.length,
              currentPinLength: widget.currentLength,
              duration: animationDuration,
              builder: (i) => currentDots[i],
              builderInput: (i) => inputDots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorIdleWaveAnimationData() => IdleWavePinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builder: (i) => currentDots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorIdlePulseAnimationData() => IdlePulsePinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builder: (i) => currentDots[i],
              spacing: widget.spacing,
            ),
          PinIndicatorIdleFlashAnimationData() => IdleFlashPinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builder: (i) => currentDots[i],
              spacing: widget.spacing,
            ),
        };
      },
    );
  }
}
