import 'package:flutter/material.dart';
import 'package:pin_ui/pin_ui.dart';

class GlassPinIndicator extends StatelessWidget {
  const GlassPinIndicator({
    required this.controller,
    required this.length,
    required this.currentLength,
    required this.isError,
    required this.isSuccess,
    super.key,
  });

  final PinIndicatorAnimationController controller;
  final int length;
  final int currentLength;
  final bool isError;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    return PinIndicatorBuilder(
      length: length,
      currentLength: currentLength,
      isError: isError,
      isSuccess: isSuccess,
      errorItemBuilder: (_) => const SizedBox(),
      successItemBuilder: (_) => const SizedBox(),
      inputItemBuilder: (_) => const SizedBox(),
      defaultItemBuilder: (_) => const SizedBox(width: 14),
    );
  }
}
