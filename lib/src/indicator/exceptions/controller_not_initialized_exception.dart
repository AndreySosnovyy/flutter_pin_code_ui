/// Exceptions thrown by PinIndicatorController when vibration is not initialized
/// yet, but animation with vibration is called.
class PinIndicatorAnimationControllerNotInitializedException
    implements Exception {
  @override
  String toString() {
    return 'You must call PinIndicatorController\'s initialize() method before'
        'calling animations with vibration.';
  }
}
