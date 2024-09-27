import 'package:flutter/material.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';

class InputFadePinIndicator extends StatefulWidget {
  const InputFadePinIndicator({
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
  State<InputFadePinIndicator> createState() => _InputFadePinIndicatorState();
}

class _InputFadePinIndicatorState extends State<InputFadePinIndicator>
    with SingleTickerProviderStateMixin {
  late final animation = AnimationController(
    vsync: this,
    duration: widget.duration,
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  @override
  void initState() {
    animation.animateTo(animation.upperBound, curve: Curves.linear);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final animatedItem = Stack(
      clipBehavior: Clip.none,
      children: [
        widget.builderDefault(widget.currentPinLength - 1),
        AnimatedBuilder(
          animation: animation,
          child: widget.builder(widget.currentPinLength - 1),
          builder: (context, child) {
            return Opacity(
              opacity: animation.value,
              child: child,
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
    animation.dispose();
    super.dispose();
  }
}
