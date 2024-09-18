import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pin_ui/src/indicator/models/animation.dart';
import 'package:pin_ui/src/indicator/models/animation_data.dart';
import 'package:pin_ui/src/indicator/models/implementations.dart';
import 'package:pin_ui/src/indicator/utils/identifier_util.dart';

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

  final _animationsQueue = Queue<PinIndicatorAnimation>();

  Timer? _animationTimer;

  /// Call this method if you want to stop currently playing animation and
  /// all of planned ones if any.
  /// Method stops even non-interruptible animations from being played.
  void stop() {
    value?.onInterrupt?.call();
    while (_animationsQueue.isNotEmpty) {
      _animationsQueue.removeFirst().onInterrupt?.call();
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
  }) {
    final data = PinIndicatorAnimationData.fromImpl(impl);

    // Remove all interruptible animations from the queue if any
    while (_animationsQueue.isNotEmpty &&
        _animationsQueue.last.data.isInterruptible &&
        data.canInterrupt) {
      _animationsQueue.removeLast();
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
      delayAfter: delayAfter,
      onComplete: onComplete,
      onInterrupt: onInterrupt,
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
      value!.data.duration + (value!.delayAfter ?? Duration.zero),
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
  }) {
    _prepareAndStart(
      animation,
      onComplete: onComplete,
      onInterrupt: onInterrupt,
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
  }) {
    for (int i = 0; i < repeatCount; i++) {
      _prepareAndStart(
        animation,
        delayBefore: delayBeforeAnimation,
        delayAfter: delayAfterAnimation,
        onComplete: i == repeatCount - 1 ? onComplete : null,
        onInterrupt: onInterrupt,
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
  }) {
    _prepareAndStart(
      animation,
      delayBefore: delayBeforeAnimation,
      delayAfter: delayAfterAnimation,
      onComplete: onComplete,
      onInterrupt: onInterrupt,
    );
  }

  void animateError({
    PinErrorAnimation animation = PinErrorAnimation.shake,
    bool vibration = false,
    Duration? delayBeforeAnimation,
    Duration? delayAfterAnimation,
    VoidCallback? onComplete,
    VoidCallback? onInterrupt,
  }) {
    _prepareAndStart(
      animation,
      delayBefore: delayBeforeAnimation,
      delayAfter: delayAfterAnimation,
      onComplete: onComplete,
      onInterrupt: onInterrupt,
    );
  }

  void animateClear({
    PinClearAnimation animation = PinClearAnimation.drop,
    bool vibration = false,
    Duration? delayBeforeAnimation,
    Duration? delayAfterAnimation,
    VoidCallback? onComplete,
    VoidCallback? onInterrupt,
  }) {
    _prepareAndStart(
      animation,
      delayBefore: delayBeforeAnimation,
      delayAfter: delayAfterAnimation,
      onComplete: onComplete,
      onInterrupt: onInterrupt,
    );
  }

  void animateErase({
    PinEraseAnimation animation = PinEraseAnimation.deflate,
    bool vibration = false,
    VoidCallback? onComplete,
    VoidCallback? onInterrupt,
  }) {
    _prepareAndStart(
      animation,
      onComplete: onComplete,
      onInterrupt: onInterrupt,
    );
  }

  void animateIdle({
    PinIdleAnimation animation = PinIdleAnimation.wave,
    bool vibration = false,
    VoidCallback? onComplete,
    VoidCallback? onInterrupt,
  }) {
    _prepareAndStart(
      animation,
      onComplete: onComplete,
      onInterrupt: onInterrupt,
    );
  }

  @override
  void dispose() {
    stop();
    _animationTimer?.cancel();
    _animationTimer = null;
    super.dispose();
  }
}
