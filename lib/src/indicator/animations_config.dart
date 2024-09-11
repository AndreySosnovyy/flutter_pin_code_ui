import 'package:pin_ui/src/indicator/animations.dart';

class PinIndicatorAnimationsConfig {
  PinIndicatorAnimationsConfig._({
    required this.inputAnimation,
    required this.successAnimation,
    required this.errorAnimation,
    required this.clearAnimation,
    required this.eraseAnimation,
  });

  factory PinIndicatorAnimationsConfig.defaults() =>
      PinIndicatorAnimationsConfig._(
        inputAnimation: PinInputAnimation.inflation,
        successAnimation: PinSuccessAnimation.collapse,
        errorAnimation: PinErrorAnimation.shaking,
        clearAnimation: PinClearAnimation.dropping,
        eraseAnimation: PinEraseAnimation.deflation,
      );

  factory PinIndicatorAnimationsConfig.disabled() =>
      PinIndicatorAnimationsConfig._(
        inputAnimation: null,
        successAnimation: null,
        errorAnimation: null,
        clearAnimation: null,
        eraseAnimation: null,
      );

  final PinInputAnimation? inputAnimation;
  final PinSuccessAnimation? successAnimation;
  final PinErrorAnimation? errorAnimation;
  final PinClearAnimation? clearAnimation;
  final PinEraseAnimation? eraseAnimation;
}
