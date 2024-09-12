part of 'widgets/pin_indicator.dart';

class PinIndicatorAnimationController
    extends ValueNotifier<PinIndicatorAnimationControllerValue> {
  PinIndicatorAnimationController({
    required TickerProvider vsync,
    int currentLength = 0,
    int maxLength = 4,
  }) : super(PinIndicatorAnimationControllerValue(
          currentLength: currentLength,
          maxLength: maxLength,
          vsync: vsync,
        ));

  late final PinIndicatorAnimationsConfig _config;

  final _configInitializationCompleter = Completer<void>();

  void _setConfig(PinIndicatorAnimationsConfig config) {
    _config = config;
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
    assert(currentLength >= 0 && currentLength <= value.maxLength);
    value = value.copyWith(currentLength: currentLength);
    switch (_config.inputAnimation!) {
      case PinInputAnimation.inflate:
        value.inputAnimationController.duration =
            const Duration(milliseconds: 100);
        value.inputAnimationController.reset();
        await value.inputAnimationController.animateTo(1.3, curve: Curves.ease);
        await value.inputAnimationController
            .animateTo(1.0, curve: Curves.easeIn);
    }
  }

  bool get isAnimatingInput => value.inputAnimationController.isAnimating;

  Future<void> animateLoading({
    bool vibration = false,
  }) async {
    _verifyInitialized();
    throw UnimplementedError();
  }

  bool get isAnimatingLoading => value.loadingAnimationController.isAnimating;

  Future<void> animateSuccess({
    bool vibration = false,
  }) async {
    _verifyInitialized();
    throw UnimplementedError();
  }

  bool get isAnimatingSuccess => value.successAnimationController.isAnimating;

  Future<void> animateError({
    bool vibration = false,
  }) async {
    _verifyInitialized();
    throw UnimplementedError();
  }

  bool get isAnimatingError => value.errorAnimationController.isAnimating;

  Future<void> animateClear({
    bool vibration = false,
  }) async {
    _verifyInitialized();
    throw UnimplementedError();
  }

  bool get isAnimatingClear => value.clearAnimationController.isAnimating;

  Future<void> animateErase({required int currentLength}) async {
    _verifyInitialized();
    assert(currentLength >= 0 && currentLength <= value.maxLength);
    value = value.copyWith(currentLength: currentLength);
    switch (_config.eraseAnimation!) {
      case PinEraseAnimation.deflate:
        value.eraseAnimationController.duration =
            const Duration(milliseconds: 80);
        value.eraseAnimationController.reset();
        value.eraseAnimationController.value = 1.0;
        await value.eraseAnimationController
            .animateBack(0.9, curve: Curves.easeOutQuint);
        await value.eraseAnimationController
            .animateTo(1.0, curve: Curves.linear);
    }
  }

  bool get isAnimatingErase => value.eraseAnimationController.isAnimating;

  @override
  void dispose() {
    value.inputAnimationController.dispose();
    value.loadingAnimationController.dispose();
    value.successAnimationController.dispose();
    value.errorAnimationController.dispose();
    value.clearAnimationController.dispose();
    value.eraseAnimationController.dispose();
    super.dispose();
  }
}
