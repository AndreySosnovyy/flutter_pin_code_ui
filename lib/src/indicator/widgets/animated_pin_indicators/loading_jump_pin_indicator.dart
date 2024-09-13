import 'package:flutter/cupertino.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';

class LoadingJumpPinIndicator extends StatefulWidget {
  const LoadingJumpPinIndicator({
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
  State<LoadingJumpPinIndicator> createState() =>
      _LoadingJumpPinIndicatorState();
}

class _LoadingJumpPinIndicatorState extends State<LoadingJumpPinIndicator>
    with TickerProviderStateMixin {
  late final animations = List.generate(
    widget.length,
    (i) => AnimationController(
      vsync: this,
      duration: widget.duration ~/ 2,
      lowerBound: 0.0,
      upperBound: 1.0,
    ),
  );

  @override
  void initState() {
    for (int i = 0; i < widget.length; i++) {
      Future.delayed(widget.duration ~/ widget.length).then((_) => animations[i]
          .animateTo(animations[i].upperBound)
          .then((_) => animations[i].animateTo(animations[i].lowerBound)));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NoAnimationPinIndicator(
      spacing: widget.spacing,
      length: widget.length,
      builder: (i) => Transform.translate(
        offset: Offset(0, -animations[i].value * 64),
      ),
    );
  }

  @override
  void dispose() {
    for (final animation in animations) {
      animation.dispose();
    }
    super.dispose();
  }
}
