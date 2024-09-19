import 'package:pin_ui/src/indicator/models/implementations.dart';

sealed class PinIndicatorAnimationData {
  const PinIndicatorAnimationData({
    required this.type,
    required this.duration,
    required this.isInterruptible,
    required this.canInterrupt,
    this.vibrationPattern,
  });

  /// Type of the animation.
  final PinAnimationTypes? type;

  /// Duration of whole animation. Including forward and reverse time or
  /// many animation controllers completion.
  final Duration duration;

  /// Whether the animation can be interrupted by the same animation type.
  final bool isInterruptible;

  /// Whether the animation can interrupt other animation marked with isInterruptible
  final bool canInterrupt;

  /// Vibration pattern.
  final List<int>? vibrationPattern;

  static PinIndicatorAnimationData fromImpl(PinAnimationImplementation impl) {
    return switch (impl) {
      PinInputAnimation input => switch (input) {
          PinInputAnimation.inflate =>
            const PinIndicatorInputInflateAnimationData(),
          PinInputAnimation.fall => const PinIndicatorInputFallAnimationData(),
          PinInputAnimation.fade => const PinIndicatorInputFadeAnimationData(),
        },
      PinLoadingAnimation loading => switch (loading) {
          PinLoadingAnimation.jump =>
            const PinIndicatorLoadingJumpAnimationData(),
        },
      PinSuccessAnimation success => switch (success) {
          PinSuccessAnimation.collapse =>
            const PinIndicatorSuccessCollapseAnimationData(),
          PinSuccessAnimation.fill =>
            const PinIndicatorSuccessFillAnimationData(),
        },
      PinErrorAnimation error => switch (error) {
          PinErrorAnimation.shake =>
            const PinIndicatorErrorShakeAnimationData(),
        },
      PinClearAnimation clear => switch (clear) {
          PinClearAnimation.drop => const PinIndicatorClearDropAnimationData(),
          PinClearAnimation.fade => const PinIndicatorClearFadeAnimationData(),
        },
      PinEraseAnimation erase => switch (erase) {
          PinEraseAnimation.deflate =>
            const PinIndicatorEraseDeflateAnimationData(),
          PinEraseAnimation.takeOff =>
            const PinIndicatorEraseTakeOffAnimationData(),
          PinEraseAnimation.fade => const PinIndicatorEraseFadeAnimationData(),
        },
      PinIdleAnimation idle => switch (idle) {
          PinIdleAnimation.wave => const PinIndicatorIdleWaveAnimationData(),
          PinIdleAnimation.pulse => const PinIndicatorIdlePulseAnimationData(),
        },
    };
  }

  @override
  String toString() => 'PinIndicatorAnimation('
      'type: $type, '
      'duration: $duration, '
      'isInterruptible: $isInterruptible, '
      'vibrationPattern: $vibrationPattern'
      ')';
}

/// Represents delays before and after animations in queue
class PinIndicatorNoAnimationData extends PinIndicatorAnimationData {
  const PinIndicatorNoAnimationData({
    required super.duration,
    required super.isInterruptible,
    required super.canInterrupt,
  }) : super(type: null);
}

class PinIndicatorInputInflateAnimationData extends PinIndicatorAnimationData {
  const PinIndicatorInputInflateAnimationData()
      : super(
          type: PinAnimationTypes.input,
          duration: const Duration(milliseconds: 200),
          isInterruptible: true,
          canInterrupt: true,
        );
}

class PinIndicatorInputFadeAnimationData extends PinIndicatorAnimationData {
  const PinIndicatorInputFadeAnimationData()
      : super(
          type: PinAnimationTypes.input,
          duration: const Duration(milliseconds: 200),
          isInterruptible: true,
          canInterrupt: true,
        );
}

class PinIndicatorInputFallAnimationData extends PinIndicatorAnimationData {
  const PinIndicatorInputFallAnimationData()
      : super(
          type: PinAnimationTypes.input,
          duration: const Duration(milliseconds: 240),
          isInterruptible: true,
          canInterrupt: true,
        );
}

class PinIndicatorLoadingJumpAnimationData extends PinIndicatorAnimationData {
  const PinIndicatorLoadingJumpAnimationData()
      : super(
          type: PinAnimationTypes.loading,
          duration: const Duration(milliseconds: 1200),
          isInterruptible: false,
          canInterrupt: false,
        );
}

class PinIndicatorSuccessCollapseAnimationData
    extends PinIndicatorAnimationData {
  const PinIndicatorSuccessCollapseAnimationData()
      : super(
          type: PinAnimationTypes.success,
          duration: const Duration(milliseconds: 840),
          isInterruptible: false,
          canInterrupt: false,
        );
}

class PinIndicatorSuccessFillAnimationData extends PinIndicatorAnimationData {
  const PinIndicatorSuccessFillAnimationData()
      : super(
          type: PinAnimationTypes.success,
          duration: const Duration(milliseconds: 1200),
          isInterruptible: false,
          canInterrupt: false,
        );
}

class PinIndicatorErrorShakeAnimationData extends PinIndicatorAnimationData {
  const PinIndicatorErrorShakeAnimationData()
      : super(
          type: PinAnimationTypes.error,
          duration: const Duration(milliseconds: 360),
          isInterruptible: true,
          canInterrupt: false,
        );
}

class PinIndicatorClearDropAnimationData extends PinIndicatorAnimationData {
  const PinIndicatorClearDropAnimationData()
      : super(
          type: PinAnimationTypes.clear,
          duration: const Duration(milliseconds: 540),
          isInterruptible: true,
          canInterrupt: false,
        );
}

class PinIndicatorClearFadeAnimationData extends PinIndicatorAnimationData {
  const PinIndicatorClearFadeAnimationData()
      : super(
          type: PinAnimationTypes.clear,
          duration: const Duration(milliseconds: 420),
          isInterruptible: true,
          canInterrupt: false,
        );
}

class PinIndicatorEraseDeflateAnimationData extends PinIndicatorAnimationData {
  const PinIndicatorEraseDeflateAnimationData()
      : super(
          type: PinAnimationTypes.erase,
          duration: const Duration(milliseconds: 160),
          isInterruptible: true,
          canInterrupt: true,
        );
}

class PinIndicatorEraseTakeOffAnimationData extends PinIndicatorAnimationData {
  const PinIndicatorEraseTakeOffAnimationData()
      : super(
          type: PinAnimationTypes.erase,
          duration: const Duration(milliseconds: 180),
          isInterruptible: true,
          canInterrupt: true,
        );
}

class PinIndicatorEraseFadeAnimationData extends PinIndicatorAnimationData {
  const PinIndicatorEraseFadeAnimationData()
      : super(
          type: PinAnimationTypes.erase,
          duration: const Duration(milliseconds: 160),
          isInterruptible: true,
          canInterrupt: true,
        );
}

class PinIndicatorIdleWaveAnimationData extends PinIndicatorAnimationData {
  const PinIndicatorIdleWaveAnimationData()
      : super(
          type: PinAnimationTypes.idle,
          duration: const Duration(milliseconds: 1200),
          isInterruptible: true,
          canInterrupt: false,
        );
}

class PinIndicatorIdlePulseAnimationData extends PinIndicatorAnimationData {
  const PinIndicatorIdlePulseAnimationData()
      : super(
          type: PinAnimationTypes.idle,
          duration: const Duration(milliseconds: 1200),
          isInterruptible: true,
          canInterrupt: false,
        );
}
