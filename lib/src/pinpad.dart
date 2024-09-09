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

  final Function(String text) onKeyTap;
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

  double _getDefaultSpacing(BuildContext context) {
    final a =
        (MediaQuery.of(context).size.width - _getMaxKeyTextWidth(context) * 3) /
            4;
    print('MediaQuery.of(context).size.width = ${MediaQuery.of(context).size.width}');
    print('a = ${a}');
    return a;
  }

  double _getDefaultHorizontalSpacing(BuildContext context) =>
      horizontalSpacing ?? _getDefaultSpacing(context);

  double _getDefaultVerticalSpacing(BuildContext context) =>
      verticalSpacing ?? _getDefaultSpacing(context);

  TextStyle? _getDefaultTextStyle(BuildContext context) =>
      keysTextStyle ?? Theme.of(context).textTheme.titleLarge;

  BoxDecoration? get _defaultDecoration =>
      enabled ? keyDefaultDecoration : keyDisabledDecoration;

  double _getMaxKeyTextWidth(BuildContext context) {
    double getKeyWidth(String keyText) => (TextPainter(
          text: TextSpan(text: keyText, style: _getDefaultTextStyle(context)),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(minWidth: 0, maxWidth: double.infinity))
            .size
            .width;

    double max = 0;
    for (int i = 0; i < 10; i++) {
      final double width = getKeyWidth((i).toString());
      if (width > max) max = width;
    }
    return max;
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: Column(
        children: [
          for (int i = 0; i < 3; i++)
            Padding(
              padding:
                  EdgeInsets.only(bottom: _getDefaultVerticalSpacing(context)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int j = 0; j < 3; j++)
                    Container(
                      color: Colors.red,
                      padding: j == 2
                          ? EdgeInsets.zero
                          : EdgeInsets.only(
                              right: _getDefaultHorizontalSpacing(context)),
                      child: PinpadKey.text(
                        (3 * i + j + 1).toString(),
                        textStyle: _getDefaultTextStyle(context),
                        onTap: () => onKeyTap((3 * i + j + 1).toString()),
                        decoration: _defaultDecoration,
                        pressedDecoration: keyPressedDecoration,
                        width: keyWidth,
                      ),
                    ),
                ],
              ),
            ),
          // TODO(Sosnovyy): implement extra keys
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              leftExtraKeyChild ??
                  PinpadKey(
                    onTap: () {},
                    decoration: _defaultDecoration,
                    pressedDecoration: keyPressedDecoration,
                    child: const SizedBox(),
                  ),
              SizedBox(width: _getDefaultHorizontalSpacing(context)),
              PinpadKey.text(
                '0',
                textStyle: _getDefaultTextStyle(context),
                onTap: () {},
                decoration: _defaultDecoration,
                pressedDecoration: keyPressedDecoration,
              ),
              SizedBox(width: _getDefaultHorizontalSpacing(context)),
              rightExtraKeyChild ??
                  PinpadKey(
                    onTap: () {},
                    decoration: _defaultDecoration,
                    pressedDecoration: keyPressedDecoration,
                    child: const SizedBox(),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
