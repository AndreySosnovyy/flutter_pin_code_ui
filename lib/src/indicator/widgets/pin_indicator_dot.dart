import 'package:flutter/material.dart';

class PinIndicatorDot extends StatelessWidget {
  const PinIndicatorDot({
    required this.color,
    required this.size,
    super.key,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
