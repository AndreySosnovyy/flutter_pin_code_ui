import 'package:flutter/animation.dart';

class PinIndicatorAnimationValue {
  PinIndicatorAnimationValue({
    required this.currentLength,
    required this.maxLength,
    this.inputAnimationController,
    this.loadingAnimationController,
    this.successAnimationController,
    this.errorAnimationController,
    this.clearAnimationController,
    this.eraseAnimationController,
  });

  /// Current length of input
  final int currentLength;

  /// Maximum length of input. In other words, pin length.
  /// Defaults to 4.
  final int maxLength;

  /// Controller for animating one key input
  final AnimationController? inputAnimationController;

  /// Controller for animating loading state
  final AnimationController? loadingAnimationController;

  /// Controller for animating valid pin
  final AnimationController? successAnimationController;

  /// Controller for animating invalid pin
  final AnimationController? errorAnimationController;

  /// Controller for animating whole pin clearing
  final AnimationController? clearAnimationController;

  /// Controller for animating one symbol erasing
  final AnimationController? eraseAnimationController;

  PinIndicatorAnimationValue copyWith({
    int? currentLength,
    int? maxLength,
    AnimationController? inputAnimationController,
    AnimationController? loadingAnimationController,
    AnimationController? successAnimationController,
    AnimationController? errorAnimationController,
    AnimationController? clearAnimationController,
    AnimationController? eraseAnimationController,
  }) {
    return PinIndicatorAnimationValue(
      currentLength: currentLength ?? this.currentLength,
      maxLength: maxLength ?? this.maxLength,
      inputAnimationController:
          inputAnimationController ?? this.inputAnimationController,
      loadingAnimationController:
          loadingAnimationController ?? this.loadingAnimationController,
      successAnimationController:
          successAnimationController ?? this.successAnimationController,
      errorAnimationController:
          errorAnimationController ?? this.errorAnimationController,
      clearAnimationController:
          clearAnimationController ?? this.clearAnimationController,
      eraseAnimationController:
          eraseAnimationController ?? this.eraseAnimationController,
    );
  }
}
