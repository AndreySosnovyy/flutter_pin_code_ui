import 'package:flutter/cupertino.dart';

class EraseDeflateTransition extends StatelessWidget {
  const EraseDeflateTransition({
    required this.child,
    required this.animation,
    super.key,
  });

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }
}
