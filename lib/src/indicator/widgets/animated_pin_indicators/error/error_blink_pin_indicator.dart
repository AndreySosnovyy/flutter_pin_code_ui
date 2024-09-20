import 'package:flutter/cupertino.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';

class ErrorBlinkPinIndicator extends StatefulWidget {
  const ErrorBlinkPinIndicator({
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
  State<ErrorBlinkPinIndicator> createState() => _ErrorBlinkPinIndicatorState();
}

class _ErrorBlinkPinIndicatorState extends State<ErrorBlinkPinIndicator>
    with TickerProviderStateMixin {
  late final opacityAnimation = AnimationController(
    vsync: this,
    value: 1.0,
    lowerBound: 0.5,
    upperBound: 1.0,
  );
  late final scaleAnimation = AnimationController(
    vsync: this,
    lowerBound: 1.0,
    upperBound: 1.2,
  );

  @override
  void initState() {
    const repeatCount = 3;
    final stageDuration = widget.duration ~/ (repeatCount * 2 + 1);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await opacityAnimation.animateTo(
        opacityAnimation.lowerBound,
        duration: stageDuration,
        curve: Curves.linear,
      );
      for (int i = 0; i < repeatCount; i++) {
        await Future.wait([
          opacityAnimation.animateTo(
            opacityAnimation.upperBound,
            duration: stageDuration,
            curve: Curves.linear,
          ),
          scaleAnimation.animateTo(
            scaleAnimation.upperBound,
            duration: stageDuration,
            curve: Curves.linear,
          ),
        ]);
        await Future.wait([
          if (i < repeatCount - 1)
            opacityAnimation.animateTo(
              opacityAnimation.lowerBound,
              duration: stageDuration,
              curve: Curves.linear,
            ),
          scaleAnimation.animateTo(
            scaleAnimation.lowerBound,
            duration: stageDuration,
            curve: Curves.linear,
          ),
        ]);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NoAnimationPinIndicator(
      spacing: widget.spacing,
      length: widget.length,
      builder: (i) {
        return AnimatedBuilder(
          animation: scaleAnimation,
          builder: (context, _) {
            return Transform.scale(
              scale: scaleAnimation.value,
              child: AnimatedBuilder(
                  animation: opacityAnimation,
                  builder: (context, _) {
                    return Opacity(
                      opacity: opacityAnimation.value,
                      child: widget.builder(i),
                    );
                  }),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    opacityAnimation.dispose();
    scaleAnimation.dispose();
    super.dispose();
  }
}
