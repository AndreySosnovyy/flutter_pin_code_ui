import 'package:flutter/cupertino.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/pin_indicator.dart';

// ignore_for_file: public_member_api_docs

class ClearDropPinIndicator extends StatefulWidget {
  const ClearDropPinIndicator({
    required this.builderOld,
    required this.builderNew,
    required this.length,
    required this.duration,
    required this.spacing,
    required this.childSize,
    required this.vibration,
    super.key,
  });

  final PinIndicatorItemBuilder builderOld;
  final PinIndicatorItemBuilder builderNew;
  final int length;
  final double childSize;
  final Duration duration;
  final double spacing;
  final bool vibration;

  @override
  State<ClearDropPinIndicator> createState() => _ClearDropPinIndicatorState();
}

class _ClearDropPinIndicatorState extends State<ClearDropPinIndicator>
    with SingleTickerProviderStateMixin {
  late final animation = AnimationController(
    vsync: this,
    lowerBound: 0.0,
    upperBound: 1.0,
    duration: widget.duration,
  );

  @override
  void initState() {
    animation.animateTo(
      animation.upperBound,
      curve: Curves.easeOutCubic,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        NoAnimationPinIndicator(
          spacing: widget.spacing,
          length: widget.length,
          builder: (i) => widget.builderNew(i),
        ),
        NoAnimationPinIndicator(
          spacing: widget.spacing,
          length: widget.length,
          builder: (i) {
            return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, animation.value * widget.childSize * 2.6),
                  child: Opacity(
                    opacity: 1 - animation.value,
                    child: widget.builderOld(i),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }
}
