import 'package:flutter/animation.dart';
import 'package:pin_ui/pin_ui.dart';

class PinAnimationControllerProvider {
  static AnimationController getControllerFor(
    dynamic animation, {
    required TickerProvider vsync,
  }) {
    return switch (animation) {
      PinInputAnimation inputAnimation => switch (inputAnimation) {
          PinInputAnimation.inflate => AnimationController(
              vsync: vsync,
              duration: const Duration(milliseconds: 240),
            ),
        },
      PinLoadingAnimation loadingAnimation => switch (loadingAnimation) {
          PinLoadingAnimation.jump => throw UnimplementedError(),
        },
      PinSuccessAnimation successAnimation => switch (successAnimation) {
          PinSuccessAnimation.collapse => throw UnimplementedError(),
        },
      PinErrorAnimation errorAnimation => switch (errorAnimation) {
          PinErrorAnimation.shake => throw UnimplementedError(),
        },
      PinClearAnimation clearAnimation => switch (clearAnimation) {
          PinClearAnimation.drop => throw UnimplementedError(),
          PinClearAnimation.deflate => throw UnimplementedError(),
        },
      PinEraseAnimation eraseAnimation => switch (eraseAnimation) {
          PinEraseAnimation.deflate => throw UnimplementedError(),
        },
      _ => throw Exception('Unknown animation type'),
    };
  }

  static Curve getCurveFor(dynamic animation) {
    return switch (animation) {
      PinInputAnimation inputAnimation => switch (inputAnimation) {
          PinInputAnimation.inflate => Curves.linear,
        },
      PinLoadingAnimation loadingAnimation => switch (loadingAnimation) {
          PinLoadingAnimation.jump => throw UnimplementedError(),
        },
      PinSuccessAnimation successAnimation => switch (successAnimation) {
          PinSuccessAnimation.collapse => throw UnimplementedError(),
        },
      PinErrorAnimation errorAnimation => switch (errorAnimation) {
          PinErrorAnimation.shake => throw UnimplementedError(),
        },
      PinClearAnimation clearAnimation => switch (clearAnimation) {
          PinClearAnimation.drop => throw UnimplementedError(),
          PinClearAnimation.deflate => throw UnimplementedError(),
        },
      PinEraseAnimation eraseAnimation => switch (eraseAnimation) {
          PinEraseAnimation.deflate => throw UnimplementedError(),
        },
      _ => throw Exception('Unknown animation type'),
    };
  }
}
