import 'package:flutter/material.dart';

class ShakingError extends StatelessWidget {
  const ShakingError({
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.deltaX = 20,
    this.curve = Curves.bounceOut,
    this.onEnd,
    super.key,
  });

  final Duration duration;
  final double deltaX;
  final Widget child;
  final Curve curve;
  final VoidCallback? onEnd;

  double _calculateOffset(double value) =>
      2 * (0.5 - (0.5 - curve.transform(value)).abs());

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: key,
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      builder: (_, value, child) => Transform.translate(
        offset: Offset(deltaX * _calculateOffset(value), 0),
        child: child,
      ),
      onEnd: onEnd,
      child: child,
    );
  }
}
