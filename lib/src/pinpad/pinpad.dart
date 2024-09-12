import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_ui/src/pinpad/pinpad_key.dart';
import 'package:vibration/vibration.dart';

class Pinpad extends StatelessWidget {
  const Pinpad({
    required this.onKeyTap,
    this.keyDefaultDecoration,
    this.keyPressedDecoration,
    this.keyDisabledDecoration,
    this.horizontalSpacing,
    this.verticalSpacing,
    this.enabled = true,
    this.rightExtraKeyChild,
    this.leftExtraKeyChild,
    this.keysDefaultTextStyle,
    this.keysPressedTextStyle,
    this.keysDisabledTextStyle,
    this.keyHeight,
    this.keyWidth,
    this.vibrationEnabled = false,
    super.key,
  });

  final Function(String key) onKeyTap;
  final BoxDecoration? keyDefaultDecoration;
  final BoxDecoration? keyPressedDecoration;
  final BoxDecoration? keyDisabledDecoration;
  final double? verticalSpacing;
  final double? horizontalSpacing;
  final bool enabled;
  final Widget? rightExtraKeyChild;
  final Widget? leftExtraKeyChild;
  final TextStyle? keysDefaultTextStyle;
  final TextStyle? keysPressedTextStyle;
  final TextStyle? keysDisabledTextStyle;
  final double? keyWidth;
  final double? keyHeight;
  final bool vibrationEnabled;

  BoxDecoration? get _getDecoration =>
      enabled ? keyDefaultDecoration : keyDisabledDecoration;

  TextStyle? _getTextStyle(BuildContext context) =>
      (enabled ? keysDefaultTextStyle : keysDisabledTextStyle) ??
      Theme.of(context).textTheme.titleLarge;

  double _getDefaultSpacing(BuildContext context) =>
      (MediaQuery.of(context).size.width - _getMaxKeyTextWidth(context) * 3) /
      4;

  double _getHorizontalSpacing(BuildContext context) =>
      horizontalSpacing ??
      _getDefaultSpacing(context) - 2 * _getMaxKeyTextWidth(context);

  double _getVerticalSpacing(BuildContext context) =>
      verticalSpacing ??
      _getDefaultSpacing(context) / 2 - 0.4 * _getKeyHeight(context);

  Size _getKeyTextSize(BuildContext context, String keyText) => (TextPainter(
        text: TextSpan(text: keyText, style: _getTextStyle(context)),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout(minWidth: 0, maxWidth: double.infinity))
          .size;

  double _getMaxKeyTextWidth(BuildContext context) {
    if (keyWidth != null) return keyWidth!;
    double max = 0;
    for (int i = 0; i < 10; i++) {
      final double width = _getKeyTextSize(context, i.toString()).width;
      if (width > max) max = width;
    }
    return max;
  }

  double _getKeyHeight(BuildContext context) =>
      keyHeight ?? _getKeyTextSize(context, '0').height * 1.4;

  double _getKeyWidth(BuildContext context) =>
      keyWidth ?? _getMaxKeyTextWidth(context) * 3;

  Future<void> vibrate() async => HapticFeedback.mediumImpact();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: Column(
        children: [
          for (int i = 0; i < 3; i++)
            Padding(
              padding: EdgeInsets.only(bottom: _getVerticalSpacing(context)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int j = 0; j < 3; j++)
                    Padding(
                      padding: EdgeInsets.only(
                          right: j == 2 ? 0 : _getHorizontalSpacing(context)),
                      child: PinpadTextKey(
                        (3 * i + j + 1).toString(),
                        defaultTextStyle: _getTextStyle(context),
                        pressedTextStyle: keysPressedTextStyle,
                        onTap: () {
                          onKeyTap((3 * i + j + 1).toString());
                          if (vibrationEnabled) vibrate();
                        },
                        decoration: _getDecoration,
                        pressedDecoration: keyPressedDecoration,
                        width: _getKeyWidth(context),
                        height: _getKeyHeight(context),
                      ),
                    ),
                ],
              ),
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: _getKeyWidth(context),
                height: _getKeyHeight(context),
                child: leftExtraKeyChild,
              ),
              SizedBox(width: _getHorizontalSpacing(context)),
              PinpadTextKey(
                '0',
                defaultTextStyle: _getTextStyle(context),
                pressedTextStyle: keysPressedTextStyle,
                onTap: () {
                  onKeyTap('0');
                  if (vibrationEnabled) vibrate();
                },
                decoration: _getDecoration,
                pressedDecoration: keyPressedDecoration,
                width: _getKeyWidth(context),
                height: _getKeyHeight(context),
              ),
              SizedBox(width: _getHorizontalSpacing(context)),
              SizedBox(
                width: _getKeyWidth(context),
                height: _getKeyHeight(context),
                child: rightExtraKeyChild,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
