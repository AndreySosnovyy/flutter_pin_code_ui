import 'package:flutter/material.dart';
import 'package:pin_ui/src/pinpad_key.dart';

class Pinpad extends StatelessWidget {
  const Pinpad({
    required this.onKeyTap,
    required this.onEraseButtonTap,
    this.eraseKeyPosition = EraseKeyPosition.right,
    this.onBiometricsButtonTap,
    this.keyDefaultDecoration,
    this.keyPressedDecoration,
    this.horizontalSpacing = 24,
    this.verticalSpacing = 24,
    this.enabled = true,
    this.eraseKeyChild,
    super.key,
  });

  final Function(String text) onKeyTap;
  final VoidCallback onEraseButtonTap;
  final VoidCallback? onBiometricsButtonTap;
  final EraseKeyPosition eraseKeyPosition;
  final BoxDecoration? keyDefaultDecoration;
  final BoxDecoration? keyPressedDecoration;
  final double verticalSpacing;
  final double horizontalSpacing;
  final bool enabled;
  final Widget? eraseKeyChild;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < 3; i++)
          Padding(
            padding: EdgeInsets.only(bottom: verticalSpacing),
            child: Row(
              children: [
                for (int j = 0; j < 3; j++)
                  Padding(
                    padding: j == 2
                        ? EdgeInsets.zero
                        : EdgeInsets.only(right: horizontalSpacing),
                    child: PinpadKey.text(
                      (3 * i + j + 1).toString(),
                      onTap: () => onKeyTap((3 * i + j + 1).toString()),
                      defaultDecoration: keyDefaultDecoration,
                      pressedDecoration: keyPressedDecoration,
                    ),
                  ),
              ],
            ),
          ),
        Row(
          children: [
            PinpadKey(
              onTap: () {},
              defaultDecoration: keyDefaultDecoration,
              pressedDecoration: keyPressedDecoration,
              child: const SizedBox(),
            ),
            SizedBox(width: horizontalSpacing),
            PinpadKey.text(
              '0',
              onTap: () {},
              defaultDecoration: keyDefaultDecoration,
              pressedDecoration: keyPressedDecoration,
            ),
            SizedBox(width: horizontalSpacing),
            PinpadKey(
              onTap: () {},
              defaultDecoration: keyDefaultDecoration,
              pressedDecoration: keyPressedDecoration,
              child: eraseKeyChild ?? const Icon(Icons.backspace_rounded),
            ),
          ],
        ),
      ],
    );
  }
}

enum EraseKeyPosition { left, right }
