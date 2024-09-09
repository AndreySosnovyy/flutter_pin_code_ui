import 'package:flutter/material.dart';
import 'package:pin_ui/src/pinpad_key.dart';

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
    this.keysTextStyle,
    this.keyHeight,
    this.keyWidth,
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
  final TextStyle? keysTextStyle;
  final double? keyWidth;
  final double? keyHeight;

  double _getDefaultSpacing(BuildContext context) =>
      (MediaQuery.of(context).size.width - _getMaxKeyTextWidth(context) * 3) /
      4;

  double _getHorizontalSpacing(BuildContext context) =>
      horizontalSpacing ?? _getDefaultSpacing(context);

  double _getVerticalSpacing(BuildContext context) =>
      verticalSpacing ?? _getDefaultSpacing(context) / 2;

  TextStyle? _getTextStyle(BuildContext context) =>
      keysTextStyle ?? Theme.of(context).textTheme.titleLarge;

  BoxDecoration? get _defaultDecoration =>
      enabled ? keyDefaultDecoration : keyDisabledDecoration;

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

  double _getKeyTextHeight(BuildContext context) =>
      _getKeyTextSize(context, '0').height;

  double _getKeyHeight(BuildContext context) =>
      keyHeight ?? _getKeyTextHeight(context);

  double _getKeyWidth(BuildContext context) =>
      keyWidth ?? _getMaxKeyTextWidth(context);

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
                      child: PinpadKey.text(
                        (3 * i + j + 1).toString(),
                        textStyle: _getTextStyle(context),
                        onTap: () => onKeyTap((3 * i + j + 1).toString()),
                        decoration: _defaultDecoration,
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
              PinpadKey.text(
                '0',
                textStyle: _getTextStyle(context),
                onTap: () => onKeyTap('0'),
                decoration: _defaultDecoration,
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
