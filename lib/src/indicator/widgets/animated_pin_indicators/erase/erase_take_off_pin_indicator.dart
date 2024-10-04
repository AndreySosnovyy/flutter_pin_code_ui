import 'package:flutter/material.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/pin_indicator.dart';

// ignore_for_file: public_member_api_docs

class EraseTakeOffPinIndicator extends StatefulWidget {
  const EraseTakeOffPinIndicator({
    required this.builder,
    required this.builderInput,
    required this.length,
    required this.duration,
    required this.currentPinLength,
    required this.spacing,
    required this.vibration,
    super.key,
  })  : assert(currentPinLength >= 0),
        assert(currentPinLength < length);

  final PinIndicatorItemBuilder builder;
  final PinIndicatorItemBuilder builderInput;
  final int length;
  final int currentPinLength;
  final Duration duration;
  final double spacing;
  final bool vibration;

  @override
  State<EraseTakeOffPinIndicator> createState() =>
      _EraseTakeOffPinIndicatorState();
}

class _EraseTakeOffPinIndicatorState extends State<EraseTakeOffPinIndicator>
    with TickerProviderStateMixin {
  late final scaleAnimation = AnimationController(
    vsync: this,
    duration: widget.duration,
    lowerBound: 1.0,
    upperBound: 1.8,
  );
  late final opacityAnimation = AnimationController(
    vsync: this,
    duration: widget.duration,
    value: 1.0,
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  @override
  void initState() {
    scaleAnimation.animateTo(
      scaleAnimation.upperBound,
      curve: Curves.easeIn,
    );
    opacityAnimation.animateTo(
      opacityAnimation.lowerBound,
      curve: Curves.easeOut,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final animatedItem = Stack(
      clipBehavior: Clip.none,
      children: [
        widget.builder(widget.currentPinLength),
        AnimatedBuilder(
          animation: scaleAnimation,
          child: widget.builderInput(widget.currentPinLength),
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
          i == widget.currentPinLength ? animatedItem : widget.builder(i),
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
