class PinIndicatorAnimationControllerNotInitializedException
    implements Exception {
  @override
  String toString() {
    return 'You must call PinIndicatorController\'s initialize() method before'
        'calling animations with vibration.';
  }
}
