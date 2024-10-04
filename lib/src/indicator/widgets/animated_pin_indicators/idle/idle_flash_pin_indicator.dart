import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/pin_indicator.dart';

// ignore_for_file: public_member_api_docs

class IdleFlashPinIndicator extends StatefulWidget {
  const IdleFlashPinIndicator({
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
  State<IdleFlashPinIndicator> createState() => _IdleFlashPinIndicatorState();
}

class _IdleFlashPinIndicatorState extends State<IdleFlashPinIndicator>
    with TickerProviderStateMixin {
  late final animations = List<AnimationController>.generate(
    widget.length,
    (i) => AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.3,
    ),
  );

  @override
  void initState() {
    final random = math.Random(widget.key.hashCode);
    const flashLowerBound = 1.2;
    final flashMinDuration = widget.duration * 0.15;
    final flashMaxDuration = widget.duration * 0.20;
    final delayMinDuration = widget.duration * 0.08;
    final delayMaxDuration = widget.duration * 0.10;
    final stopwatch = Stopwatch()..start();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      while (stopwatch.elapsed + flashMaxDuration < widget.duration) {
        if (!mounted) return;
        if (animations.every((a) => a.isAnimating)) {
          await Future.delayed(delayMinDuration);
          continue;
        }
        final animation =
            (animations.toList()..shuffle()).firstWhere((a) => !a.isAnimating);
        final flashDuration = Duration(
            milliseconds: flashMaxDuration.inMilliseconds +
                random.nextInt(flashMaxDuration.inMilliseconds -
                    flashMinDuration.inMilliseconds));
        animation
            .animateTo(
                random.nextDouble() * (animation.upperBound - flashLowerBound) +
                    flashLowerBound,
                duration: flashDuration ~/ 2,
                curve: Curves.ease)
            .then((_) {
          if (!mounted) return;
          animation.animateTo(
            animation.lowerBound,
            duration: flashDuration ~/ 2,
            curve: Curves.ease,
          );
        });
        final delay = Duration(
          milliseconds: delayMinDuration.inMilliseconds +
              random.nextInt(delayMaxDuration.inMilliseconds -
                  delayMinDuration.inMilliseconds),
        );
        await Future.delayed(delay);
      }
      stopwatch.stop();
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
