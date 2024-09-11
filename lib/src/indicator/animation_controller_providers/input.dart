import 'package:flutter/animation.dart';
import 'package:pin_ui/pin_ui.dart';

class PinInputAnimationControllerProvider {
  static AnimationController getControllerFor(
    PinInputAnimation animation, {
    required TickerProvider vsync,
  }) {
    return switch (animation) {
      PinInputAnimation.inflate => AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 240),
        ),
    };
  }

  static Curve getCurveFor(PinInputAnimation animation) {
    return switch (animation) {
      PinInputAnimation.inflate => Curves.linear,
    };
  }
}
