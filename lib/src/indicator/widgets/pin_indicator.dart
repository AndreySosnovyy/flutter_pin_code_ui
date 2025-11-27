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
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/loading/loading_wave_fade_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/loading/loading_wave_inflate_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/success/success_collapse_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/success/success_fill_last_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/success/success_fill_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/animated_pin_indicators/success/success_kick_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/default_animation_children/pin_loading_collapse_child.dart';
import 'package:pin_ui/src/indicator/widgets/default_animation_children/pin_success_collapse_child.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/pin_indicator_item.dart';

/// Pin indicator item widget builder.
typedef PinIndicatorItemBuilder = PreferredSizeWidget Function(int index);

// TODO(Sosnovyy): maybe change isError and isSuccess with enum state parameter
/// Pin indicator widget.
class PinIndicator extends StatefulWidget {
  /// Simple decorated Pin Indicator widget.
  PinIndicator({
    required this.length,
    required this.currentLength,
    required this.isError,
    required this.isSuccess,
    this.controller,
    BoxDecoration? errorDecoration,
    BoxDecoration? successDecoration,
    BoxDecoration? inputDecoration,
    BoxDecoration? defaultDecoration,
    this.spacing = 24.0,
    this.itemSize = 14.0,
    this.loadingCollapseAnimationChild,
    this.successCollapseAnimationChild,
    super.key,
  })  : assert(length >= currentLength),
        assert(length > 3),
        assert(spacing > 0),
        assert(itemSize > 0),
        assert(!isError || !isSuccess),
        defaultItemBuilder = ((_) => PinIndicatorItem(
              size: itemSize,
              decoration: defaultDecoration ??
                  const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.black26),
            )),
        errorItemBuilder = ((_) => PinIndicatorItem(
              size: itemSize,
              decoration: errorDecoration ??
                  const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.red),
            )),
        successItemBuilder = ((_) => PinIndicatorItem(
              size: itemSize,
              decoration: successDecoration ??
                  const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.green),
            )),
        inputItemBuilder = ((_) => PinIndicatorItem(
            size: itemSize,
            decoration: inputDecoration ??
                const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.blue)));

  /// Pin Indicator builder version where you can build any child via builders
  /// as items.
  const PinIndicator.builder({
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
    this.loadingCollapseAnimationChild,
    this.successCollapseAnimationChild,
    super.key,
  })  : assert(length >= currentLength),
        assert(length > 3),
        assert(spacing > 0),
        assert(!isError || !isSuccess),
        itemSize = -1;

  /// {@template pin_ui.PinIndicatorBuilder.controller}
  /// Controller for managing animations.
  /// {@endtemplate}
  final PinIndicatorAnimationController? controller;

  /// {@template pin_ui.PinIndicatorBuilder.length}
  /// Number of items in Pin indicator.
  /// {@endtemplate}
  final int length;

  /// {@template pin_ui.PinIndicatorBuilder.currentLength}
  /// Current number of entered pin code symbols.
  /// {@endtemplate}
  final int currentLength;

  /// {@template pin_ui.PinIndicatorBuilder.isError}
  /// If Pin indicator is in error state (wrong pin entered).
  /// {@endtemplate}
  final bool isError;

  /// {@template pin_ui.PinIndicatorBuilder.isSuccess}
  /// If Pin indicator is in success state (correct pin entered).
  /// {@endtemplate}
  final bool isSuccess;

  /// {@template pin_ui.PinIndicatorBuilder.successItemBuilder}
  /// Builder for item in success state.
  /// {@endtemplate}
  final PinIndicatorItemBuilder successItemBuilder;

  /// {@template pin_ui.PinIndicatorBuilder.errorItemBuilder}
  /// Builder for item in error state.
  /// {@endtemplate}
  final PinIndicatorItemBuilder errorItemBuilder;

  /// {@template pin_ui.PinIndicatorBuilder.defaultItemBuilder}
  /// Builder for item in default state.
  /// {@endtemplate}
  final PinIndicatorItemBuilder defaultItemBuilder;

  /// {@template pin_ui.PinIndicatorBuilder.inputItemBuilder}
  /// Builder for item in input state (for entered symbols).
  /// {@endtemplate}
  final PinIndicatorItemBuilder inputItemBuilder;

  /// {@template pin_ui.PinIndicatorBuilder.spacing}
  /// Spacing between Pin indicator items.
  /// {@endtemplate}
  final double spacing;

  /// Size of Pin indicator item. Value is used in some animations.
  /// If size is not symmetric or different, provide estimate value.
  // This will be -1 for .builder constructor
  final double itemSize;

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
  /// Fallback controller used when widget.controller is null.
  /// This prevents creating a new controller on every build.
  PinIndicatorAnimationController? _fallbackController;

  PinIndicatorAnimationController get _effectiveController {
    if (widget.controller != null) return widget.controller!;
    _fallbackController ??= PinIndicatorAnimationController();
    return _fallbackController!;
  }

  PreferredSizeWidget _buildItemForIndex(int index) {
    if (widget.isSuccess) return widget.successItemBuilder(index);
    if (widget.isError) return widget.errorItemBuilder(index);
    if (index < widget.currentLength) return widget.inputItemBuilder(index);
    return widget.defaultItemBuilder(index);
  }

  /// Internal getter to check if items of Pin Indicator has size.
  /// If no, estimated size needs to be calculated for animations.
  bool get hasPreconfiguredSize => widget.itemSize != -1;

  /// Calculates max item size
  double calculateSizeForItems(List<PreferredSizeWidget> items) {
    double maxSize = 0;
    for (final item in items) {
      final size = (item.preferredSize.width + item.preferredSize.height) / 2;
      if (size > maxSize) maxSize = size;
    }
    return maxSize;
  }

  @override
  Widget build(BuildContext context) {
    final currentItems = List.generate(
      widget.length,
      (i) => _buildItemForIndex(i),
    );
    final noAnimationPinIndicator = NoAnimationPinIndicator(
      length: widget.length,
      spacing: widget.spacing,
      builder: (i) => currentItems[i],
    );
    final itemSize = hasPreconfiguredSize
        ? widget.itemSize
        : calculateSizeForItems(currentItems);
    return ValueListenableBuilder(
      valueListenable: _effectiveController,
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
              childSize: itemSize,
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
              childSize: itemSize,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorLoadingCollapseAnimationData() =>
            LoadingCollapsePinIndicator(
              key: animationKey,
              length: widget.length,
              childSize: itemSize,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              spacing: widget.spacing,
              loadingIndicator: widget.loadingCollapseAnimationChild ??
                  DefaultPinLoadingCollapseAnimationChild(
                    anchorSize: itemSize,
                  ),
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorLoadingWaveFadeAnimationData() =>
            LoadingWaveFadePinIndicator(
              key: animationKey,
              length: widget.length,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              spacing: widget.spacing,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorSuccessCollapseAnimationData() =>
            SuccessCollapsePinIndicator(
              key: animationKey,
              length: widget.length,
              childSize: itemSize,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              spacing: widget.spacing,
              collapsedChild: widget.successCollapseAnimationChild ??
                  DefaultPinSuccessCollapseAnimationChild(
                    anchorSize: itemSize,
                  ),
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorSuccessFillAnimationData() => SuccessFillPinIndicator(
              key: animationKey,
              length: widget.length,
              childSize: itemSize,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              spacing: widget.spacing,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorSuccessFillLastAnimationData() =>
            SuccessFillLastPinIndicator(
              key: animationKey,
              length: widget.length,
              childSize: itemSize,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              spacing: widget.spacing,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorSuccessKickAnimationData() => SuccessKickPinIndicator(
              key: animationKey,
              length: widget.length,
              childSize: itemSize,
              duration: animationDuration,
              builder: (i) => currentItems[i],
              spacing: widget.spacing,
              vibration: isVibrationEnabledAndCanVibrate,
            ),
          PinIndicatorErrorShakeAnimationData() => ErrorShakePinIndicator(
              key: animationKey,
              length: widget.length,
              childSize: itemSize,
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
              childSize: itemSize,
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
              childSize: itemSize,
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

  @override
  void dispose() {
    _fallbackController?.dispose();
    super.dispose();
  }
}
