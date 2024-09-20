import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';

class LoadingTravelPinIndicator extends StatefulWidget {
  const LoadingTravelPinIndicator({
    required this.builder,
    required this.length,
    required this.duration,
    required this.spacing,
    super.key,
  });

  final PinIndicatorItemBuilder builder;
  final int length;
  final Duration duration;
  final double spacing;

  @override
  State<LoadingTravelPinIndicator> createState() =>
      _LoadingTravelPinIndicatorState();
}

class _LoadingTravelPinIndicatorState extends State<LoadingTravelPinIndicator>
    with TickerProviderStateMixin {
  late final AnimationController xOffsetAnimation;
  final initializationCompleter = Completer<void>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final outDuration = widget.duration * 0.4;
      final delay = widget.duration * 0.2;
      final inDuration = widget.duration * 0.4;
      final box = context.findRenderObject() as RenderBox;
      final positionX = box.localToGlobal(Offset.zero).dx;
      final screenWidth = MediaQuery.sizeOf(context).width;
      xOffsetAnimation = AnimationController(
        vsync: this,
        value: 0.0,
        lowerBound: -screenWidth,
        upperBound: screenWidth,
      );
      setState(() => initializationCompleter.complete());
      await xOffsetAnimation.animateTo(
        xOffsetAnimation.upperBound,
        duration: outDuration,
        curve: Curves.ease,
      );
      xOffsetAnimation.value = xOffsetAnimation.lowerBound;
      await Future.delayed(delay);
      await xOffsetAnimation.animateTo(
        0,
        duration: inDuration,
        curve: Curves.ease,
      );
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
                    child: widget.builder(i),
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
