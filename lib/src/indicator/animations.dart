enum PinInputAnimation { inflate }

enum PinLoadingAnimation { jump }

enum PinSuccessAnimation { collapse }

enum PinErrorAnimation { shake }

enum PinClearAnimation { drop }

enum PinEraseAnimation { deflate }

enum PinAnimationTypes { input, loading, success, error, clear, erase }

sealed class PinAnimation {
  const PinAnimation({
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

  static PinAnimation? fromImpl(dynamic impl) {
    return switch (impl) {
      PinInputAnimation input => switch (input) {
          PinInputAnimation.inflate => const PinInputInflateAnimation(),
        },
      PinLoadingAnimation loading => switch (loading) {
          PinLoadingAnimation.jump => const PinLoadingJumpAnimation(),
        },
      PinSuccessAnimation success => switch (success) {
          PinSuccessAnimation.collapse => const PinSuccessCollapseAnimation(),
        },
      PinErrorAnimation error => switch (error) {
          PinErrorAnimation.shake => const PinErrorShakeAnimation(),
        },
      PinClearAnimation clear => switch (clear) {
          PinClearAnimation.drop => const PinClearDropAnimation(),
        },
      PinEraseAnimation erase => switch (erase) {
          PinEraseAnimation.deflate => const PinEraseDeflateAnimation(),
        },
      _ => null,
    };
  }
}

class PinInputInflateAnimation extends PinAnimation {
  const PinInputInflateAnimation()
      : super(
          type: PinAnimationTypes.input,
          duration: const Duration(milliseconds: 200),
          isInterruptible: true,
        );
}

class PinLoadingJumpAnimation extends PinAnimation {
  const PinLoadingJumpAnimation()
      : super(
          type: PinAnimationTypes.loading,
          duration: const Duration(milliseconds: 1000),
          isInterruptible: false,
        );
}

class PinSuccessCollapseAnimation extends PinAnimation {
  const PinSuccessCollapseAnimation()
      : super(
          type: PinAnimationTypes.success,
          duration: const Duration(milliseconds: 1000),
          isInterruptible: false,
        );
}

class PinErrorShakeAnimation extends PinAnimation {
  const PinErrorShakeAnimation()
      : super(
          type: PinAnimationTypes.error,
          duration: const Duration(milliseconds: 1000),
          isInterruptible: true,
        );
}

class PinClearDropAnimation extends PinAnimation {
  const PinClearDropAnimation()
      : super(
          type: PinAnimationTypes.clear,
          duration: const Duration(milliseconds: 1000),
          isInterruptible: true,
        );
}

class PinEraseDeflateAnimation extends PinAnimation {
  const PinEraseDeflateAnimation()
      : super(
          type: PinAnimationTypes.erase,
          duration: const Duration(milliseconds: 160),
          isInterruptible: true,
        );
}
