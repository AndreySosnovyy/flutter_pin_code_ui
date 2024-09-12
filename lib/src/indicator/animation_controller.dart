part of 'widgets/pin_indicator.dart';

class PinIndicatorAnimationController
    extends ValueNotifier<PinIndicatorAnimationControllerValue> {
  PinIndicatorAnimationController({
    required this.vsync,
    int currentLength = 0,
    int maxLength = 4,
  }) : super(PinIndicatorAnimationControllerValue(
          currentLength: currentLength,
          maxLength: maxLength,
        ));

  final TickerProvider vsync;
  late final PinIndicatorAnimationsConfig _config;

  final _configInitializationCompleter = Completer<void>();

  void _setConfig(PinIndicatorAnimationsConfig config) {
    _config = config;
    _configInitializationCompleter.complete();
    value = value.copyWith(
      inputAnimationController: PinAnimationControllerProvider.getControllerFor(
        _config.inputAnimation,
        vsync: vsync,
      ),
      loadingAnimationController:
          PinAnimationControllerProvider.getControllerFor(
        _config.loadingAnimation,
        vsync: vsync,
      ),
      successAnimationController:
          PinAnimationControllerProvider.getControllerFor(
        _config.successAnimation,
        vsync: vsync,
      ),
      errorAnimationController: PinAnimationControllerProvider.getControllerFor(
        _config.errorAnimation,
        vsync: vsync,
      ),
      clearAnimationController: PinAnimationControllerProvider.getControllerFor(
        _config.clearAnimation,
        vsync: vsync,
      ),
      eraseAnimationController: PinAnimationControllerProvider.getControllerFor(
        _config.eraseAnimation,
        vsync: vsync,
      ),
    );
  }

  void _verifyInitialized() {
    assert(_configInitializationCompleter.isCompleted,
        'Controller has no listeners. Layout them before calling animate methods.');
  }

  Future<void> animateInput({required int currentLength}) async {
    _verifyInitialized();
    assert(value.inputAnimationController != null);
    assert(currentLength >= 0 && currentLength <= value.maxLength);
    value = value.copyWith(currentLength: currentLength);
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

  bool get isAnimatingInput =>
      value.inputAnimationController?.isAnimating ?? false;

  Future<void> animateLoading() async {
    _verifyInitialized();
    assert(value.loadingAnimationController != null);
    throw UnimplementedError();
  }

  bool get isAnimatingLoading =>
      value.loadingAnimationController?.isAnimating ?? false;

  Future<void> animateSuccess() async {
    _verifyInitialized();
    assert(value.successAnimationController != null);
    throw UnimplementedError();
  }

  bool get isAnimatingSuccess =>
      value.successAnimationController?.isAnimating ?? false;

  Future<void> animateError() async {
    _verifyInitialized();
    assert(value.errorAnimationController != null);
    throw UnimplementedError();
  }

  bool get isAnimatingError =>
      value.errorAnimationController?.isAnimating ?? false;

  Future<void> animateClear() async {
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
    throw UnimplementedError();
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
