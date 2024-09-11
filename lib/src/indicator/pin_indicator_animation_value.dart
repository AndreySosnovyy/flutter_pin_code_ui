import 'package:flutter/animation.dart';

class PinIndicatorAnimationValue {
  PinIndicatorAnimationValue({
    this.currentLength = 0,
    this.maxLength = 4,
  });

  /// Current length of input
  final int currentLength;

  /// Maximum length of input. In other words, pin length.
  /// Defaults to 4.
  final int maxLength;

  /// Controller for animating one key input
  late final AnimationController? inputAnimationController;

  /// Controller for animating valid pin
  late final AnimationController? successAnimationController;

  /// Controller for animating invalid pin
  late final AnimationController? errorAnimationController;

  /// Controller for animating whole pin clearing
  late final AnimationController? clearAnimationController;

  /// Controller for animating one symbol erasing
  late final AnimationController? eraseAnimationController;
}
