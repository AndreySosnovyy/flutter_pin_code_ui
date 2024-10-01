import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pin_ui/src/indicator/exceptions/controller_not_initialized_exception.dart';
import 'package:pin_ui/src/indicator/models/animation.dart';
import 'package:pin_ui/src/indicator/models/animation_data.dart';
import 'package:pin_ui/src/indicator/models/implementations.dart';
import 'package:pin_ui/src/indicator/utils/identifier_util.dart';
import 'package:vibration/vibration.dart';

class PinIndicatorAnimationController
    extends ValueNotifier<PinIndicatorAnimation?> {
  PinIndicatorAnimationController() : super(null);

  bool get isAnimating => value != null;

  bool get isAnimatingNonInterruptible =>
      !(value?.data.isInterruptible ?? true);

  bool get isAnimatingInput => value?.data.type == PinAnimationTypes.input;

  bool get isAnimatingLoading => value?.data.type == PinAnimationTypes.loading;

  bool get isAnimatingSuccess => value?.data.type == PinAnimationTypes.success;

  bool get isAnimatingError => value?.data.type == PinAnimationTypes.error;

  bool get isAnimatingClear => value?.data.type == PinAnimationTypes.clear;

  bool get isAnimatingErase => value?.data.type == PinAnimationTypes.erase;

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
  Future<void> initializeVibration() async {
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
    value?.onInterrupt?.call();
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
    PinAnimationImplementation impl, {
    Duration? delayBefore,
    Duration? delayAfter,
    VoidCallback? onComplete,
    VoidCallback? onInterrupt,
    double animationSpeed = 1.0,
    bool vibration = false,
  }) {
    if (vibration && !_vibrationInitCompleter.isCompleted) {
      throw PinIndicatorAnimationControllerNotInitializedException();
    }
    assert(animationSpeed >= 0.1);
    assert(animationSpeed <= 10);
    assert(_animationsQueue.length < 16);
    final data = PinIndicatorAnimationData.fromImpl(impl);

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
        value!.onComplete?.call();
        value = null;
        notifyListeners();
        _animate();
      },
    );
  }

  void animateInput({
    PinInputAnimation animation = PinInputAnimation.inflate,
    bool vibration = false,
    VoidCallback? onComplete,
    VoidCallback? onInterrupt,
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

  void animateLoading({
    PinLoadingAnimation animation = PinLoadingAnimation.jump,
    bool vibration = false,
    int repeatCount = 1,
    Duration? delayBeforeAnimation,
    Duration? delayAfterAnimation,
    VoidCallback? onComplete,
    VoidCallback? onInterrupt,
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

  void animateSuccess({
    PinSuccessAnimation animation = PinSuccessAnimation.collapse,
    bool vibration = false,
    Duration? delayBeforeAnimation,
    Duration? delayAfterAnimation,
    VoidCallback? onComplete,
    VoidCallback? onInterrupt,
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

  void animateError({
    PinErrorAnimation animation = PinErrorAnimation.shake,
    bool vibration = false,
    Duration? delayBeforeAnimation,
    Duration? delayAfterAnimation,
    VoidCallback? onComplete,
    VoidCallback? onInterrupt,
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

  void animateClear({
    PinClearAnimation animation = PinClearAnimation.drop,
    bool vibration = false,
    Duration? delayBeforeAnimation,
    Duration? delayAfterAnimation,
    VoidCallback? onComplete,
    VoidCallback? onInterrupt,
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

  void animateErase({
    PinEraseAnimation animation = PinEraseAnimation.deflate,
    bool vibration = false,
    VoidCallback? onComplete,
    VoidCallback? onInterrupt,
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

  void animateIdle({
    PinIdleAnimation animation = PinIdleAnimation.wave,
    bool vibration = false,
    int repeatCount = 1,
    VoidCallback? onComplete,
    VoidCallback? onInterrupt,
    double animationSpeed = 1.0,
  }) {
    assert(repeatCount > 0 && repeatCount < 10);
    for (int i = 0; i < repeatCount; i++) {
      _prepareAndStart(
        animation,
        onComplete: onComplete,
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
