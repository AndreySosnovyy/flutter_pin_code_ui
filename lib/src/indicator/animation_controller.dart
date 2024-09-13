part of 'widgets/pin_indicator.dart';

class PinIndicatorAnimationController
    extends ValueNotifier<PinIndicatorAnimationControllerValue> {
  PinIndicatorAnimationController({
    required TickerProvider vsync,
    int currentLength = 0,
    int maxLength = 4,
  })  : _vsync = vsync,
        super(PinIndicatorAnimationControllerValue(
          currentLength: currentLength,
          maxLength: maxLength,
        ));

  late final PinIndicatorAnimationsConfig _config;
  final TickerProvider _vsync;

  final _configInitializationCompleter = Completer<void>();

  void _setConfig(PinIndicatorAnimationsConfig config) {
    _config = config;
    final provider = PinAnimationControllerProvider(vsync: _vsync);
    value = value.copyWith(
      inputAnimationController:
          provider.getControllerFor(_config.inputAnimation),
      loadingAnimationController:
          provider.getControllerFor(_config.loadingAnimation),
      successAnimationController:
          provider.getControllerFor(_config.successAnimation),
      errorAnimationController:
          provider.getControllerFor(_config.errorAnimation),
      clearAnimationController:
          provider.getControllerFor(_config.clearAnimation),
      eraseAnimationController:
          provider.getControllerFor(_config.eraseAnimation),
    );
    _configInitializationCompleter.complete();
  }

  void _verifyInitialized() {
    assert(_configInitializationCompleter.isCompleted,
        'Controller has no listeners. Layout them before calling animate methods.');
  }

  Future<void> animateInput({
    required int currentLength,
    bool vibration = false,
  }) async {
    _verifyInitialized();
    assert(value.inputAnimationController != null);
    assert(currentLength >= 0 && currentLength <= value.maxLength);
    value = value.copyWith(currentLength: currentLength);
    switch (_config.inputAnimation!) {
      case PinInputAnimation.inflate:
        value.inputAnimationController!.duration =
            const Duration(milliseconds: 100);
        value.inputAnimationController!.reset();
        await value.inputAnimationController!.animateTo(
          value.inputAnimationController!.upperBound,
          curve: Curves.ease,
        );
        await value.inputAnimationController!.animateTo(
          value.inputAnimationController!.lowerBound,
          curve: Curves.easeIn,
        );
    }
  }

  bool get isAnimatingInput =>
      value.inputAnimationController?.isAnimating ?? false;

  Future<void> animateLoading({
    bool vibration = false,
  }) async {
    _verifyInitialized();
    assert(value.loadingAnimationController != null);
    throw UnimplementedError();
  }

  bool get isAnimatingLoading =>
      value.loadingAnimationController?.isAnimating ?? false;

  Future<void> animateSuccess({
    bool vibration = false,
  }) async {
    _verifyInitialized();
    assert(value.successAnimationController != null);
    throw UnimplementedError();
  }

  bool get isAnimatingSuccess =>
      value.successAnimationController?.isAnimating ?? false;

  Future<void> animateError({
    bool vibration = false,
  }) async {
    _verifyInitialized();
    assert(value.errorAnimationController != null);
    throw UnimplementedError();
  }

  bool get isAnimatingError =>
      value.errorAnimationController?.isAnimating ?? false;

  Future<void> animateClear({
    bool vibration = false,
  }) async {
    _verifyInitialized();
    assert(value.clearAnimationController != null);
    throw UnimplementedError();
  }

  bool get isAnimatingClear =>
      value.clearAnimationController?.isAnimating ?? false;

  Future<void> animateErase({required int currentLength}) async {
    _verifyInitialized();
    assert(value.eraseAnimationController != null);
    assert(currentLength >= 0 && currentLength <= value.maxLength);
    value = value.copyWith(currentLength: currentLength);
    switch (_config.eraseAnimation!) {
      case PinEraseAnimation.deflate:
        value.eraseAnimationController!.duration =
            const Duration(milliseconds: 80);
        value.eraseAnimationController!.reset();
        value.eraseAnimationController!.value = 1.0;
        await value.eraseAnimationController!.animateBack(
          value.eraseAnimationController!.lowerBound,
          curve: Curves.easeOutQuint,
        );
        await value.eraseAnimationController!.animateTo(
          value.eraseAnimationController!.upperBound,
          curve: Curves.linear,
        );
    }
  }

  bool get isAnimatingErase =>
      value.eraseAnimationController?.isAnimating ?? false;

  @override
  void dispose() {
    value.inputAnimationController?.dispose();
    value.loadingAnimationController?.dispose();
    value.successAnimationController?.dispose();
    value.errorAnimationController?.dispose();
    value.clearAnimationController?.dispose();
    value.eraseAnimationController?.dispose();
    super.dispose();
  }
}
