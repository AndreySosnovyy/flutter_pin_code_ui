part of 'pin_indicator.dart';

class PinIndicatorAnimationController
    extends ValueNotifier<PinIndicatorAnimationValue> {
  PinIndicatorAnimationController({
    required this.vsync,
    int currentLength = 0,
    int maxLength = 4,
  }) : super(PinIndicatorAnimationValue(
          currentLength: currentLength,
          maxLength: maxLength,
        ));

  final TickerProvider vsync;
  late final PinIndicatorAnimationsConfig _config;

  final _configInitializationCompleter = Completer<void>();

  void _setConfig(PinIndicatorAnimationsConfig config) {
    _config = config;
    _configInitializationCompleter.complete();
    // TODO(Sosnovyy): set animation controllers
  }

  void _verifyInitialized() {
    assert(_configInitializationCompleter.isCompleted,
        'Controller has no listeners. Layout them before calling animate methods.');
  }

  Future<void> animateInput({required int currentLength}) async {
    _verifyInitialized();
    assert(value.inputAnimationController != null &&
        _config.inputAnimation != null);
    assert(currentLength >= 0 && currentLength <= value.maxLength);
    value = value.copyWith(currentLength: currentLength);
    throw UnimplementedError();
  }

  Future<void> animateLoading() async {
    _verifyInitialized();
    assert(value.loadingAnimationController != null &&
        _config.loadingAnimation != null);
    throw UnimplementedError();
  }

  Future<void> animateSuccess() async {
    _verifyInitialized();
    assert(value.successAnimationController != null &&
        _config.successAnimation != null);
    throw UnimplementedError();
  }

  Future<void> animateError() async {
    _verifyInitialized();
    assert(value.errorAnimationController != null &&
        _config.errorAnimation != null);
    throw UnimplementedError();
  }

  Future<void> animateClear() async {
    _verifyInitialized();
    assert(value.clearAnimationController != null &&
        _config.clearAnimation != null);
    throw UnimplementedError();
  }

  Future<void> animateErase({required int currentLength}) async {
    _verifyInitialized();
    assert(value.eraseAnimationController != null &&
        _config.eraseAnimation != null);
    assert(currentLength >= 0 && currentLength <= value.maxLength);
    value = value.copyWith(currentLength: currentLength);
    throw UnimplementedError();
  }
}
