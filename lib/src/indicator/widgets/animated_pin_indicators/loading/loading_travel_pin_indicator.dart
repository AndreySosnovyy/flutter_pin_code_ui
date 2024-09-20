import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';

class LoadingTravelPinIndicator extends StatefulWidget {
  const LoadingTravelPinIndicator({
    required this.builder,
    required this.length,
    required this.duration,
    required this.spacing,
    required this.childSize,
    super.key,
  });

  final PinIndicatorItemBuilder builder;
  final int length;
  final Duration duration;
  final double spacing;
  final double childSize;

  @override
  State<LoadingTravelPinIndicator> createState() =>
      _LoadingTravelPinIndicatorState();
}

class _LoadingTravelPinIndicatorState extends State<LoadingTravelPinIndicator>
    with TickerProviderStateMixin {
  late final AnimationController xOffsetAnimation;
  late final AnimationController scaleAnimation;
  final initializationCompleter = Completer<void>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final box = context.findRenderObject() as RenderBox;
      final positionX = box.localToGlobal(Offset.zero).dx;
      final indicatorLength = box.size.width;
      final offset = indicatorLength + positionX;
      xOffsetAnimation = AnimationController(
        vsync: this,
        value: 0.0,
        lowerBound: -offset,
        upperBound: offset,
      );
      scaleAnimation = AnimationController(
        vsync: this,
        value: 1.0,
        lowerBound: 0.8,
        upperBound: 1.0,
      );
      setState(() => initializationCompleter.complete());
      final delay = widget.duration * 0.3;
      final firstStageDuration = (widget.duration - delay) ~/ 2;
      final secondStageDuration = widget.duration - delay - firstStageDuration;

      await Future.wait([
        xOffsetAnimation.animateTo(
          xOffsetAnimation.upperBound,
          duration: firstStageDuration,
          curve: Curves.easeIn,
        ),
        scaleAnimation.animateTo(
          scaleAnimation.lowerBound,
          duration: firstStageDuration,
          curve: Curves.easeIn,
        ),
      ]);
      xOffsetAnimation.value = xOffsetAnimation.lowerBound;
      await Future.delayed(delay);
      await Future.wait([
        xOffsetAnimation.animateTo(
          0,
          duration: secondStageDuration,
          curve: Curves.easeOut,
        ),
        scaleAnimation.animateTo(
          scaleAnimation.upperBound,
          duration: secondStageDuration,
          curve: Curves.easeOut,
        ),
      ]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NoAnimationPinIndicator(
      spacing: widget.spacing,
      length: widget.length,
      builder: !initializationCompleter.isCompleted
          ? widget.builder
          : (i) {
              return AnimatedBuilder(
                animation: xOffsetAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(xOffsetAnimation.value, 0),
                    child: Transform.scale(
                      scale: scaleAnimation.value,
                      child: widget.builder(i),
                    ),
                  );
                },
              );
            },
    );
  }

  @override
  void dispose() {
    xOffsetAnimation.dispose();
    super.dispose();
  }
}
