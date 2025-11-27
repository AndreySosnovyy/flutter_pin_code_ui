import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/pin_indicator.dart';

// ignore_for_file: public_member_api_docs

class SuccessKickPinIndicator extends StatefulWidget {
  const SuccessKickPinIndicator({
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
  State<SuccessKickPinIndicator> createState() =>
      _SuccessKickPinIndicatorState();
}

class _SuccessKickPinIndicatorState extends State<SuccessKickPinIndicator>
    with TickerProviderStateMixin {
  List<AnimationController>? xOffsetAnimations;
  late final AnimationController scaleAnimation = AnimationController(
    vsync: this,
    lowerBound: 1.0,
    upperBound: 1.6,
  );
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final box = context.findRenderObject() as RenderBox;
      final positionX = box.localToGlobal(Offset.zero).dx;
      final indicatorLength = box.size.width;
      final screenWidth = MediaQuery.of(context).size.width;
      final offset = screenWidth - positionX - indicatorLength;
      xOffsetAnimations = List<AnimationController>.generate(
        widget.length,
        (i) => AnimationController(
          vsync: this,
          value: 0.0,
          lowerBound: i == 0 ? -indicatorLength / 2 : 0.0,
          upperBound: offset +
              (widget.length - 1 - i) * widget.spacing +
              widget.length * widget.childSize,
        ),
      );
      setState(() => _isInitialized = true);

      final stretchDuration = widget.duration * 0.32;
      final pauseDuration = widget.duration * 0.05;
      final kickDuration = widget.duration * 0.24;
      final dockingCount = widget.length - 2;
      final dockingDuration = (widget.duration * 0.052) ~/ dockingCount;
      final slideOutDuration = widget.duration -
          stretchDuration -
          pauseDuration -
          kickDuration -
          dockingDuration * dockingCount;
      await Future.wait([
        xOffsetAnimations![0].animateTo(
          xOffsetAnimations![0].lowerBound,
          duration: stretchDuration,
          curve: Curves.easeOutCubic,
        ),
        scaleAnimation.animateTo(
          scaleAnimation.upperBound,
          duration: stretchDuration,
          curve: Curves.easeOutCubic,
        ),
      ]);
      if (!mounted) return;
      await Future.delayed(pauseDuration);
      if (!mounted) return;
      await Future.wait([
        xOffsetAnimations![0].animateTo(
          0.0 + widget.spacing,
          duration: kickDuration,
          curve: Curves.easeInCubic,
        ),
        scaleAnimation.animateTo(
          1.0,
          duration: kickDuration,
          curve: Curves.easeInCubic,
        ),
      ]);
      if (!mounted) return;
      if (widget.vibration) HapticFeedback.heavyImpact();
      for (int i = 2; i < widget.length; i++) {
        if (!mounted) return;
        await Future.wait([
          for (int j = 0; j < i; j++)
            xOffsetAnimations![j].animateTo(
              xOffsetAnimations![j].value + widget.spacing,
              duration: dockingDuration,
              curve: Curves.linear,
            ),
        ]);
      }
      if (!mounted) return;
      await Future.wait([
        for (final animation in xOffsetAnimations!)
          animation.animateTo(
            animation.upperBound,
            duration: slideOutDuration,
            curve: Curves.decelerate,
          ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return NoAnimationPinIndicator(
      spacing: widget.spacing,
      length: widget.length,
      builder: !_isInitialized
          ? widget.builder
          : (i) {
              return AnimatedBuilder(
                animation: xOffsetAnimations![i],
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(xOffsetAnimations![i].value, 0),
                    child: Transform.scale(
                      scale: scaleAnimation.value,
                      child: widget.builder(i),
                    ),
                  );
                },
              );
            },
    );
  }

  @override
  void dispose() {
    scaleAnimation.dispose();
    if (xOffsetAnimations != null) {
      for (final animation in xOffsetAnimations!) {
        animation.dispose();
      }
    }
    super.dispose();
  }
}
