import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:pin_ui/src/indicator/widgets/no_animation_pin_indicator.dart';
import 'package:pin_ui/src/indicator/widgets/pin_indicator.dart';

// ignore_for_file: public_member_api_docs

class SuccessFillLastPinIndicator extends StatefulWidget {
  const SuccessFillLastPinIndicator({
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
  State<SuccessFillLastPinIndicator> createState() =>
      _SuccessFillLastPinIndicatorState();
}

class _SuccessFillLastPinIndicatorState
    extends State<SuccessFillLastPinIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController? animation;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final box = context.findRenderObject() as RenderBox;
      final positionY = box.localToGlobal(Offset.zero).dy;
      final screenHeight = MediaQuery.sizeOf(context).height;
      final heightToFill = math.max(positionY, screenHeight - positionY);
      final fillScale = heightToFill / widget.childSize * 2.3;
      animation = AnimationController(
        vsync: this,
        duration: widget.duration,
        lowerBound: 1.0,
        upperBound: fillScale,
      );
      setState(() => _isInitialized = true);
      if (!mounted) return;
      await animation!.animateTo(animation!.upperBound, curve: Curves.ease);
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
              return i != widget.length - 1
                  ? widget.builder(i)
                  : AnimatedBuilder(
                      animation: animation!,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: animation!.value,
                          child: widget.builder(i),
                        );
                      },
                    );
            },
    );
  }

  @override
  void dispose() {
    animation?.dispose();
    super.dispose();
  }
}
