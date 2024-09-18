import 'dart:ui';

import 'package:pin_ui/src/indicator/models/animation_data.dart';

class PinIndicatorAnimation {
  const PinIndicatorAnimation({
    required this.id,
    required this.data,
    this.onComplete,
    this.onInterrupt,
  });

  /// Unique identifier of the animation
  final String id;

  /// Animation general configuration
  final PinIndicatorAnimationData data;

  /// Called when the animation completes
  final VoidCallback? onComplete;

  /// Called when the animation is interrupted by stop method
  final VoidCallback? onInterrupt;

  @override
  String toString() => 'PinIndicatorAnimation('
      'id: $id, '
      'data: $data, '
      'onComplete: $onComplete, '
      'onInterrupt: $onInterrupt'
      ')';
}
