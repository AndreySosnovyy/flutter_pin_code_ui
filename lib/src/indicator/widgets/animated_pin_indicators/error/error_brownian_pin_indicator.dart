import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';

// ignore_for_file: public_member_api_docs

class ErrorBrownianPinIndicator extends StatefulWidget {
  const ErrorBrownianPinIndicator({
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
  State<ErrorBrownianPinIndicator> createState() =>
      _ErrorBrownianPinIndicatorState();
}

class _ErrorBrownianPinIndicatorState extends State<ErrorBrownianPinIndicator>
    with TickerProviderStateMixin {
  late final xOffsetAnimations = List<AnimationController>.generate(
    widget.length,
    (i) {
      return AnimationController(
        vsync: this,
        value: 0.0,
        lowerBound: -1.0,
        upperBound: 1.0,
      );
    },
  );
  late final yOffsetAnimations = List<AnimationController>.generate(
    widget.length,
    (i) {
      return AnimationController(
        vsync: this,
        value: 0.0,
        lowerBound: -1.0,
        upperBound: 1.0,
      );
    },
  );

  @override
  void initState() {
    const bouncesCount = 6;
    final moveDuration = widget.duration ~/ bouncesCount;
    final edgeMoveDuration = moveDuration ~/ 2;
    final random = math.Random();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (int i = 0; i < bouncesCount + 1; i++) {
        await Future.wait([
          for (final animation in [...xOffsetAnimations, ...yOffsetAnimations])
            animation.animateTo(
              i == bouncesCount ? 0.0 : random.nextDouble() * 2 - 1,
              duration: i == 0 ? edgeMoveDuration : moveDuration,
              curve: Curves.easeInOutQuad,
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
          animation: yOffsetAnimations[i],
          builder: (context, _) {
            return AnimatedBuilder(
              animation: xOffsetAnimations[i],
              builder: (context, _) {
                return Transform.translate(
                  offset: Offset(
                    xOffsetAnimations[i].value * widget.childSize * 0.36,
                    yOffsetAnimations[i].value * widget.childSize * 0.36,
                  ),
                  child: widget.builder(i),
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
    for (final animation in [...xOffsetAnimations, ...yOffsetAnimations]) {
      animation.dispose();
    }
    super.dispose();
  }
}
