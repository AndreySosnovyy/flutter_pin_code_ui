import 'package:flutter/cupertino.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/pin_indicator.dart';

// ignore_for_file: public_member_api_docs

class IdleWavePinIndicator extends StatefulWidget {
  const IdleWavePinIndicator({
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
  State<IdleWavePinIndicator> createState() => _IdleWavePinIndicatorState();
}

class _IdleWavePinIndicatorState extends State<IdleWavePinIndicator>
    with TickerProviderStateMixin {
  late final animations = List.generate(
    widget.length,
    (i) => AnimationController(
      vsync: this,
      duration:
          (widget.duration ~/ 2 - widget.duration ~/ 2 ~/ (widget.length - 1)),
      lowerBound: 1.0,
      upperBound: 1.3,
    ),
  );

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (int i = 0; i < widget.length; i++) {
        final delay = widget.duration ~/ (widget.length * 2) * i;
        Future.delayed(delay).then((_) {
          if (!mounted) return;
          animations[i]
              .animateTo(animations[i].upperBound, curve: Curves.ease)
              .then((_) {
            if (!mounted) return;
            animations[i]
                .animateTo(animations[i].lowerBound, curve: Curves.linear);
          });
        });
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
