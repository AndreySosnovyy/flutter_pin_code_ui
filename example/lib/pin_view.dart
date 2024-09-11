import 'package:flutter/material.dart';
import 'package:pin_ui/pin_ui.dart';

class PinView extends StatefulWidget {
  const PinView({super.key});

  @override
  State<PinView> createState() => _PinViewState();
}

class _PinViewState extends State<PinView> with TickerProviderStateMixin {
  final defaultDecoration = const BoxDecoration();
  final pressedDecoration = const BoxDecoration();
  final disabledDecoration = const BoxDecoration();

  late final animationController = PinIndicatorAnimationController(vsync: this);
  String pinText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Spacer(flex: 3),
            PinIndicator(
              controller: animationController,
              length: 4,
              currentLength: pinText.length,
              isError: false,
              isSuccess: false,
            ),
            const SizedBox(height: 64),
            Pinpad(
              onKeyTap: (key) async {
                pinText += key;
                setState(() {});
                await animationController.animateInput(
                    currentLength: pinText.length);
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
              rightExtraKeyChild: pinText.isEmpty
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
                      onTap: () async {
                        pinText = pinText.substring(0, pinText.length - 1);
                        setState(() {});
                        await animationController.animateErase(
                            currentLength: pinText.length);
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
