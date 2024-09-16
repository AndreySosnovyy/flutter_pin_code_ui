import 'package:flutter/cupertino.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';

class SuccessCollapsePinIndicator extends StatefulWidget {
  const SuccessCollapsePinIndicator({
    required this.builder,
    required this.length,
    required this.duration,
    required this.spacing,
    this.collapsedChild,
    super.key,
  });

  final PinIndicatorItemBuilder builder;
  final int length;
  final Duration duration;
  final double spacing;

  /// Widget that will be shown when indicator items is collapsed
  final Widget? collapsedChild;

  @override
  State<SuccessCollapsePinIndicator> createState() =>
      _SuccessCollapsePinIndicatorState();
}

class _SuccessCollapsePinIndicatorState
    extends State<SuccessCollapsePinIndicator> with TickerProviderStateMixin {
  late final offsetAnimation = AnimationController(
    vsync: this,
    value: 0.0,
    lowerBound: -0.4,
    upperBound: 1.0,
  );

  late final scaleAnimation = AnimationController(
    vsync: this,
    value: 0.0,
    lowerBound: 0.9,
    upperBound: 1.2,
  );

  // Array of speed values for animating each item's position of indicator
  final List<int> speedMultipliers = <int>[];

  void initializeMultipliers() {
    final centerIndex = widget.length ~/ 2;
    final buffer = <int>[];
    for (int i = 0; i < centerIndex; i++) {
      buffer.add(centerIndex - i);
    }
    speedMultipliers.addAll(buffer);
    if (widget.length.isOdd) speedMultipliers.add(0);
    speedMultipliers.addAll(buffer.reversed);
  }

  @override
  void initState() {
    initializeMultipliers();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final firstStageDuration = widget.duration * 0.3;
      final pauseDuration = widget.duration * 0.06;
      final secondStageDuration = widget.duration * 0.64;
      await Future.wait([
        offsetAnimation.animateTo(
          offsetAnimation.lowerBound,
          curve: Curves.easeOutSine,
          duration: firstStageDuration,
        ),
        scaleAnimation.animateTo(
          scaleAnimation.upperBound,
          curve: Curves.easeOutSine,
          duration: firstStageDuration,
        ),
      ]);
      await Future.delayed(pauseDuration);
      await Future.wait([
        offsetAnimation.animateTo(
          offsetAnimation.upperBound,
          curve: Curves.easeOutSine,
          duration: secondStageDuration,
        ),
        scaleAnimation.animateTo(
          scaleAnimation.lowerBound,
          curve: Curves.easeOutSine,
          duration: secondStageDuration,
        ),
      ]);
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
          builder: (context, child) {
            return AnimatedBuilder(
              animation: offsetAnimation,
              builder: (context, child) {
                final direction = (i < widget.length / 2 ? 1 : -1);
                final delta = widget.spacing;
                final xOffset = direction *
                    offsetAnimation.value *
                    delta *
                    speedMultipliers[i];
                return Transform.scale(
                  scale: scaleAnimation.value,
                  child: Transform.translate(
                    offset: Offset(xOffset, 0),
                    child: widget.builder(i),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    offsetAnimation.dispose();
    scaleAnimation.dispose();
    super.dispose();
  }
}
