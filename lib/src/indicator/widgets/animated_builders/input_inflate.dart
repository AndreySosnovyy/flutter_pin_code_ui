import 'package:flutter/material.dart';

class InputInflateAnimated extends StatefulWidget {
  const InputInflateAnimated({
    required this.child,
    required this.duration,
    super.key,
  });

  final Widget child;
  final Duration duration;

  @override
  State<InputInflateAnimated> createState() => _InputInflateAnimatedState();
}

class _InputInflateAnimatedState extends State<InputInflateAnimated>
    with SingleTickerProviderStateMixin {
  late final animation = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
    lowerBound: 1.0,
    upperBound: 1.3,
  );

  @override
  void initState() {
    animation.animateTo(animation.upperBound, curve: Curves.ease).then(
        (_) => animation.animateTo(animation.lowerBound, curve: Curves.easeIn));
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
