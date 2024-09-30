import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_ui/pin_ui.dart';

final pinIndicatorAnimationController = PinIndicatorAnimationController();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await pinIndicatorAnimationController.initialize();
  runApp(const App());
}

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
  Timer? idleTimer;

  // Current entered pin code
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
    if (idleTimer != null && idleTimer!.isActive) idleTimer!.cancel();
    idleTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => pinIndicatorAnimationController.animateIdle(
        animation: (List.from(PinIdleAnimation.values)..shuffle()).first,
      ),
    );
  }

  void clear() => setState(() {
        pinText = '';
        isPinError = false;
      });

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
                    onKeyTap: (key) {
                      restartIdleTimer();
                      if (pinIndicatorAnimationController
                          .isAnimatingNonInterruptible) {
                        return;
                      } else {
                        pinIndicatorAnimationController.stop();
                      }
                      if (pinText.length < validPin.length) {
                        setState(() => pinText += key);
                        pinIndicatorAnimationController.animateInput(
                          vibration: true,
                        );
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
                          onInterrupt: clear,
                        );
                        pinIndicatorAnimationController.animateClear(
                          animation: PinClearAnimation.fade,
                          onComplete: clear,
                          onInterrupt: clear,
                        );
                      }
                    },
                    enabled: !pinIndicatorAnimationController
                        .isAnimatingNonInterruptible,
                    vibrationEnabled: false,
                    leftExtraKeyChild: PinpadExtraKey(
                      child: Text(
                        'Forgot',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: !pinIndicatorAnimationController
                                    .isAnimatingNonInterruptible
                                ? null
                                : Colors.black26),
                      ),
                      onTap: () {
                        restartIdleTimer();
                        if (pinText.isEmpty ||
                            pinIndicatorAnimationController.isAnimatingClear ||
                            pinIndicatorAnimationController.isAnimatingError) {
                          return;
                        }
                        pinIndicatorAnimationController.animateClear(
                          onComplete: clear,
                          onInterrupt: clear,
                        );
                        // Call your forgot pin flow logic
                      },
                    ),
                    rightExtraKeyChild: PinpadExtraKey(
                      child: pinText.isEmpty ||
                              pinIndicatorAnimationController.isAnimatingClear
                          // Display your current biometrics type icon here
                          ? const Icon(Icons.fingerprint_rounded, size: 32)
                          : Icon(
                              Icons.backspace_outlined,
                              size: 24,
                              color: !pinIndicatorAnimationController
                                      .isAnimatingNonInterruptible
                                  ? null
                                  : Colors.black26,
                            ),
                      onTap: pinText.isEmpty ||
                              pinIndicatorAnimationController.isAnimatingClear
                          ? () {
                              restartIdleTimer();
                              // Call your biometrics method here
                            }
                          : () {
                              restartIdleTimer();
                              pinText =
                                  pinText.substring(0, pinText.length - 1);
                              setState(() {});
                              pinIndicatorAnimationController.animateErase();
                            },
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
    idleTimer?.cancel();
    idleTimer = null;
    super.dispose();
  }
}
