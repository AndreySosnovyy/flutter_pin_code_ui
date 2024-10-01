import 'package:flutter/material.dart';

/// {@template pin_ui.PinIndicatorItem}
/// Simple in indicator item that can be customized with [decoration] and [size].
/// {@endtemplate}
class PinIndicatorItem extends StatelessWidget {
  /// {@macro pin_ui.PinIndicatorItem}
  const PinIndicatorItem({
    required this.decoration,
    required this.size,
    super.key,
  });

  /// Item's decoration.
  final BoxDecoration decoration;

  /// Item's size.
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
