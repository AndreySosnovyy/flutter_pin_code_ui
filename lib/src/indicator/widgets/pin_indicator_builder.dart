import 'package:flutter/material.dart';

class PinIndicatorBuilder extends StatelessWidget {
  const PinIndicatorBuilder({
    super.key,
    required this.length,
    required this.spacing,
    required this.builder,
  });

  final int length;
  final double spacing;
  final Function(BuildContext context, int index) builder;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < length; i++)
          Padding(
            padding: EdgeInsets.only(right: i == length - 1 ? 0 : spacing),
            child: builder(context, i),
          ),
      ],
    );
  }
}
