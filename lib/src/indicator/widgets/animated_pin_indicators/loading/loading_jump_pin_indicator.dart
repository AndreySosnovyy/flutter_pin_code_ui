import 'package:flutter/cupertino.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';

class LoadingJumpPinIndicator extends StatefulWidget {
  const LoadingJumpPinIndicator({
    required this.builder,
    required this.length,
    required this.duration,
    required this.spacing,
    required this.childSize,
    required this.vibration,
    super.key,
  });

  final PinIndicatorItemBuilder builder;
  final int length;
  final Duration duration;
  final double spacing;
  final double childSize;
  final bool vibration;

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
      duration:
          (widget.duration ~/ 2 - widget.duration ~/ 2 ~/ (widget.length - 1)),
      lowerBound: 0.0,
      upperBound: 1.0,
    ),
  );

  @override
  void initState() {
    for (int i = 0; i < widget.length; i++) {
      final delay = widget.duration ~/ (widget.length * 2) * i;
      Future.delayed(delay).then((_) => animations[i]
          .animateTo(animations[i].upperBound, curve: Curves.easeOutSine)
          .then((_) => animations[i]
              .animateTo(animations[i].lowerBound, curve: Curves.bounceOut)));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NoAnimationPinIndicator(
      spacing: widget.spacing,
      length: widget.length,
      builder: (i) {
        return AnimatedBuilder(
          animation: animations[i],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, -animations[i].value * widget.childSize * 3.4),
              child: widget.builder(i),
            );
          },
        );
      },
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
