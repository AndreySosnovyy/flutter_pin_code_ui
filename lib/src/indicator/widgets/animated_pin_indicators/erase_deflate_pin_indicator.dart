import 'package:flutter/cupertino.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';

class EraseDeflatePinIndicator extends StatefulWidget {
  const EraseDeflatePinIndicator({
    required this.builder,
    required this.length,
    required this.currentPinLength,
    required this.duration,
    required this.spacing,
    super.key,
  });

  final PinIndicatorItemBuilder builder;
  final int length;
  final int currentPinLength;
  final Duration duration;
  final double spacing;

  @override
  State<EraseDeflatePinIndicator> createState() => _EraseDeflatePinIndicatorState();
}

class _EraseDeflatePinIndicatorState extends State<EraseDeflatePinIndicator>
    with SingleTickerProviderStateMixin {
  late final animation = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
    lowerBound: 0.9,
    upperBound: 1.0,
    value: 1.0,
  );

  @override
  void initState() {
    animation.animateTo(animation.lowerBound, curve: Curves.easeOutQuint).then(
        (_) => animation.animateTo(animation.upperBound, curve: Curves.linear));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final animatedItem = AnimatedBuilder(
      animation: animation,
      child: widget.builder(widget.currentPinLength),
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
          i == widget.currentPinLength ? animatedItem : widget.builder(i),
      length: widget.length,
    );
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }
}
