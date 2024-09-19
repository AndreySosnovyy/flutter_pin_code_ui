import 'package:flutter/cupertino.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';

class SuccessFillPinIndicator extends StatefulWidget {
  const SuccessFillPinIndicator({
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
  State<SuccessFillPinIndicator> createState() =>
      _SuccessFillPinIndicatorState();
}

class _SuccessFillPinIndicatorState extends State<SuccessFillPinIndicator>
    with TickerProviderStateMixin {
  late final animation = AnimationController(
    vsync: this,
    duration: widget.duration,
    lowerBound: 1.0,
    upperBound: 72.0,
  );

  @override
  void initState() {
    animation.animateTo(
      animation.upperBound,
      curve: Curves.ease,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NoAnimationPinIndicator(
      spacing: widget.spacing,
      length: widget.length,
      builder: (i) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Transform.scale(
              scale: animation.value,
              child: widget.builder(i),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }
}
