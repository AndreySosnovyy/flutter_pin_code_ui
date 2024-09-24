import 'package:flutter/material.dart';

typedef PinIndicatorItemBuilder = Widget Function(int index);

class NoAnimationPinIndicator extends StatelessWidget {
  const NoAnimationPinIndicator({
    required this.spacing,
    required this.length,
    required this.builder,
    super.key,
  });

  final int length;
  final double spacing;

  final PinIndicatorItemBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(length, builder)
          .expand((e) => [e, SizedBox(width: spacing)])
          .toList()
        ..removeLast(),
    );
  }
}
