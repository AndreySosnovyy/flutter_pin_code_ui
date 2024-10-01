import 'package:flutter/material.dart';

/// Pin indicator item builder function.
typedef PinIndicatorItemBuilder = Widget Function(int index);

/// {@template pin_ui.NoAnimationPinIndicator}
/// Static version of PinIndicator widget.
/// {@endtemplate}
class NoAnimationPinIndicator extends StatelessWidget {
  /// {@macro pin_ui.NoAnimationPinIndicator}
  const NoAnimationPinIndicator({
    required this.spacing,
    required this.length,
    required this.builder,
    super.key,
  });

  /// Number of items in the indicator.
  final int length;

  /// Spacing between items.
  final double spacing;

  /// Pin indicator item builder.
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
