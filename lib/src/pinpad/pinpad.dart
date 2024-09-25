import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_ui/src/pinpad/pinpad_key.dart';

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
    this.isVisible = true,
    super.key,
  });

  final Function(String key) onKeyTap;
  final BoxDecoration? keyDefaultDecoration;
  final BoxDecoration? keyPressedDecoration;
  final BoxDecoration? keyDisabledDecoration;
  final double? verticalSpacing;
  final double? horizontalSpacing;
  final bool enabled;

  /// Widget that will be displayed on the right side of zero key button.
  ///
  /// {@template pinpad.extraKeyChild}
  /// This widget is independent from other Pinpad in terms of visual appearance
  /// and only controlled from outside. In case you want to decorate it, use
  /// DecoratedBox widget when you layout this extra child.
  /// {@endtemplate}
  final Widget? rightExtraKeyChild;

  /// Widget that will be displayed on the left side of zero key button.
  ///
  /// {@macro pinpad.extraKeyChild}
  final Widget? leftExtraKeyChild;
  final TextStyle? keysDefaultTextStyle;
  final TextStyle? keysPressedTextStyle;
  final TextStyle? keysDisabledTextStyle;
  final double? keyWidth;
  final double? keyHeight;
  final bool vibrationEnabled;
  final bool isVisible;

  BoxDecoration _getDefaultDecoration(BuildContext context) =>
      keyDefaultDecoration ?? const BoxDecoration(shape: BoxShape.circle);

  BoxDecoration _getPressedDecoration(BuildContext context) =>
      keyPressedDecoration ??
      _getDefaultDecoration(context).copyWith(
        color: Colors.blue.withOpacity(0.1),
      );

  TextStyle _getDefaultTextStyle(BuildContext context) =>
      keysDefaultTextStyle ??
      Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 32);

  TextStyle _getDisabledTextStyle(BuildContext context) =>
      keysDisabledTextStyle ??
      _getDefaultTextStyle(context).copyWith(color: Colors.black26);

  TextStyle _getPressedTextStyle(BuildContext context) =>
      keysPressedTextStyle ?? _getDefaultTextStyle(context);

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
        text: TextSpan(text: keyText, style: _getDefaultTextStyle(context)),
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

  Future<void> vibrate() async => HapticFeedback.lightImpact();

  @override
  Widget build(BuildContext context) {
    return Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: isVisible,
      child: IgnorePointer(
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
                          defaultTextStyle: _getDefaultTextStyle(context),
                          disabledTextStyle: _getDisabledTextStyle(context),
                          pressedTextStyle: _getPressedTextStyle(context),
                          onTap: () {
                            onKeyTap((3 * i + j + 1).toString());
                            if (vibrationEnabled) vibrate();
                          },
                          enabled: enabled,
                          defaultDecoration: _getDefaultDecoration(context),
                          pressedDecoration: _getPressedDecoration(context),
                          disabledDecoration: _getDefaultDecoration(context),
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
                  defaultTextStyle: _getDefaultTextStyle(context),
                  disabledTextStyle: _getDisabledTextStyle(context),
                  pressedTextStyle: _getPressedTextStyle(context),
                  onTap: () {
                    onKeyTap('0');
                    if (vibrationEnabled) vibrate();
                  },
                  enabled: enabled,
                  defaultDecoration: _getDefaultDecoration(context),
                  disabledDecoration: _getDefaultDecoration(context),
                  pressedDecoration: _getPressedDecoration(context),
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
      ),
    );
  }
}
