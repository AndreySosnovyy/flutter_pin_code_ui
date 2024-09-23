import 'package:flutter/cupertino.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';

class LoadingWaveDeflatePinIndicator extends StatefulWidget {
  const LoadingWaveDeflatePinIndicator({
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
  State<LoadingWaveDeflatePinIndicator> createState() =>
      _LoadingWaveDeflatePinIndicatorState();
}

class _LoadingWaveDeflatePinIndicatorState
    extends State<LoadingWaveDeflatePinIndicator>
    with TickerProviderStateMixin {
  late final animations = List.generate(
    widget.length,
    (i) => AnimationController(
      vsync: this,
      duration:
          (widget.duration ~/ 2 - widget.duration ~/ 2 ~/ (widget.length - 1)),
      value: 1.0,
      lowerBound: 0.6,
      upperBound: 1.0,
    ),
  );

  @override
  void initState() {
    for (int i = 0; i < widget.length; i++) {
      final delay = widget.duration ~/ (widget.length * 2) * i;
      Future.delayed(delay).then(
        (_) => animations[i]
            .animateTo(animations[i].lowerBound, curve: Curves.linear)
            .then((_) => animations[i]
                .animateTo(animations[i].upperBound, curve: Curves.easeOut)),
      );
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
            return Transform.scale(
              scale: animations[i].value,
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