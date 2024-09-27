import 'dart:ui';

import 'package:pin_ui/src/indicator/models/animation_data.dart';

class PinIndicatorAnimation {
  const PinIndicatorAnimation({
    required this.id,
    required this.data,
    this.durationMultiplier = 1.0,
    this.delayAfter,
    this.onComplete,
    this.onInterrupt,
    this.vibrationEnabled = false,
  });

  /// Unique identifier of the animation
  final String id;

  /// Animation general configuration
  final PinIndicatorAnimationData data;

  /// Animation duration multiplier
  final double durationMultiplier;

  /// Delay after the animation ends
  final Duration? delayAfter;

  /// Called when the animation completes
  final VoidCallback? onComplete;

  /// Called when the animation is interrupted by stop method
  final VoidCallback? onInterrupt;

  /// If set to true, vibration is requested but not guaranteed by actual
  /// implementation.
  final bool vibrationEnabled;

  @override
  String toString() => 'PinIndicatorAnimation('
      'id: $id, '
      'data: $data, '
      'durationMultiplier: $durationMultiplier, '
      'delayAfter: $delayAfter, '
      'onComplete: $onComplete, '
      'onInterrupt: $onInterrupt, '
      'vibrationEnabled: $vibrationEnabled'
      ')';
}
