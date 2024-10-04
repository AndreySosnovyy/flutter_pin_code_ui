import 'package:flutter/cupertino.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/pin_indicator.dart';
import 'package:vibration/vibration.dart';

// ignore_for_file: public_member_api_docs

class EraseDeflatePinIndicator extends StatefulWidget {
  const EraseDeflatePinIndicator({
    required this.builder,
    required this.length,
    required this.currentPinLength,
    required this.duration,
    required this.spacing,
    required this.vibration,
    super.key,
  })  : assert(currentPinLength >= 0),
        assert(currentPinLength < length);

  final PinIndicatorItemBuilder builder;
  final int length;
  final int currentPinLength;
  final Duration duration;
  final double spacing;
  final bool vibration;

  @override
  State<EraseDeflatePinIndicator> createState() =>
      _EraseDeflatePinIndicatorState();
}

class _EraseDeflatePinIndicatorState extends State<EraseDeflatePinIndicator>
    with SingleTickerProviderStateMixin {
  late final animation = AnimationController(
    vsync: this,
    duration: widget.duration ~/ 2,
    lowerBound: 0.9,
    upperBound: 1.0,
    value: 1.0,
  );

  void vibrate() async {
    if (!widget.vibration) return;
    Vibration.vibrate(
      pattern: [1, (widget.duration ~/ 2).inMilliseconds],
      intensities: [92, 92],
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      vibrate();
      animation
          .animateTo(animation.lowerBound, curve: Curves.easeOutQuint)
          .then((_) =>
              animation.animateTo(animation.upperBound, curve: Curves.linear));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final animatedItem = AnimatedBuilder(
      animation: animation,
      child: widget.builder(widget.currentPinLength),
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: child,
        );
      },
    );
    return NoAnimationPinIndicator(
      spacing: widget.spacing,
      builder: (i) =>
          i == widget.currentPinLength ? animatedItem : widget.builder(i),
      length: widget.length,
    );
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }
}
