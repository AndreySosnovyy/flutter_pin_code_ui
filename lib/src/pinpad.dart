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

  double _getDefaultHorizontalSpacing(BuildContext context) =>
      horizontalSpacing ?? _getDefaultSpacing(context);

  double _getDefaultVerticalSpacing(BuildContext context) =>
      verticalSpacing ?? _getDefaultSpacing(context) / 2;

  TextStyle? _getDefaultTextStyle(BuildContext context) =>
      keysTextStyle ?? Theme.of(context).textTheme.titleLarge;

  BoxDecoration? get _defaultDecoration =>
      enabled ? keyDefaultDecoration : keyDisabledDecoration;

  double _getMaxKeyTextWidth(BuildContext context) {
    if (keyWidth != null) return keyWidth!;
    double max = 0;
    for (int i = 0; i < 10; i++) {
      final double width = (TextPainter(
        text: TextSpan(
          text: i.toString(),
          style: _getDefaultTextStyle(context),
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout(minWidth: 0, maxWidth: double.infinity))
          .size
          .width;
      if (width > max) max = width;
    }
    return max;
  }

  double _getKeyHeight(BuildContext context) =>
      keyHeight ??
      _getMaxKeyTextWidth(context) + _getDefaultVerticalSpacing(context);

  double _getKeyWidth(BuildContext context) =>
      keyWidth ??
      _getMaxKeyTextWidth(context) + _getDefaultHorizontalSpacing(context);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: Column(
        children: [
          for (int i = 0; i < 3; i++)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int j = 0; j < 3; j++)
                  PinpadKey.text(
                    (3 * i + j + 1).toString(),
                    textStyle: _getDefaultTextStyle(context),
                    onTap: () => onKeyTap((3 * i + j + 1).toString()),
                    decoration: _defaultDecoration,
                    pressedDecoration: keyPressedDecoration,
                    width: _getKeyWidth(context),
                    height: _getKeyHeight(context),
                  ),
              ],
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: _getKeyWidth(context),
                height: _getKeyHeight(context),
                child: leftExtraKeyChild,
              ),
              PinpadKey.text(
                '0',
                textStyle: _getDefaultTextStyle(context),
                onTap: () => onKeyTap('0'),
                decoration: _defaultDecoration,
                pressedDecoration: keyPressedDecoration,
                width: _getKeyWidth(context),
                height: _getKeyHeight(context),
              ),
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
