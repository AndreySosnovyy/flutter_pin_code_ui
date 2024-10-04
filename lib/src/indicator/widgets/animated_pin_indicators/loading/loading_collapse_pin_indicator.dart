import 'package:flutter/material.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/pin_indicator.dart';

// ignore_for_file: public_member_api_docs

class LoadingCollapsePinIndicator extends StatefulWidget {
  const LoadingCollapsePinIndicator({
    required this.builder,
    required this.length,
    required this.duration,
    required this.spacing,
    required this.childSize,
    required this.loadingIndicator,
    required this.vibration,
    super.key,
  });

  final PinIndicatorItemBuilder builder;
  final int length;
  final Duration duration;
  final double spacing;
  final bool vibration;

  /// Size of indicator item
  final double childSize;

  /// Widget that will be shown when indicator items are collapsed
  final Widget loadingIndicator;

  @override
  State<LoadingCollapsePinIndicator> createState() =>
      _LoadingCollapsePinIndicatorState();
}

class _LoadingCollapsePinIndicatorState
    extends State<LoadingCollapsePinIndicator> with TickerProviderStateMixin {
  late final centerIndex = widget.length ~/ 2;
  late final distances = List<double>.generate(
    widget.length,
    (i) {
      final index = getFirstHalfIndexFromGeneralIndex(i);
      if (index == centerIndex && widget.length.isOdd) return 0;
      if (widget.length.isEven) {
        return widget.childSize / 2 +
            (centerIndex - index - 1) * (widget.spacing + widget.childSize) +
            widget.spacing / 2;
      } else {
        return (widget.childSize + widget.spacing) * (centerIndex - index);
      }
    },
  );

  int getFirstHalfIndexFromGeneralIndex(int index) =>
      index < centerIndex ? index : widget.length - 1 - index;

  late final offsetAnimations = List.generate(
    widget.length ~/ 2,
    (i) => AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: distances[i],
    ),
  );
  late final scaleAnimation = AnimationController(
    vsync: this,
    value: 0.0,
    lowerBound: 0.9,
    upperBound: 1.2,
  );
  late final opacityAnimation = AnimationController(
    vsync: this,
    value: 1.0,
    lowerBound: 0.0,
    upperBound: 1.0,
  );
  late final childAnimation = AnimationController(
    vsync: this,
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (final offsetAnimation in offsetAnimations) {
        offsetAnimation.animateTo(
          offsetAnimation.upperBound,
          curve: Curves.easeOutSine,
          duration: widget.duration,
        );
      }
      scaleAnimation.animateTo(
        scaleAnimation.lowerBound,
        curve: Curves.easeOutSine,
        duration: widget.duration,
      );
      opacityAnimation.animateTo(
        opacityAnimation.lowerBound,
        curve: Curves.easeOut,
        duration: widget.duration,
      );
      await Future.delayed(widget.duration ~/ 2);
      childAnimation.animateTo(
        childAnimation.upperBound,
        curve: Curves.easeOutCirc,
        duration: widget.duration,
      );
    });
    super.initState();
  }

  AnimationController? getOffsetAnimationForIndex(int index) {
    index = getFirstHalfIndexFromGeneralIndex(index);
    if (index > offsetAnimations.length - 1) return null;
    return offsetAnimations[index];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        NoAnimationPinIndicator(
          spacing: widget.spacing,
          length: widget.length,
          builder: (i) {
            return AnimatedBuilder(
              animation: scaleAnimation,
              builder: (context, child) {
                return AnimatedBuilder(
                  animation: getOffsetAnimationForIndex(i) ??
                      AnimationController(vsync: this),
                  builder: (context, child) {
                    final direction = i < centerIndex ? 1 : -1;
                    final double xOffset =
                        direction * (getOffsetAnimationForIndex(i)?.value ?? 0);
                    return Transform.scale(
                      scale: scaleAnimation.value,
                      child: Transform.translate(
                        offset: Offset(xOffset, 0),
                        child: Opacity(
                          opacity: opacityAnimation.value,
                          child: widget.builder(i),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
        Positioned(
          top: -widget.childSize,
          child: AnimatedBuilder(
            animation: childAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: childAnimation.value,
                child: Opacity(
                  opacity: childAnimation.value,
                  child: widget.loadingIndicator,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    for (final animation in offsetAnimations) {
      animation.dispose();
    }
    scaleAnimation.dispose();
    opacityAnimation.dispose();
    childAnimation.dispose();
    super.dispose();
  }
}
