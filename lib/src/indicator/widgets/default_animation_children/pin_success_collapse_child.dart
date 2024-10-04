import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore_for_file: public_member_api_docs

class DefaultPinSuccessCollapseAnimationChild extends StatelessWidget {
  const DefaultPinSuccessCollapseAnimationChild({
    required this.anchorSize,
    super.key,
  });

  final double anchorSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: anchorSize * 2.3,
          height: anchorSize * 2.3,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
        Icon(
          CupertinoIcons.checkmark_alt_circle_fill,
          color: Colors.green,
          size: anchorSize * 3,
        ),
      ],
    );
  }
}
