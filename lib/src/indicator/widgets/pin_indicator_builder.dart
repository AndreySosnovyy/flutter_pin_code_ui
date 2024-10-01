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

/// Pin indicator item widget builder.
typedef PinIndicatorItemBuilder = Widget Function(int index);

/// {@template pin_ui.PinIndicatorBuilder}
/// Pin indicator widget builder.
/// {@endtemplate}
class PinIndicatorBuilder extends StatefulWidget {
  /// {@macro pin_ui.PinIndicatorBuilder}
  const PinIndicatorBuilder({
    required this.length,
    required this.currentLength,
    required this.isError,
    required this.isSuccess,
    required this.errorItemBuilder,
    required this.successItemBuilder,
    required this.inputItemBuilder,
    required this.defaultItemBuilder,
    this.controller,
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
  final PinIndicatorItemBuilder successItemBuilder;
  final PinIndicatorItemBuilder errorItemBuilder;
  final PinIndicatorItemBuilder defaultItemBuilder;
  final PinIndicatorItemBuilder inputItemBuilder;
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
  State<PinIndicatorBuilder> createState() => _PinIndicatorBuilderState();
}

class _PinIndicatorBuilderState extends State<PinIndicatorBuilder> {
  PinIndicatorItemBuilder _getBuilderForItemIndexed(int index) {
    if (widget.isSuccess) return widget.successItemBuilder;
    if (widget.isError) return widget.errorItemBuilder;
    if (index < widget.currentLength) return widget.inputItemBuilder;
    return widget.defaultItemBuilder;
  }

  @override
  Widget build(BuildContext context) {
    final currentItems = List.generate(
      widget.length,
      (i) => _getBuilderForItemIndexed(i)(i),
    );
    final noAnimationPinIndicator = NoAnimationPinIndicator(
      length: widget.length,
      spacing: widget.spacing,
      builder: (i) => currentItems[i],
    );
    return ValueListenableBuilder(
      valueListenable: widget.controller ?? PinIndicatorAnimationController(),
      builder: (context, animation, child) {
        if (animation == null) return noAnimationPinIndicator;
        final animationKey = ValueKey(animation.id);
        final animationDuration =
            animation.data.duration * animation.durationMultiplier;
        final isVibrationEnabledAndCanVibrate = animation.vibrationEnabled &&
            (widget.controller?.canVibrate ?? false);
        return switch (animation.data) {
          PinIndicatorNoAnimationData() => noAnimationPinIndicator,
          PinIndicatorInputInflateAnimationData() => InputInflatePinIndicator(
              key: animationKey,
              length: widget.length,
              currentPinLength: widget.currentLength,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              spacing: widget.spacing,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorInputFallAnimationData() => InputFallPinIndicator(
              key: animationKey,
              length: widget.length,
              currentPinLength: widget.currentLength,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              builderDefault: (i) => widget.defaultItemBuilder(i),
              spacing: widget.spacing,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorInputFadeAnimationData() => InputFadePinIndicator(
              key: animationKey,
              length: widget.length,
              currentPinLength: widget.currentLength,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              builderDefault: (i) => widget.defaultItemBuilder(i),
              spacing: widget.spacing,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorLoadingJumpAnimationData() => LoadingJumpPinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              spacing: widget.spacing,
              childSize: widget.size,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorLoadingWaveInflateAnimationData() =>
            LoadingWaveInflatePinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              spacing: widget.spacing,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorLoadingWaveDeflateAnimationData() =>
            LoadingWaveDeflatePinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              spacing: widget.spacing,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorLoadingTravelAnimationData() => LoadingTravelPinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              spacing: widget.spacing,
              childSize: widget.size,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorLoadingCollapseAnimationData() =>
            LoadingCollapsePinIndicator(
              key: animationKey,
              length: widget.length,
              childSize: widget.size,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              spacing: widget.spacing,
              loadingIndicator: widget.loadingCollapseAnimationChild ??
                  DefaultPinLoadingCollapseAnimationChild(
                    anchorSize: widget.size,
                  ),
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorSuccessCollapseAnimationData() =>
            SuccessCollapsePinIndicator(
              key: animationKey,
              length: widget.length,
              childSize: widget.size,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              spacing: widget.spacing,
              collapsedChild: widget.successCollapseAnimationChild ??
                  DefaultPinSuccessCollapseAnimationChild(
                    anchorSize: widget.size,
                  ),
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorSuccessFillAnimationData() => SuccessFillPinIndicator(
              key: animationKey,
              length: widget.length,
              childSize: widget.size,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              spacing: widget.spacing,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorSuccessFillLastAnimationData() =>
            SuccessFillLastPinIndicator(
              key: animationKey,
              length: widget.length,
              childSize: widget.size,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              spacing: widget.spacing,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorSuccessKickAnimationData() => SuccessKickPinIndicator(
              key: animationKey,
              length: widget.length,
              childSize: widget.size,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              spacing: widget.spacing,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorErrorShakeAnimationData() => ErrorShakePinIndicator(
              key: animationKey,
              length: widget.length,
              childSize: widget.size,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              spacing: widget.spacing,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorErrorBlinkAnimationData() => ErrorBlinkPinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              spacing: widget.spacing,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorErrorJiggleAnimationData() => ErrorJigglePinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              spacing: widget.spacing,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorErrorBrownianAnimationData() => ErrorBrownianPinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              spacing: widget.spacing,
              childSize: widget.size,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorClearFadeAnimationData() => ClearFadePinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builderOld: (i) => currentItems[i],
              builderNew: (i) => widget.defaultItemBuilder(i),
              spacing: widget.spacing,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorClearDropAnimationData() => ClearDropPinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builderOld: (i) => currentItems[i],
              builderNew: (i) => widget.defaultItemBuilder(i),
              spacing: widget.spacing,
              childSize: widget.size,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorEraseDeflateAnimationData() => EraseDeflatePinIndicator(
              key: animationKey,
              length: widget.length,
              currentPinLength: widget.currentLength,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              spacing: widget.spacing,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorEraseTakeOffAnimationData() => EraseTakeOffPinIndicator(
              key: animationKey,
              length: widget.length,
              currentPinLength: widget.currentLength,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              builderInput: (i) => widget.inputItemBuilder(i),
              spacing: widget.spacing,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorEraseFadeAnimationData() => EraseFadePinIndicator(
              key: animationKey,
              length: widget.length,
              currentPinLength: widget.currentLength,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              builderInput: (i) => widget.inputItemBuilder(i),
              spacing: widget.spacing,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorIdleWaveAnimationData() => IdleWavePinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              spacing: widget.spacing,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorIdlePulseAnimationData() => IdlePulsePinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              spacing: widget.spacing,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorIdleFlashAnimationData() => IdleFlashPinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              spacing: widget.spacing,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
        };
      },
    );
  }
}
