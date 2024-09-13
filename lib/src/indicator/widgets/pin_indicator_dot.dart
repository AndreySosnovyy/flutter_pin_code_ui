import 'package:flutter/material.dart';

class PinIndicatorDot extends StatelessWidget {
  const PinIndicatorDot({
    required this.decoration,
    required this.size,
    this.child,
    super.key,
  });

  final BoxDecoration decoration;
  final double size;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: decoration,
        child: child,
      ),
    );
  }
}
