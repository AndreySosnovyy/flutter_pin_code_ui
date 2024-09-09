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

  final pinTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Spacer(flex: 3),
            PinIndicator(
              length: 4,
              currentLength: pinTextController.text.length,
              isError: false,
              isSuccess: false,
            ),
            const SizedBox(height: 64),
            Pinpad(
              onKeyTap: (key) {
                pinTextController.text += key;
                setState(() {});
              },
              keysTextStyle: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 32),
              keyDefaultDecoration: defaultDecoration,
              keyPressedDecoration: pressedDecoration,
              keyDisabledDecoration: disabledDecoration,
              leftExtraKeyChild: Center(
                child: Text(
                  'Extra key',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              rightExtraKeyChild: pinTextController.text.isEmpty
                  ? GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        // Call your biometrics method here
                      },
                      // Display current biometrics type here
                      child: const Icon(Icons.fingerprint_rounded, size: 32),
                    )
                  : GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        pinTextController.text = pinTextController.text
                            .substring(0, pinTextController.text.length - 1);
                        setState(() {});
                      },
                      child: const Icon(Icons.backspace_outlined, size: 24),
                    ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
