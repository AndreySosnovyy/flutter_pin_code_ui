import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_ui/pin_ui.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: PinView());
  }
}

// Change this value to test different lengths of Pin Indicator
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
  Timer? timer;
  String pinText = '';
  bool isPinError = false;
  bool isPinSuccess = false;

  @override
  void initState() {
    super.initState();
    restartIdleTimer();
  }

  // It will start idle animation if no action has been made in 10 seconds
  void restartIdleTimer() {
    if (timer != null && timer!.isActive) timer!.cancel();
    timer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => pinIndicatorAnimationController.animateIdle(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ValueListenableBuilder(
            valueListenable: pinIndicatorAnimationController,
            builder: (context, value, child) {
              return Column(
                children: [
                  const Spacer(flex: 3),
                  PinIndicator(
                    controller: pinIndicatorAnimationController,
                    length: validPin.length,
                    currentLength: pinText.length,
                    isError: isPinError,
                    isSuccess: isPinSuccess,
                  ),
                  const SizedBox(height: 64),
                  Pinpad(
                    onKeyTap: (key) async {
                      restartIdleTimer();
                      if (pinIndicatorAnimationController
                          .isAnimatingNonInterruptible) {
                        return;
                      } else {
                        pinIndicatorAnimationController.stop();
                        setState(() => isPinError = false);
                      }
                      if (pinText.length < validPin.length) {
                        setState(() => pinText += key);
                        pinIndicatorAnimationController.animateInput();
                      }
                      if (pinText == validPin) {
                        pinIndicatorAnimationController.animateLoading(
                          repeatCount: 2,
                          delayAfterAnimation:
                              const Duration(milliseconds: 160),
                          onComplete: () => setState(() => isPinSuccess = true),
                        );
                        pinIndicatorAnimationController.animateSuccess(
                          delayBeforeAnimation:
                              const Duration(milliseconds: 480),
                          delayAfterAnimation:
                              const Duration(milliseconds: 1200),
                          onComplete: () {
                            pinText = '';
                            isPinSuccess = false;
                            setState(() {});
                          },
                        );
                      } else if (pinText.length == validPin.length) {
                        setState(() => isPinError = true);
                        pinIndicatorAnimationController.animateError(
                          delayAfterAnimation:
                              const Duration(milliseconds: 240),
                        );
                        pinIndicatorAnimationController.animateClear(
                          animation: PinClearAnimation.fade,
                          onComplete: () {
                            pinText = '';
                            isPinError = false;
                            setState(() {});
                          },
                        );
                      }
                    },
                    enabled: !pinIndicatorAnimationController
                        .isAnimatingNonInterruptible,
                    keysDefaultTextStyle: defaultTextStyle,
                    keysPressedTextStyle: pressedTextStyle,
                    keysDisabledTextStyle: disabledTextStyle,
                    keyDefaultDecoration: defaultKeyDecoration,
                    keyPressedDecoration: pressedKeyDecoration,
                    keyDisabledDecoration: disabledKeyDecoration,
                    vibrationEnabled: true,
                    leftExtraKeyChild: PinpadKey(
                      enabled: !pinIndicatorAnimationController
                          .isAnimatingNonInterruptible,
                      defaultDecoration: defaultKeyDecoration,
                      pressedDecoration: pressedKeyDecoration,
                      child: Text(
                        'Forgot',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: !pinIndicatorAnimationController
                                    .isAnimatingNonInterruptible
                                ? null
                                : Colors.black26),
                      ),
                      onTap: () async {
                        restartIdleTimer();
                        if (pinText.isNotEmpty) {
                          pinIndicatorAnimationController.animateClear();
                          setState(() => pinText = '');
                        }
                        // Call your forgot pin flow logic
                      },
                    ),
                    rightExtraKeyChild: PinpadKey(
                      enabled: !pinIndicatorAnimationController
                          .isAnimatingNonInterruptible,
                      defaultDecoration: defaultKeyDecoration,
                      pressedDecoration: pressedKeyDecoration,
                      onTap: pinText.isEmpty
                          ? () {
                              restartIdleTimer();
                              // Call your biometrics method here
                            }
                          : () async {
                              restartIdleTimer();
                              pinText =
                                  pinText.substring(0, pinText.length - 1);
                              setState(() {});
                              pinIndicatorAnimationController.animateErase();
                            },
                      child: pinText.isEmpty
                          // Display current biometrics type here
                          ? const Icon(Icons.fingerprint_rounded, size: 32)
                          : Icon(
                              Icons.backspace_outlined,
                              size: 24,
                              color: !pinIndicatorAnimationController
                                      .isAnimatingNonInterruptible
                                  ? null
                                  : Colors.black26,
                            ),
                    ),
                  ),
                  const Spacer(),
                ],
              );
            }),
      ),
    );
  }

  @override
  void dispose() {
    pinIndicatorAnimationController.dispose();
    timer?.cancel();
    timer = null;
    super.dispose();
  }
}
