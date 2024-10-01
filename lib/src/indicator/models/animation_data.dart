import 'package:pin_ui/src/indicator/models/implementations.dart';

// ignore_for_file: public_member_api_docs

enum PinAnimationTypes { input, loading, success, error, clear, erase, idle }

/// {@template pin_ui.PinIndicatorAnimationData}
/// Pin indicator animation data. This contains core configuration for animation.
/// {@endtemplate}
sealed class PinIndicatorAnimationData {
  /// {@macro pin_ui.PinIndicatorAnimationData}
  const PinIndicatorAnimationData({
    required this.type,
    required this.duration,
    required this.isInterruptible,
    required this.canInterrupt,
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

  /// Static method to create an instance of [PinIndicatorAnimationData] from
  /// provided animation implementation.
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
          PinLoadingAnimation.travel =>
            const PinIndicatorLoadingTravelAnimationData(),
          PinLoadingAnimation.waveInflate =>
            const PinIndicatorLoadingWaveInflateAnimationData(),
          PinLoadingAnimation.waveDeflate =>
            const PinIndicatorLoadingWaveDeflateAnimationData(),
          PinLoadingAnimation.collapse =>
            const PinIndicatorLoadingCollapseAnimationData(),
        },
      PinSuccessAnimation success => switch (success) {
          PinSuccessAnimation.collapse =>
            const PinIndicatorSuccessCollapseAnimationData(),
          PinSuccessAnimation.fill =>
            const PinIndicatorSuccessFillAnimationData(),
          PinSuccessAnimation.fillLast =>
            const PinIndicatorSuccessFillLastAnimationData(),
          PinSuccessAnimation.kick =>
            const PinIndicatorSuccessKickAnimationData(),
        },
      PinErrorAnimation error => switch (error) {
          PinErrorAnimation.shake =>
            const PinIndicatorErrorShakeAnimationData(),
          PinErrorAnimation.blink =>
            const PinIndicatorErrorBlinkAnimationData(),
          PinErrorAnimation.jiggle =>
            const PinIndicatorErrorJiggleAnimationData(),
          PinErrorAnimation.brownian =>
            const PinIndicatorErrorBrownianAnimationData(),
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
          PinIdleAnimation.flash => const PinIndicatorIdleFlashAnimationData(),
        },
    };
  }

  @override
  String toString() => 'PinIndicatorAnimation('
      'type: $type, '
      'duration: $duration, '
      'isInterruptible: $isInterruptible, '
      'canInterrupt: $canInterrupt'
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

class PinIndicatorLoadingWaveInflateAnimationData
    extends PinIndicatorAnimationData {
  const PinIndicatorLoadingWaveInflateAnimationData()
      : super(
          type: PinAnimationTypes.loading,
          duration: const Duration(milliseconds: 1200),
          isInterruptible: false,
          canInterrupt: false,
        );
}

class PinIndicatorLoadingWaveDeflateAnimationData
    extends PinIndicatorAnimationData {
  const PinIndicatorLoadingWaveDeflateAnimationData()
      : super(
          type: PinAnimationTypes.loading,
          duration: const Duration(milliseconds: 1200),
          isInterruptible: false,
          canInterrupt: false,
        );
}

class PinIndicatorLoadingTravelAnimationData extends PinIndicatorAnimationData {
  const PinIndicatorLoadingTravelAnimationData()
      : super(
          type: PinAnimationTypes.loading,
          duration: const Duration(milliseconds: 1600),
          isInterruptible: false,
          canInterrupt: false,
        );
}

class PinIndicatorLoadingCollapseAnimationData
    extends PinIndicatorAnimationData {
  const PinIndicatorLoadingCollapseAnimationData()
      : super(
          type: PinAnimationTypes.loading,
          duration: const Duration(milliseconds: 320),
          // duration: const Duration(milliseconds: 6000),
          isInterruptible: false,
          canInterrupt: false,
        );
}

class PinIndicatorSuccessCollapseAnimationData
    extends PinIndicatorAnimationData {
  const PinIndicatorSuccessCollapseAnimationData()
      : super(
          type: PinAnimationTypes.success,
          duration: const Duration(milliseconds: 920),
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

class PinIndicatorSuccessFillLastAnimationData
    extends PinIndicatorAnimationData {
  const PinIndicatorSuccessFillLastAnimationData()
      : super(
          type: PinAnimationTypes.success,
          duration: const Duration(milliseconds: 1200),
          isInterruptible: false,
          canInterrupt: false,
        );
}

class PinIndicatorSuccessKickAnimationData extends PinIndicatorAnimationData {
  const PinIndicatorSuccessKickAnimationData()
      : super(
          type: PinAnimationTypes.success,
          duration: const Duration(milliseconds: 1500),
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

class PinIndicatorErrorJiggleAnimationData extends PinIndicatorAnimationData {
  const PinIndicatorErrorJiggleAnimationData()
      : super(
          type: PinAnimationTypes.error,
          duration: const Duration(milliseconds: 960),
          isInterruptible: true,
          canInterrupt: false,
        );
}

class PinIndicatorErrorBrownianAnimationData extends PinIndicatorAnimationData {
  const PinIndicatorErrorBrownianAnimationData()
      : super(
          type: PinAnimationTypes.error,
          duration: const Duration(milliseconds: 540),
          isInterruptible: true,
          canInterrupt: false,
        );
}

class PinIndicatorErrorBlinkAnimationData extends PinIndicatorAnimationData {
  const PinIndicatorErrorBlinkAnimationData()
      : super(
          type: PinAnimationTypes.error,
          duration: const Duration(milliseconds: 1000),
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

class PinIndicatorIdleFlashAnimationData extends PinIndicatorAnimationData {
  const PinIndicatorIdleFlashAnimationData()
      : super(
          type: PinAnimationTypes.idle,
          duration: const Duration(milliseconds: 3000),
          isInterruptible: true,
          canInterrupt: false,
        );
}
