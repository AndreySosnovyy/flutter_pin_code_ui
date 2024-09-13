import 'package:flutter/material.dart';
import 'package:pin_ui/src/indicator/animations.dart';

class PinIndicatorAnimationController
    extends ValueNotifier<PinIndicatorAnimation?> {
  PinIndicatorAnimationController() : super(null);

  bool get isAnimating => value != null;

  /// Returns true if current animation is interruptible.
  /// Returns false if current animation is not interruptible.
  /// Returns null if there is no current animation.
  bool? get isAnimatingInterruptible => value?.isInterruptible;

  void stopAnimating() => value = null;

  bool get isAnimatingInput => value?.type == PinAnimationTypes.input;

  bool get isAnimatingLoading => value?.type == PinAnimationTypes.loading;

  bool get isAnimatingSuccess => value?.type == PinAnimationTypes.success;

  bool get isAnimatingError => value?.type == PinAnimationTypes.error;

  bool get isAnimatingClear => value?.type == PinAnimationTypes.clear;

  bool get isAnimatingErase => value?.type == PinAnimationTypes.erase;

  Future<void> _startAnimation(dynamic animation) async {
    value = PinIndicatorAnimation.fromImpl(animation);
    await Future.delayed(value!.duration);
  }

  Future<void> animateInput({
    PinInputAnimation animation = PinInputAnimation.inflate,
  }) async {
    await _startAnimation(animation);
  }

  Future<void> animateLoading({
    PinLoadingAnimation animation = PinLoadingAnimation.jump,
    bool vibration = false,
  }) async {
    await _startAnimation(animation);
  }

  Future<void> animateSuccess({
    PinSuccessAnimation animation = PinSuccessAnimation.collapse,
    bool vibration = false,
  }) async {
    await _startAnimation(animation);
  }

  Future<void> animateError({
    PinErrorAnimation animation = PinErrorAnimation.shake,
    bool vibration = false,
  }) async {
    await _startAnimation(animation);
  }

  Future<void> animateClear({
    PinClearAnimation animation = PinClearAnimation.drop,
    bool vibration = false,
  }) async {
    await _startAnimation(animation);
  }

  Future<void> animateErase({
    PinEraseAnimation animation = PinEraseAnimation.deflate,
  }) async {
    await _startAnimation(animation);
  }
}
