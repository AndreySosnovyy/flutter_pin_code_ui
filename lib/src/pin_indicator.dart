import 'package:flutter/material.dart';

class PinIndicator extends StatelessWidget {
  const PinIndicator({
    required this.length,
    required this.currentLength,
    required this.isError,
    required this.isSuccess,
    this.errorColor = Colors.red,
    this.successColor = Colors.green,
    this.inputColor = Colors.blue,
    this.defaultColor = Colors.black12,
    this.spacing = 24.0,
    this.size = 16.0,
    super.key,
  });

  final int length;
  final int currentLength;
  final bool isError;
  final bool isSuccess;
  final Color successColor;
  final Color errorColor;
  final Color defaultColor;
  final Color inputColor;
  final double spacing;
  final double size;

  Color _getColorForIndex(int index) {
    if (isSuccess) return successColor;
    if (isError) return errorColor;
    if (index < currentLength) return inputColor;
    return defaultColor;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < length; i++)
          Padding(
            padding: EdgeInsets.only(right: i == length - 1 ? 0 : spacing),
            child: SizedBox(
              width: size,
              height: size,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getColorForIndex(i),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
