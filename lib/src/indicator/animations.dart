// To add a new animation, follow one of the instructions below:
//
// In case you want to add a new animation with already existing type:
// 1) Add a new enum value (yours animation name) to corresponding enum
//    implementing PinAnimationImplementation.
// 2) Create a new class that extends PinIndicatorAnimation where you configure
//    your new animation.
// 3) Create a new class in lib/src/widgets/animated_pin_indicators/ folder
//    with your animation visual implementation.
// 4) Add newly created class to static parsing method.
// 5) Add your animation to pin_indicator.dart in general switch statement
//    from where it will be displayed when called.
//
// In case you want to add a new type animation:
// 1) Add your new type in PinAnimationTypes enum.
// 2) Add a new enum class which implements PinAnimationImplementation.
// 3) Add a newly added type in static parsing method fromImpl.
// 4) Add a new method to PinIndicatorAnimationController that will be called
//    when you want to display your new animation.
// 5) (Optional) Add a getter to check if animation with your type is playing
// to PinIndicatorAnimationController (isAnimating<YourNewTypeName>)
// 6) Go through all steps from the instruction above.
//

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
