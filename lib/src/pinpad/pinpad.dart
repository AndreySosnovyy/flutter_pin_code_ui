import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_ui/src/pinpad/models/extra_key.dart';
import 'package:pin_ui/src/pinpad/pinpad_key.dart';

class Pinpad extends StatefulWidget {
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

  /// Data for widget that will be displayed on the right side of zero key button.
  final PinpadExtraKey? rightExtraKeyChild;

  /// Data for widget that will be displayed on the left side of zero key button.
  final PinpadExtraKey? leftExtraKeyChild;
  final TextStyle? keysDefaultTextStyle;
  final TextStyle? keysPressedTextStyle;
  final TextStyle? keysDisabledTextStyle;
  final double? keyWidth;
  final double? keyHeight;
  final bool vibrationEnabled;
  final bool isVisible;

  @override
  State<Pinpad> createState() => _PinpadState();
}

class _PinpadState extends State<Pinpad> {
  bool isAnyKeyPressed = false;

  BoxDecoration _getDefaultDecoration(BuildContext context) =>
      widget.keyDefaultDecoration ??
      const BoxDecoration(shape: BoxShape.circle);

  BoxDecoration _getPressedDecoration(BuildContext context) =>
      widget.keyPressedDecoration ??
      _getDefaultDecoration(context).copyWith(
        color: Colors.blue.withOpacity(0.1),
      );

  BoxDecoration _getDisabledDecoration(BuildContext context) =>
      widget.keyDisabledDecoration ?? _getDefaultDecoration(context);

  TextStyle _getDefaultTextStyle(BuildContext context) =>
      widget.keysDefaultTextStyle ??
      Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 32);

  TextStyle _getDisabledTextStyle(BuildContext context) =>
      widget.keysDisabledTextStyle ??
      _getDefaultTextStyle(context).copyWith(color: Colors.black26);

  TextStyle _getPressedTextStyle(BuildContext context) =>
      widget.keysPressedTextStyle ?? _getDefaultTextStyle(context);

  double _getDefaultSpacing(BuildContext context) =>
      (MediaQuery.of(context).size.width - _getMaxKeyTextWidth(context) * 3) /
      4;

  double _getHorizontalSpacing(BuildContext context) =>
      widget.horizontalSpacing ??
      _getDefaultSpacing(context) - 2 * _getMaxKeyTextWidth(context);

  double _getVerticalSpacing(BuildContext context) =>
      widget.verticalSpacing ??
      _getDefaultSpacing(context) / 2 - 0.4 * _getKeyHeight(context);

  Size _getKeyTextSize(BuildContext context, String keyText) => (TextPainter(
        text: TextSpan(text: keyText, style: _getDefaultTextStyle(context)),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout(minWidth: 0, maxWidth: double.infinity))
          .size;

  double _getMaxKeyTextWidth(BuildContext context) {
    if (widget.keyWidth != null) return widget.keyWidth!;
    double max = 0;
    for (int i = 0; i < 10; i++) {
      final double width = _getKeyTextSize(context, i.toString()).width;
      if (width > max) max = width;
    }
    return max;
  }

  double _getKeyHeight(BuildContext context) =>
      widget.keyHeight ?? _getKeyTextSize(context, '0').height * 1.4;

  double _getKeyWidth(BuildContext context) =>
      widget.keyWidth ?? _getMaxKeyTextWidth(context) * 3;

  Future<void> vibrate() async => HapticFeedback.lightImpact();

  void onAnyKeyTap() => setState(() => isAnyKeyPressed = true);

  void onAnyKeyReleased() => setState(() => isAnyKeyPressed = false);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: widget.isVisible,
      child: IgnorePointer(
        ignoring: !widget.enabled || isAnyKeyPressed,
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
                          onTapStart: onAnyKeyTap,
                          onTapEnd: onAnyKeyReleased,
                          defaultTextStyle: _getDefaultTextStyle(context),
                          disabledTextStyle: _getDisabledTextStyle(context),
                          pressedTextStyle: _getPressedTextStyle(context),
                          onTap: () {
                            widget.onKeyTap((3 * i + j + 1).toString());
                            if (widget.vibrationEnabled) vibrate();
                          },
                          enabled: widget.enabled,
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
                widget.leftExtraKeyChild != null
                    ? PinpadKey(
                        width: _getKeyWidth(context),
                        height: _getKeyHeight(context),
                        defaultDecoration: _getDefaultDecoration(context),
                        pressedDecoration: _getPressedDecoration(context),
                        disabledDecoration: _getDisabledDecoration(context),
                        enabled: widget.enabled,
                        onTapStart: onAnyKeyTap,
                        onTapEnd: onAnyKeyReleased,
                        onTap: widget.leftExtraKeyChild!.onTap,
                        child: widget.leftExtraKeyChild!.child,
                      )
                    : SizedBox(
                        width: _getKeyWidth(context),
                        height: _getKeyHeight(context),
                      ),
                SizedBox(width: _getHorizontalSpacing(context)),
                PinpadTextKey(
                  '0',
                  defaultTextStyle: _getDefaultTextStyle(context),
                  disabledTextStyle: _getDisabledTextStyle(context),
                  pressedTextStyle: _getPressedTextStyle(context),
                  onTapStart: onAnyKeyTap,
                  onTapEnd: onAnyKeyReleased,
                  onTap: () {
                    widget.onKeyTap('0');
                    if (widget.vibrationEnabled) vibrate();
                  },
                  enabled: widget.enabled,
                  defaultDecoration: _getDefaultDecoration(context),
                  disabledDecoration: _getDisabledDecoration(context),
                  pressedDecoration: _getPressedDecoration(context),
                  width: _getKeyWidth(context),
                  height: _getKeyHeight(context),
                ),
                SizedBox(width: _getHorizontalSpacing(context)),
                widget.rightExtraKeyChild != null
                    ? PinpadKey(
                        width: _getKeyWidth(context),
                        height: _getKeyHeight(context),
                        defaultDecoration: _getDefaultDecoration(context),
                        pressedDecoration: _getPressedDecoration(context),
                        disabledDecoration: _getDisabledDecoration(context),
                        enabled: widget.enabled,
                        onTapStart: onAnyKeyTap,
                        onTapEnd: onAnyKeyReleased,
                        onTap: widget.rightExtraKeyChild!.onTap,
                        child: widget.rightExtraKeyChild!.child,
                      )
                    : SizedBox(
                        width: _getKeyWidth(context),
                        height: _getKeyHeight(context),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
