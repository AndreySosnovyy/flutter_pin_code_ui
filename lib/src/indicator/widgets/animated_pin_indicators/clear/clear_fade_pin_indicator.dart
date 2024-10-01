import 'package:flutter/cupertino.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';

// ignore_for_file: public_member_api_docs

class ClearFadePinIndicator extends StatefulWidget {
  const ClearFadePinIndicator({
    required this.builderOld,
    required this.builderNew,
    required this.length,
    required this.duration,
    required this.spacing,
    required this.vibration,
    super.key,
  });

  final PinIndicatorItemBuilder builderOld;
  final PinIndicatorItemBuilder builderNew;
  final int length;
  final Duration duration;
  final double spacing;
  final bool vibration;

  @override
  State<ClearFadePinIndicator> createState() => _ClearFadePinIndicatorState();
}

class _ClearFadePinIndicatorState extends State<ClearFadePinIndicator>
    with SingleTickerProviderStateMixin {
  late final animation = AnimationController(
    vsync: this,
    value: 1.0,
    lowerBound: 0.0,
    upperBound: 1.0,
    duration: widget.duration,
  );

  @override
  void initState() {
    animation.animateTo(
      animation.lowerBound,
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
                return Opacity(
                  opacity: animation.value,
                  child: widget.builderOld(i),
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
