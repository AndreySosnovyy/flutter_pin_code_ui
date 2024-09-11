part of 'pin_indicator.dart';

class PinIndicatorAnimationController
    extends ValueNotifier<PinIndicatorAnimationValue> {
  PinIndicatorAnimationController(super.value);

  late final PinIndicatorAnimationsConfig _config;

  ///
  Future<void> animateInput() async {
    assert(value.inputAnimationController != null &&
        _config.inputAnimation != null);
  }

  ///
  Future<void> animateSuccess() async {
    assert(value.successAnimationController != null &&
        _config.successAnimation != null);
  }

  ///
  Future<void> animateError() async {
    assert(value.errorAnimationController != null &&
        _config.errorAnimation != null);
  }

  ///
  Future<void> animateClear() async {
    assert(value.clearAnimationController != null &&
        _config.clearAnimation != null);
  }

  ///
  Future<void> animateErase() async {
    assert(value.eraseAnimationController != null &&
        _config.eraseAnimation != null);
  }
}
