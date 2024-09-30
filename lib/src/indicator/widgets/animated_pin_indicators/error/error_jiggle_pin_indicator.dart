import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';

class ErrorJigglePinIndicator extends StatefulWidget {
  const ErrorJigglePinIndicator({
    required this.builder,
    required this.length,
    required this.duration,
    required this.spacing,
    required this.vibration,
    super.key,
  });

  final PinIndicatorItemBuilder builder;
  final int length;
  final Duration duration;
  final double spacing;
  final bool vibration;

  @override
  State<ErrorJigglePinIndicator> createState() =>
      _ErrorJigglePinIndicatorState();
}

class _ErrorJigglePinIndicatorState extends State<ErrorJigglePinIndicator>
    with TickerProviderStateMixin {
  late final scaleAnimation = AnimationController(
    vsync: this,
    lowerBound: 1,
    upperBound: 1.4,
  );
  late final angleAnimation = AnimationController(
    vsync: this,
    value: 0.0,
    lowerBound: -30.0,
    upperBound: 30.0,
  );

  @override
  void initState() {
    final firstStageDuration = widget.duration * 0.36;
    final secondStageDuration = widget.duration * 0.36;
    final delayDuration =
        widget.duration - firstStageDuration - secondStageDuration;
    const jiggleCount = 3;
    final jiggleDuration = widget.duration ~/ ((jiggleCount + 1) * 2);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      scaleAnimation
          .animateTo(
            scaleAnimation.upperBound,
            duration: firstStageDuration,
            curve: Curves.easeIn,
          )
          .then((_) => Future.delayed(delayDuration))
          .then((_) => scaleAnimation.animateTo(
                scaleAnimation.lowerBound,
                duration: secondStageDuration,
                curve: Curves.easeIn,
              ));
      await angleAnimation.animateTo(
        angleAnimation.lowerBound,
        duration: jiggleDuration ~/ 2,
      );
      if (widget.vibration) HapticFeedback.mediumImpact();
      for (int i = 0; i < jiggleCount; i++) {
        await angleAnimation.animateTo(
          angleAnimation.upperBound,
          duration: jiggleDuration,
        );
        if (widget.vibration) HapticFeedback.mediumImpact();
        await angleAnimation.animateTo(
          angleAnimation.lowerBound,
          duration: jiggleDuration,
        );
        if (widget.vibration) HapticFeedback.mediumImpact();
      }
      await angleAnimation.animateTo(
        0.0,
        duration: jiggleDuration ~/ 2,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NoAnimationPinIndicator(
      spacing: widget.spacing,
      length: widget.length,
      builder: (i) {
        return AnimatedBuilder(
          animation: angleAnimation,
          builder: (context, _) {
            return AnimatedBuilder(
              animation: scaleAnimation,
              builder: (context, _) {
                return Transform.scale(
                  scale: scaleAnimation.value,
                  child: Transform.rotate(
                    angle: angleAnimation.value * math.pi / 180,
                    child: widget.builder(i),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    scaleAnimation.dispose();
    angleAnimation.dispose();
    super.dispose();
  }
}
