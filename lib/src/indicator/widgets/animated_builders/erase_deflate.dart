import 'package:flutter/cupertino.dart';

class EraseDeflateAnimated extends StatefulWidget {
  const EraseDeflateAnimated({
    required this.child,
    required this.duration,
    super.key,
  });

  final Duration duration;
  final Widget child;

  @override
  State<EraseDeflateAnimated> createState() => _EraseDeflateAnimatedState();
}

class _EraseDeflateAnimatedState extends State<EraseDeflateAnimated>
    with SingleTickerProviderStateMixin {
  late final animation = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
    lowerBound: 0.9,
    upperBound: 1.0,
    value: 1.0,
  );

  @override
  void initState() {
    animation.animateTo(animation.lowerBound, curve: Curves.easeOutQuint).then(
        (_) => animation.animateTo(animation.upperBound, curve: Curves.linear));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: widget.child,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: child,
        );
      },
    );
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }
}
