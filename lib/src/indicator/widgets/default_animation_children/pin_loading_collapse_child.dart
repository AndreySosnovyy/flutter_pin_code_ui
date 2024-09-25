import 'package:flutter/cupertino.dart';

class DefaultPinLoadingCollapseAnimationChild extends StatelessWidget {
  const DefaultPinLoadingCollapseAnimationChild({
    required this.anchorSize,
    super.key,
  });

  final double anchorSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: anchorSize,
      height: anchorSize,
      margin: EdgeInsets.only(top: anchorSize),
      child: CupertinoActivityIndicator(radius: anchorSize),
    );
  }
}
