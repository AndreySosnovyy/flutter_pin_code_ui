import 'package:flutter/material.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';

class InputInflatePinIndicator extends StatefulWidget {
  const InputInflatePinIndicator({
    required this.builder,
    required this.length,
    required this.duration,
    required this.currentPinLength,
    required this.spacing,
    super.key,
  })  : assert(currentPinLength > 0),
        assert(currentPinLength <= length);

  final PinIndicatorItemBuilder builder;
  final int length;
  final int currentPinLength;
  final Duration duration;
  final double spacing;

  @override
  State<InputInflatePinIndicator> createState() =>
      _InputInflatePinIndicatorState();
}

class _InputInflatePinIndicatorState extends State<InputInflatePinIndicator>
    with SingleTickerProviderStateMixin {
  late final animation = AnimationController(
    vsync: this,
    duration: widget.duration ~/ 2,
    lowerBound: 1.0,
    upperBound: 1.3,
  );

  @override
  void initState() {
    animation.animateTo(animation.upperBound, curve: Curves.ease).then(
        (_) => animation.animateTo(animation.lowerBound, curve: Curves.easeIn));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final animatedItem = AnimatedBuilder(
      animation: animation,
      child: widget.builder(widget.currentPinLength - 1),
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: child,
        );
      },
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
    animation.dispose();
    super.dispose();
  }
}