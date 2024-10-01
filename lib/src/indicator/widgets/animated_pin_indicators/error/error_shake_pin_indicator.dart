import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';

// ignore_for_file: public_member_api_docs

class ErrorShakePinIndicator extends StatefulWidget {
  const ErrorShakePinIndicator({
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
  State<ErrorShakePinIndicator> createState() => _ErrorShakePinIndicatorState();
}

class _ErrorShakePinIndicatorState extends State<ErrorShakePinIndicator>
    with SingleTickerProviderStateMixin {
  late final animation = AnimationController(
    vsync: this,
    value: 0.0,
    lowerBound: -0.5,
    upperBound: 0.5,
  );

  @override
  void initState() {
    const repeatCount = 2;
    // Longer duration for bounce animation
    final lastQuarterDuration = widget.duration ~/ repeatCount ~/ 4 * 2;
    // Default duration of quarter of a full cycle (center -> right -> left -> center)
    final quarterDuration =
        (widget.duration - lastQuarterDuration) ~/ (repeatCount * 4 - 1);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (int i = 0; i < repeatCount; i++) {
        await animation.animateTo(
          animation.upperBound,
          duration: quarterDuration,
        );
        if (widget.vibration) HapticFeedback.mediumImpact();
        await animation.animateTo(
          animation.lowerBound,
          duration: quarterDuration * 2,
        );
        if (widget.vibration) HapticFeedback.mediumImpact();
        await animation.animateTo(
          0.0,
          duration:
              i == repeatCount - 1 ? lastQuarterDuration : quarterDuration,
          curve: i == repeatCount - 1 ? Curves.bounceOut : Curves.linear,
        );
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
          animation: animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(animation.value * widget.childSize * 2.3, 0),
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
