import 'package:flutter/cupertino.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';

class IdlePulsePinIndicator extends StatefulWidget {
  const IdlePulsePinIndicator({
    required this.builder,
    required this.length,
    required this.duration,
    required this.spacing,
    required this.vibration,
    super.key,
  });

  final PinIndicatorItemBuilder builder;
  final int length;
  final Duration duration;
  final double spacing;
  final bool vibration;

  @override
  State<IdlePulsePinIndicator> createState() => _IdlePulsePinIndicatorState();
}

class _IdlePulsePinIndicatorState extends State<IdlePulsePinIndicator>
    with SingleTickerProviderStateMixin {
  late final animation = AnimationController(
    vsync: this,
    lowerBound: 1.0,
    upperBound: 1.3,
  );

  @override
  void initState() {
    final longerStageDuration = widget.duration * 0.3;
    final shorterStageDuration = widget.duration * 0.2;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await animation.animateTo(
        animation.upperBound,
        duration: longerStageDuration,
        curve: Curves.easeIn,
      );
      await animation.animateTo(
        1.1,
        duration: shorterStageDuration,
        curve: Curves.linear,
      );
      await animation.animateTo(
        animation.upperBound,
        duration: shorterStageDuration,
        curve: Curves.linear,
      );
      await animation.animateTo(
        animation.lowerBound,
        duration: longerStageDuration,
        curve: Curves.easeOut,
      );
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
