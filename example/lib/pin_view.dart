import 'package:flutter/material.dart';
import 'package:pin_ui/pin_ui.dart';

const String validPin = '1111';

class PinView extends StatefulWidget {
  const PinView({super.key});

  @override
  State<PinView> createState() => _PinViewState();
}

class _PinViewState extends State<PinView> with TickerProviderStateMixin {
  late final defaultKeyDecoration = const BoxDecoration(
    shape: BoxShape.circle,
  );
  late final pressedKeyDecoration = defaultKeyDecoration.copyWith(
    color: Colors.blue.withOpacity(0.1),
  );
  late final disabledKeyDecoration = defaultKeyDecoration.copyWith();

  late final defaultTextStyle =
      Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 32);
  late final pressedTextStyle = defaultTextStyle.copyWith(color: Colors.blue);
  late final disabledTextStyle =
      defaultTextStyle.copyWith(color: Colors.black26);

  final pinIndicatorAnimationController = PinIndicatorAnimationController();
  String pinText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            const Spacer(flex: 3),
            PinIndicator(
              controller: pinIndicatorAnimationController,
              length: validPin.length,
              currentLength: pinText.length,
              isError: false,
              isSuccess: false,
            ),
            const SizedBox(height: 64),
            Pinpad(
              onKeyTap: (key) async {
                if (pinText.length == validPin.length &&
                    pinIndicatorAnimationController.isAnimatingInput) return;
                pinText += key;
                setState(() {});
                await pinIndicatorAnimationController.animateInput();
                if (pinText == validPin) {
                  await pinIndicatorAnimationController.animateLoading();
                  await pinIndicatorAnimationController.animateSuccess();
                } else if (pinText.length == validPin.length) {
                  await pinIndicatorAnimationController.animateError();
                  await pinIndicatorAnimationController.animateClear();
                }
                if (pinText.length == validPin.length) {
                  setState(() => pinText = '');
                }
              },
              enabled:
                  !(pinIndicatorAnimationController.isAnimatingInterruptible ??
                      false),
              keysDefaultTextStyle: defaultTextStyle,
              keysPressedTextStyle: pressedTextStyle,
              keysDisabledTextStyle: disabledTextStyle,
              keyDefaultDecoration: defaultKeyDecoration,
              keyPressedDecoration: pressedKeyDecoration,
              keyDisabledDecoration: disabledKeyDecoration,
              vibrationEnabled: true,
              leftExtraKeyChild: PinpadKey(
                enabled:
                    pinIndicatorAnimationController.isAnimatingInterruptible ??
                        true,
                defaultDecoration: defaultKeyDecoration,
                pressedDecoration: pressedKeyDecoration,
                child: Text(
                  'Extra key',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onTap: () {},
              ),
              rightExtraKeyChild: PinpadKey(
                enabled:
                    pinIndicatorAnimationController.isAnimatingInterruptible ??
                        true,
                defaultDecoration: defaultKeyDecoration,
                pressedDecoration: pressedKeyDecoration,
                onTap: pinText.isEmpty
                    ? () {
                        // Call your biometrics method here
                      }
                    : () async {
                        pinText = pinText.substring(0, pinText.length - 1);
                        setState(() {});
                        await pinIndicatorAnimationController.animateErase();
                      },
                child: pinText.isEmpty
                    // Display current biometrics type here
                    ? const Icon(Icons.fingerprint_rounded, size: 32)
                    : const Icon(Icons.backspace_outlined, size: 24),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    pinIndicatorAnimationController.dispose();
    super.dispose();
  }
}
