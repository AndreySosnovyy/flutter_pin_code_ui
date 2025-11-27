import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pin_ui/src/indicator/exceptions/controller_not_initialized_exception.dart';
import 'package:pin_ui/src/indicator/models/animation.dart';
import 'package:pin_ui/src/indicator/models/animation_data.dart';
import 'package:pin_ui/src/indicator/models/implementations.dart';
import 'package:pin_ui/src/indicator/utils/identifier_util.dart';
import 'package:vibration/vibration.dart';

/// {@template pin_ui.PinIndicatorAnimationController}
/// Controller for managing animations for PinIndicator.
///
/// It handles the queue of animations, so you just have to call desired
/// animations and react to them in your UI using getters from this controller.
///
/// You can also listen to this in case you want to update your UI when
/// animations starts or ends.
/// {@endtemplate}
class PinIndicatorAnimationController
    extends ValueNotifier<PinIndicatorAnimation?> {
  /// {@macro pin_ui.PinIndicatorAnimationController}
  PinIndicatorAnimationController() : super(null);

  /// Returns true if there is an animation in progress.
  bool get isAnimating => value != null;

  /// Returns true if the current animation can not be interrupted.
  /// You can check which animations is interruptible in
  /// lib/src/indicator/models/animation_data.dart
  bool get isAnimatingNonInterruptible =>
      !(value?.data.isInterruptible ?? true);

  /// Returns true if there are animation in progress and it has input type.
  bool get isAnimatingInput => value?.data.type == PinAnimationTypes.input;

  /// Returns true if there are animation in progress and it has loading type.
  bool get isAnimatingLoading => value?.data.type == PinAnimationTypes.loading;

  /// Returns true if there are animation in progress and it has success type.
  bool get isAnimatingSuccess => value?.data.type == PinAnimationTypes.success;

  /// Returns true if there are animation in progress and it has error type.
  bool get isAnimatingError => value?.data.type == PinAnimationTypes.error;

  /// Returns true if there are animation in progress and it has clear type.
  bool get isAnimatingClear => value?.data.type == PinAnimationTypes.clear;

  /// Returns true if there are animation in progress and it has erase type.
  bool get isAnimatingErase => value?.data.type == PinAnimationTypes.erase;

  /// Returns true if there are animation in progress and it has idle type.
  bool get isAnimatingIdle => value?.data.type == PinAnimationTypes.idle;

  /// Whether the device meets vibration requirements.
  /// Vibration requires vibrator and custom vibration support.
  /// So older devices will not vibrate even if it is enabled when calling animation.
  ///
  /// In order to get this value you must call initializeVibration().
  /// Otherwise it will throw LateInitializationError.
  late final bool canVibrate;

  final _animationsQueue = Queue<PinIndicatorAnimation>();

  Timer? _animationTimer;

  final _vibrationInitCompleter = Completer();

  /// Controller initialize method for vibration feature.
  /// You must call in case you want to use vibration in your animations.
  /// Otherwise it will throw an exception.
  ///
  /// If you won't use vibration, you can use controller without calling
  /// this method.
  ///
  /// This method can be safely called multiple times - subsequent calls
  /// will be ignored if already initialized.
  Future<void> initializeVibration() async {
    if (_vibrationInitCompleter.isCompleted) return;
    canVibrate = (await Vibration.hasVibrator() ?? false) &&
        (await Vibration.hasCustomVibrationsSupport() ?? false) &&
        (await Vibration.hasAmplitudeControl() ?? false);
    _vibrationInitCompleter.complete();
  }

  /// Call this method if you want to stop currently playing animation and
  /// all of planned ones if any.
  /// Method stops even non-interruptible animations from being played.
  void stop({
    /// If set to true, animations queue will be cleared without calling
    /// onInterrupt callbacks if any. Otherwise, they will be called one by one
    /// until all animations cleared.
    bool ignoreOnInterruptCallbacks = false,
  }) {
    if (!ignoreOnInterruptCallbacks) value?.onInterrupt?.call();
    while (_animationsQueue.isNotEmpty) {
      final animation = _animationsQueue.removeFirst();
      if (!ignoreOnInterruptCallbacks) animation.onInterrupt?.call();
    }
    value = null;
    notifyListeners();
    _animationTimer?.cancel();
    _animationTimer = null;
  }

  void _prepareAndStart(
    /// {@template pin_ui.PinXAnimation}
    /// Specific variant of animation. Choose one from corresponding enum.
    /// Otherwise, default one will be used.
    /// {@endtemplate}
    PinAnimationImplementation impl, {
    /// {@template pin_ui.delayBefore}
    /// Duration to put before animation starts.
    /// Can be used to make it look smoother.
    /// {@endtemplate}
    Duration? delayBefore,

    /// {@template pin_ui.delayAfter}
    /// Duration to put after animation ends.
    /// Can be used to make it look smoother.
    /// {@endtemplate}
    Duration? delayAfter,

    /// {@template pin_ui.onComplete}
    /// Callback to be triggered when animation is over successfully.
    /// {@endtemplate}
    VoidCallback? onComplete,

    /// {@template pin_ui.onInterrupt}
    /// Callback to be triggered in case animation is interrupted (stopped)
    /// by other animation or [stop] method.
    /// {@endtemplate}
    VoidCallback? onInterrupt,

    /// {@template pin_ui.animationSpeed}
    /// Multiplier for managing animation speed.
    /// Default to 1.
    /// If less then one it will be slower.
    /// if more then it will be faster.
    /// {@endtemplate}
    double animationSpeed = 1.0,

    /// {@template pin_ui.vibration}
    /// Enables vibration for the animation. You must call [initializeVibration]
    /// first if you want to use vibration in your animations.
    /// {@endtemplate}
    bool vibration = false,
  }) {
    if (vibration && !_vibrationInitCompleter.isCompleted) {
      throw PinIndicatorAnimationControllerNotInitializedException();
    }
    assert(animationSpeed >= 0.1);
    assert(animationSpeed <= 10);
    assert(_animationsQueue.length < 16);

    final data = PinIndicatorAnimationData.fromImpl(impl);

    // Stop current animation if needed
    if (value != null && value!.data.isInterruptible && data.canInterrupt) {
      value!.onInterrupt?.call();
      value = null;
    }

    // Remove all interruptible animations from the queue if any
    while (_animationsQueue.isNotEmpty &&
        _animationsQueue.last.data.isInterruptible &&
        data.canInterrupt) {
      _animationsQueue.removeLast().onInterrupt?.call();
    }

    // Load new animation with delays into the queue.
    // Delay before will be handled as a separate animation.
    // Delay after will be handled as a part of the animation itself.
    if (delayBefore != null) {
      _animationsQueue.add(PinIndicatorAnimation(
        id: IdentifierUtil.getUniqueIdentifier(),
        data: PinIndicatorNoAnimationData(
          duration: delayBefore,
          isInterruptible: data.isInterruptible,
          canInterrupt: data.canInterrupt,
        ),
      ));
    }
    _animationsQueue.add(PinIndicatorAnimation(
      id: IdentifierUtil.getUniqueIdentifier(),
      data: data,
      durationMultiplier: 1 / animationSpeed,
      delayAfter: delayAfter,
      onComplete: onComplete,
      onInterrupt: onInterrupt,
      vibrationEnabled: vibration,
    ));

    // Start animation there is no queue to wait for. Otherwise it will be
    // started by timer after currently playing animation is over.
    _animate();
  }

  void _animate() {
    if (isAnimating) return;
    if (_animationsQueue.isEmpty) return stop();
    value = _animationsQueue.removeFirst();
    notifyListeners();
    _animationTimer = Timer(
      value!.data.duration * value!.durationMultiplier +
          (value!.delayAfter ?? Duration.zero),
      () {
        if (value == null) return;
        value!.onComplete?.call();
        value = null;
        notifyListeners();
        _animate();
      },
    );
  }

  /// Method for calling animation with input type for PinIndicator associated
  /// with this controller. Call this method when user enters pin code symbol.
  void animateInput({
    /// {@macro pin_ui.PinXAnimation}
    PinInputAnimation animation = PinInputAnimation.inflate,

    /// {@macro pin_ui.vibration}
    bool vibration = false,

    /// {@macro pin_ui.onComplete}
    VoidCallback? onComplete,

    /// {@macro pin_ui.onInterrupt}
    VoidCallback? onInterrupt,

    /// {@macro pin_ui.animationSpeed}
    double animationSpeed = 1.0,
  }) {
    _prepareAndStart(
      animation,
      onComplete: onComplete,
      onInterrupt: onInterrupt,
      animationSpeed: animationSpeed,
      vibration: vibration,
    );
  }

  /// Method for calling animation with loading type for PinIndicator associated
  /// with this controller. Call this method when you need to delay UI when
  /// making async operations or to let user know that app is doing something
  /// in this moment.
  void animateLoading({
    /// {@macro pin_ui.PinXAnimation}
    PinLoadingAnimation animation = PinLoadingAnimation.jump,

    /// {@macro pin_ui.vibration}
    bool vibration = false,

    /// {@template pin_ui.repeatCount}
    /// Number of times to repeat the animation.
    /// {@endtemplate}
    int repeatCount = 1,

    /// {@macro pin_ui.delayBefore}
    Duration? delayBeforeAnimation,

    /// {@macro pin_ui.delayAfter}
    Duration? delayAfterAnimation,

    /// {@macro pin_ui.onComplete}
    VoidCallback? onComplete,

    /// {@macro pin_ui.onInterrupt}
    VoidCallback? onInterrupt,

    /// {@macro pin_ui.animationSpeed}
    double animationSpeed = 1.0,
  }) {
    assert(repeatCount > 0 && repeatCount < 10);
    for (int i = 0; i < repeatCount; i++) {
      _prepareAndStart(
        animation,
        delayBefore: delayBeforeAnimation,
        delayAfter: delayAfterAnimation,
        onComplete: i == repeatCount - 1 ? onComplete : null,
        onInterrupt: onInterrupt,
        animationSpeed: animationSpeed,
        vibration: vibration,
      );
    }
  }

  /// Method for calling animation with input type for PinIndicator associated
  /// with this controller. Call this method when user enters correct pin code.
  void animateSuccess({
    /// {@macro pin_ui.PinXAnimation}
    PinSuccessAnimation animation = PinSuccessAnimation.collapse,

    /// {@macro pin_ui.vibration}
    bool vibration = false,

    /// {@macro pin_ui.delayBefore}
    Duration? delayBeforeAnimation,

    /// {@macro pin_ui.delayAfter}
    Duration? delayAfterAnimation,

    /// {@macro pin_ui.onComplete}
    VoidCallback? onComplete,

    /// {@macro pin_ui.onInterrupt}
    VoidCallback? onInterrupt,

    /// {@macro pin_ui.animationSpeed}
    double animationSpeed = 1.0,
  }) {
    _prepareAndStart(
      animation,
      delayBefore: delayBeforeAnimation,
      delayAfter: delayAfterAnimation,
      onComplete: onComplete,
      onInterrupt: onInterrupt,
      animationSpeed: animationSpeed,
      vibration: vibration,
    );
  }

  /// Method for calling animation with input type for PinIndicator associated
  /// with this controller. Call this method when user enters wrong pin code.
  void animateError({
    /// {@macro pin_ui.PinXAnimation}
    PinErrorAnimation animation = PinErrorAnimation.shake,

    /// {@macro pin_ui.vibration}
    bool vibration = false,

    /// {@macro pin_ui.delayBefore}
    Duration? delayBeforeAnimation,

    /// {@macro pin_ui.delayAfter}
    Duration? delayAfterAnimation,

    /// {@macro pin_ui.onComplete}
    VoidCallback? onComplete,

    /// {@macro pin_ui.onInterrupt}
    VoidCallback? onInterrupt,

    /// {@macro pin_ui.animationSpeed}
    double animationSpeed = 1.0,
  }) {
    _prepareAndStart(
      animation,
      delayBefore: delayBeforeAnimation,
      delayAfter: delayAfterAnimation,
      onComplete: onComplete,
      onInterrupt: onInterrupt,
      animationSpeed: animationSpeed,
      vibration: vibration,
    );
  }

  /// Method for calling animation with input type for PinIndicator associated
  /// with this controller. Call this method when user clears entire pin code at
  /// once (if there are such logic) or you want to clear pin when other logic
  /// triggers it (for example, pressing "Forgot PIN code" button).
  void animateClear({
    /// {@macro pin_ui.PinXAnimation}
    PinClearAnimation animation = PinClearAnimation.fade,

    /// {@macro pin_ui.vibration}
    bool vibration = false,

    /// {@macro pin_ui.delayBefore}
    Duration? delayBeforeAnimation,

    /// {@macro pin_ui.delayAfter}
    Duration? delayAfterAnimation,

    /// {@macro pin_ui.onComplete}
    VoidCallback? onComplete,

    /// {@macro pin_ui.onInterrupt}
    VoidCallback? onInterrupt,

    /// {@macro pin_ui.animationSpeed}
    double animationSpeed = 1.0,
  }) {
    _prepareAndStart(
      animation,
      delayBefore: delayBeforeAnimation,
      delayAfter: delayAfterAnimation,
      onComplete: onComplete,
      onInterrupt: onInterrupt,
      animationSpeed: animationSpeed,
      vibration: vibration,
    );
  }

  /// Method for calling animation with input type for PinIndicator associated
  /// with this controller. Call this method when user erases one symbol from pin.
  void animateErase({
    /// {@macro pin_ui.PinXAnimation}
    PinEraseAnimation animation = PinEraseAnimation.deflate,

    /// {@macro pin_ui.vibration}
    bool vibration = false,

    /// {@macro pin_ui.onComplete}
    VoidCallback? onComplete,

    /// {@macro pin_ui.onInterrupt}
    VoidCallback? onInterrupt,

    /// {@macro pin_ui.animationSpeed}
    double animationSpeed = 1.0,
  }) {
    _prepareAndStart(
      animation,
      onComplete: onComplete,
      onInterrupt: onInterrupt,
      animationSpeed: animationSpeed,
      vibration: vibration,
    );
  }

  /// Method for calling animation with input type for PinIndicator associated
  /// with this controller. Call this method when user is inactive for a
  /// long time to let them know that action is required and show that app is
  /// still alive.
  void animateIdle({
    /// {@macro pin_ui.PinXAnimation}
    PinIdleAnimation animation = PinIdleAnimation.wave,

    /// {@macro pin_ui.vibration}
    bool vibration = false,

    /// {@macro pin_ui.repeatCount}
    int repeatCount = 1,

    /// {@macro pin_ui.onComplete}
    VoidCallback? onComplete,

    /// {@macro pin_ui.onInterrupt}
    VoidCallback? onInterrupt,

    /// {@macro pin_ui.animationSpeed}
    double animationSpeed = 1.0,
  }) {
    assert(repeatCount > 0 && repeatCount < 10);
    for (int i = 0; i < repeatCount; i++) {
      _prepareAndStart(
        animation,
        onComplete: i == repeatCount - 1 ? onComplete : null,
        onInterrupt: onInterrupt,
        animationSpeed: animationSpeed,
        vibration: vibration,
      );
    }
  }

  @override
  void dispose() {
    stop();
    _animationTimer?.cancel();
    _animationTimer = null;
    super.dispose();
  }
}
