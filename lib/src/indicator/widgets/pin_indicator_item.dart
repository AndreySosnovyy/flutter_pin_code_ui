import 'package:flutter/material.dart';

class PinIndicatorItem extends StatelessWidget {
  const PinIndicatorItem({
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
