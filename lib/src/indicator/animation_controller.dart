import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pin_ui/src/indicator/animations.dart';

class PinIndicatorAnimationController
    extends ValueNotifier<PinIndicatorAnimation?> {
  PinIndicatorAnimationController() : super(null);

  bool get isAnimating => value != null;

  bool get isAnimatingNonInterruptible => !(value?.isInterruptible ?? true);

  bool get isAnimatingInput => value?.type == PinAnimationTypes.input;

  bool get isAnimatingLoading => value?.type == PinAnimationTypes.loading;

  bool get isAnimatingSuccess => value?.type == PinAnimationTypes.success;

  bool get isAnimatingError => value?.type == PinAnimationTypes.error;

  bool get isAnimatingClear => value?.type == PinAnimationTypes.clear;

  bool get isAnimatingErase => value?.type == PinAnimationTypes.erase;

  // TODO(Sosnovyy): implement queue instead of async calls
  final animationsQueue = Queue();

  void stopAnimating() {
    value = null;
    notifyListeners();
  }

  Future<void> _startAnimating(dynamic animation) async {
    value = PinIndicatorAnimation.fromImpl(animation);
    notifyListeners();
    await Future.delayed(value!.duration);
    stopAnimating();
  }

  Future<void> animateInput({
    PinInputAnimation animation = PinInputAnimation.inflate,
  }) async {
    await _startAnimating(animation);
  }

  Future<void> animateLoading({
    PinLoadingAnimation animation = PinLoadingAnimation.jump,
    bool vibration = false,
    int repeatCount = 1,
  }) async {
    for (int i = 0; i < repeatCount; i++) {
      await _startAnimating(animation);
    }
  }

  Future<void> animateSuccess({
    PinSuccessAnimation animation = PinSuccessAnimation.collapse,
    bool vibration = false,
  }) async {
    await _startAnimating(animation);
  }

  Future<void> animateError({
    PinErrorAnimation animation = PinErrorAnimation.shake,
    bool vibration = false,
  }) async {
    await _startAnimating(animation);
  }

  Future<void> animateClear({
    PinClearAnimation animation = PinClearAnimation.drop,
    bool vibration = false,
  }) async {
    await _startAnimating(animation);
  }

  Future<void> animateErase({
    PinEraseAnimation animation = PinEraseAnimation.deflate,
  }) async {
    await _startAnimating(animation);
  }
}
