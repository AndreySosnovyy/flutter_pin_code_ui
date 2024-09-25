import 'package:flutter/cupertino.dart';

class PinpadExtraKey {
  PinpadExtraKey({
    required this.child,
    required this.onTap,
  });

  final Widget child;
  final void Function() onTap;
}
