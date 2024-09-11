import 'package:pin_ui/src/indicator/animations.dart';

class PinIndicatorAnimationsConfig {
  PinIndicatorAnimationsConfig._({
    required this.inputAnimation,
    required this.loadingAnimation,
    required this.successAnimation,
    required this.errorAnimation,
    required this.clearAnimation,
    required this.eraseAnimation,
  });

  factory PinIndicatorAnimationsConfig.defaults() =>
      PinIndicatorAnimationsConfig._(
        inputAnimation: PinInputAnimation.inflate,
        loadingAnimation: PinLoadingAnimation.jump,
        successAnimation: PinSuccessAnimation.collapse,
        errorAnimation: PinErrorAnimation.shake,
        clearAnimation: PinClearAnimation.drop,
        eraseAnimation: PinEraseAnimation.deflate,
      );

  factory PinIndicatorAnimationsConfig.disabled() =>
      PinIndicatorAnimationsConfig._(
        inputAnimation: null,
        loadingAnimation: null,
        successAnimation: null,
        errorAnimation: null,
        clearAnimation: null,
        eraseAnimation: null,
      );

  final PinInputAnimation? inputAnimation;
  final PinLoadingAnimation? loadingAnimation;
  final PinSuccessAnimation? successAnimation;
  final PinErrorAnimation? errorAnimation;
  final PinClearAnimation? clearAnimation;
  final PinEraseAnimation? eraseAnimation;
}
