import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pin_ui/src/indicator/animations.dart';

class PinIndicatorAnimationController extends ValueNotifier<PinAnimation?> {
  PinIndicatorAnimationController() : super(null);

  // TODO(Sosnovyy): implement queue logic
  final _animationsQueue = Queue();

  bool get isAnimating => value != null;

  void stopAnimating() => value = null;

  bool get isAnimatingInput => value?.type == PinAnimationTypes.input;

  bool get isAnimatingLoading => value?.type == PinAnimationTypes.loading;

  bool get isAnimatingSuccess => value?.type == PinAnimationTypes.success;

  bool get isAnimatingError => value?.type == PinAnimationTypes.error;

  bool get isAnimatingClear => value?.type == PinAnimationTypes.clear;

  bool get isAnimatingErase => value?.type == PinAnimationTypes.erase;

  Future<void> _startAnimation(dynamic animation) async {
    value = PinAnimation.fromImpl(animation);
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
    // value.loadingAnimationController!.reset();
    // await value.loadingAnimationController!.animateTo(
    //   value.loadingAnimationController!.upperBound,
    //   curve: Curves.easeOutCubic,
    // );
    // await value.loadingAnimationController!.animateTo(
    //   value.loadingAnimationController!.lowerBound,
    //   curve: Curves.easeOut,
    // );
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
