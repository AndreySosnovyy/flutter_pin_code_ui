class PinIndicatorAnimationControllerNotInitializedException implements Exception {
  @override
  String toString() {
    return 'You must call PinIndicatorController.initialize() before calling animations';
  }
}
