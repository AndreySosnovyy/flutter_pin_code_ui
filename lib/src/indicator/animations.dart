enum PinAnimationTypes { input, loading, success, error, clear, erase, idle }

sealed class PinAnimationImplementation {}

enum PinInputAnimation implements PinAnimationImplementation { inflate }

enum PinLoadingAnimation implements PinAnimationImplementation { jump }

enum PinSuccessAnimation implements PinAnimationImplementation { collapse }

enum PinErrorAnimation implements PinAnimationImplementation { shake }

enum PinClearAnimation implements PinAnimationImplementation { drop, fade }

enum PinEraseAnimation implements PinAnimationImplementation { deflate }

enum PinIdleAnimation implements PinAnimationImplementation { wave }

sealed class PinIndicatorAnimation {
  const PinIndicatorAnimation({
    required this.type,
    required this.duration,
    required this.isInterruptible,
  });

  /// Type of the animation.
  final PinAnimationTypes type;

  /// Duration of whole animation. Including forward and reverse time or
  /// many animation controllers completion.
  final Duration duration;

  /// Whether the animation can be interrupted by the same animation type.
  final bool isInterruptible;

  static PinIndicatorAnimation? fromImpl(PinAnimationImplementation impl) {
    return switch (impl) {
      PinInputAnimation input => switch (input) {
          PinInputAnimation.inflate =>
            const PinIndicatorInputInflateAnimation(),
        },
      PinLoadingAnimation loading => switch (loading) {
          PinLoadingAnimation.jump => const PinIndicatorLoadingJumpAnimation(),
        },
      PinSuccessAnimation success => switch (success) {
          PinSuccessAnimation.collapse =>
            const PinIndicatorSuccessCollapseAnimation(),
        },
      PinErrorAnimation error => switch (error) {
          PinErrorAnimation.shake => const PinIndicatorErrorShakeAnimation(),
        },
      PinClearAnimation clear => switch (clear) {
          PinClearAnimation.drop => const PinIndicatorClearDropAnimation(),
          PinClearAnimation.fade => const PinIndicatorClearFadeAnimation(),
        },
      PinEraseAnimation erase => switch (erase) {
          PinEraseAnimation.deflate =>
            const PinIndicatorEraseDeflateAnimation(),
        },
      PinIdleAnimation idle => switch (idle) {
          PinIdleAnimation.wave => const PinIndicatorIdleWaveAnimation(),
        },
    };
  }
}

class PinIndicatorInputInflateAnimation extends PinIndicatorAnimation {
  const PinIndicatorInputInflateAnimation()
      : super(
          type: PinAnimationTypes.input,
          duration: const Duration(milliseconds: 200),
          isInterruptible: true,
        );
}

class PinIndicatorLoadingJumpAnimation extends PinIndicatorAnimation {
  const PinIndicatorLoadingJumpAnimation()
      : super(
          type: PinAnimationTypes.loading,
          duration: const Duration(milliseconds: 1200),
          isInterruptible: false,
        );
}

class PinIndicatorSuccessCollapseAnimation extends PinIndicatorAnimation {
  const PinIndicatorSuccessCollapseAnimation()
      : super(
          type: PinAnimationTypes.success,
          duration: const Duration(milliseconds: 840),
          // duration: const Duration(milliseconds: 4000),
          isInterruptible: false,
        );
}

class PinIndicatorErrorShakeAnimation extends PinIndicatorAnimation {
  const PinIndicatorErrorShakeAnimation()
      : super(
          type: PinAnimationTypes.error,
          duration: const Duration(milliseconds: 360),
          isInterruptible: true,
        );
}

class PinIndicatorClearDropAnimation extends PinIndicatorAnimation {
  const PinIndicatorClearDropAnimation()
      : super(
          type: PinAnimationTypes.clear,
          duration: const Duration(milliseconds: 540),
          isInterruptible: true,
        );
}

class PinIndicatorClearFadeAnimation extends PinIndicatorAnimation {
  const PinIndicatorClearFadeAnimation()
      : super(
          type: PinAnimationTypes.clear,
          duration: const Duration(milliseconds: 420),
          isInterruptible: true,
        );
}

class PinIndicatorEraseDeflateAnimation extends PinIndicatorAnimation {
  const PinIndicatorEraseDeflateAnimation()
      : super(
          type: PinAnimationTypes.erase,
          duration: const Duration(milliseconds: 160),
          isInterruptible: true,
        );
}

class PinIndicatorIdleWaveAnimation extends PinIndicatorAnimation {
  const PinIndicatorIdleWaveAnimation()
      : super(
          type: PinAnimationTypes.idle,
          duration: const Duration(milliseconds: 1200),
          isInterruptible: true,
        );
}
