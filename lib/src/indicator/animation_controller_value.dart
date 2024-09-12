import 'package:flutter/animation.dart';

class PinIndicatorAnimationControllerValue {
  PinIndicatorAnimationControllerValue({
    required this.currentLength,
    required this.maxLength,
    required this.vsync,
  }) {
    inputAnimationController = AnimationController(vsync: vsync);
    loadingAnimationController = AnimationController(vsync: vsync);
    successAnimationController = AnimationController(vsync: vsync);
    errorAnimationController = AnimationController(vsync: vsync);
    clearAnimationController = AnimationController(vsync: vsync);
    eraseAnimationController = AnimationController(vsync: vsync);
  }

  /// Current length of input
  final int currentLength;

  /// Maximum length of input. In other words, pin length.
  /// Defaults to 4.
  final int maxLength;

  final TickerProvider vsync;

  /// Controller for animating one key input
  late final AnimationController inputAnimationController;

  /// Controller for animating loading state
  late final AnimationController loadingAnimationController;

  /// Controller for animating valid pin
  late final AnimationController successAnimationController;

  /// Controller for animating invalid pin
  late final AnimationController errorAnimationController;

  /// Controller for animating whole pin clearing
  late final AnimationController clearAnimationController;

  /// Controller for animating one symbol erasing
  late final AnimationController eraseAnimationController;

  PinIndicatorAnimationControllerValue copyWith({
    int? currentLength,
    int? maxLength,
    AnimationController? inputAnimationController,
    AnimationController? loadingAnimationController,
    AnimationController? successAnimationController,
    AnimationController? errorAnimationController,
    AnimationController? clearAnimationController,
    AnimationController? eraseAnimationController,
  }) {
    return PinIndicatorAnimationControllerValue(
      vsync: vsync,
      currentLength: currentLength ?? this.currentLength,
      maxLength: maxLength ?? this.maxLength,
    );
  }
}
