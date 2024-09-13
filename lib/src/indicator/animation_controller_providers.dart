import 'package:flutter/animation.dart';
import 'package:pin_ui/pin_ui.dart';

class PinAnimationControllerProvider {
  final TickerProvider vsync;

  PinAnimationControllerProvider({required this.vsync});

  AnimationController? getControllerFor(dynamic animation) {
    if (animation == null) return null;
    return switch (animation) {
      PinInputAnimation inputAnimation => switch (inputAnimation) {
          PinInputAnimation.inflate => AnimationController(
              vsync: vsync,
              duration: const Duration(milliseconds: 100),
              lowerBound: 1.0,
              upperBound: 1.3,
            ),
        },
      PinLoadingAnimation loadingAnimation => switch (loadingAnimation) {
          PinLoadingAnimation.jump => AnimationController(vsync: vsync),
        },
      PinSuccessAnimation successAnimation => switch (successAnimation) {
          PinSuccessAnimation.collapse => AnimationController(vsync: vsync),
        },
      PinErrorAnimation errorAnimation => switch (errorAnimation) {
          PinErrorAnimation.shake => AnimationController(vsync: vsync),
        },
      PinClearAnimation clearAnimation => switch (clearAnimation) {
          PinClearAnimation.drop => AnimationController(vsync: vsync),
          PinClearAnimation.deflate => AnimationController(vsync: vsync),
        },
      PinEraseAnimation eraseAnimation => switch (eraseAnimation) {
          PinEraseAnimation.deflate => AnimationController(
              vsync: vsync,
              duration: const Duration(milliseconds: 80),
              value: 1.0,
              lowerBound: 0.9,
              upperBound: 1.0,
            ),
        },
      _ => throw Exception('Unknown animation type'),
    };
  }
}
