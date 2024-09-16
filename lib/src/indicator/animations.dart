enum PinAnimationTypes { input, loading, success, error, clear, erase }

enum PinInputAnimation { inflate }

enum PinLoadingAnimation { jump }

enum PinSuccessAnimation { collapse }

enum PinErrorAnimation { shake }

enum PinClearAnimation { drop }

enum PinEraseAnimation { deflate }

// TODO(Sosnovyy): add idle animation
enum PinIdleAnimation { wave, pulse }

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

  static PinIndicatorAnimation? fromImpl(dynamic impl) {
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
        },
      PinEraseAnimation erase => switch (erase) {
          PinEraseAnimation.deflate =>
            const PinIndicatorEraseDeflateAnimation(),
        },
      _ => null,
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
          duration: const Duration(milliseconds: 1000),
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
          duration: const Duration(milliseconds: 1000),
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
