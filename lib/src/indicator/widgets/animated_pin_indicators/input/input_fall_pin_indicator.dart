import 'package:flutter/material.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';

class InputFallPinIndicator extends StatefulWidget {
  const InputFallPinIndicator({
    required this.builder,
    required this.builderDefault,
    required this.length,
    required this.duration,
    required this.currentPinLength,
    required this.spacing,
    required this.vibration,
    super.key,
  })  : assert(currentPinLength > 0),
        assert(currentPinLength <= length);

  final PinIndicatorItemBuilder builder;
  final PinIndicatorItemBuilder builderDefault;
  final int length;
  final int currentPinLength;
  final Duration duration;
  final double spacing;
  final bool vibration;

  @override
  State<InputFallPinIndicator> createState() => _InputFallPinIndicatorState();
}

class _InputFallPinIndicatorState extends State<InputFallPinIndicator>
    with TickerProviderStateMixin {
  late final scaleAnimation = AnimationController(
    vsync: this,
    duration: widget.duration,
    value: 2.4,
    lowerBound: 1.0,
    upperBound: 2.4,
  );
  late final opacityAnimation = AnimationController(
    vsync: this,
    duration: widget.duration,
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  @override
  void initState() {
    scaleAnimation.animateTo(
      scaleAnimation.lowerBound,
      curve: Curves.easeOut,
    );
    opacityAnimation.animateTo(
      opacityAnimation.upperBound,
      curve: Curves.easeIn,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final animatedItem = Stack(
      clipBehavior: Clip.none,
      children: [
        widget.builderDefault(widget.currentPinLength - 1),
        AnimatedBuilder(
          animation: scaleAnimation,
          child: widget.builder(widget.currentPinLength - 1),
          builder: (context, child) {
            return Transform.scale(
              scale: scaleAnimation.value,
              child: Opacity(
                opacity: opacityAnimation.value,
                child: child,
              ),
            );
          },
        ),
      ],
    );
    return NoAnimationPinIndicator(
      spacing: widget.spacing,
      builder: (i) =>
          i == widget.currentPinLength - 1 ? animatedItem : widget.builder(i),
      length: widget.length,
    );
  }

  @override
  void dispose() {
    scaleAnimation.dispose();
    opacityAnimation.dispose();
    super.dispose();
  }
}
