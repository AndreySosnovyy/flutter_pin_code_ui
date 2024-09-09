import 'package:flutter/material.dart';
import 'package:pin_ui/pin_ui.dart';

class PinView extends StatefulWidget {
  const PinView({super.key});

  @override
  State<PinView> createState() => _PinViewState();
}

class _PinViewState extends State<PinView> {
  final defaultDecoration = const BoxDecoration();
  final pressedDecoration = const BoxDecoration();
  final disabledDecoration = const BoxDecoration();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Spacer(flex: 3),
            Pinpad(
              onKeyTap: (text) {},
              keysTextStyle: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 32),
              keyDefaultDecoration: defaultDecoration,
              keyPressedDecoration: pressedDecoration,
              keyDisabledDecoration: disabledDecoration,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
