import 'package:flutter/material.dart';

class PinIndicatorDot extends StatelessWidget {
  const PinIndicatorDot({
    required this.decoration,
    required this.size,
    super.key,
  });

  final BoxDecoration decoration;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: decoration,
      ),
    );
  }
}
