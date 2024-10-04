import 'package:flutter/cupertino.dart';

// ignore_for_file: public_member_api_docs

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
