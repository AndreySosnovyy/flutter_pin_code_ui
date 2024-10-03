import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_ui/pin_ui.dart';

class StarPinIndicator extends StatelessWidget {
  const StarPinIndicator({
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
      controller: controller,
      length: length,
      currentLength: currentLength,
      isError: isError,
      isSuccess: isSuccess,
      errorItemBuilder: (_) => const _PinIndicatorStar(color: Colors.red),
      successItemBuilder: (_) => const _PinIndicatorStar(color: Colors.green),
      inputItemBuilder: (_) => const _PinIndicatorStar(color: Colors.blue),
      defaultItemBuilder: (_) => const _PinIndicatorStar(color: Colors.black26),
    );
  }
}

class _PinIndicatorStar extends StatelessWidget {
  const _PinIndicatorStar({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 14,
      height: 14,
      child: SvgPicture.asset(
        'assets/star.svg',
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}
