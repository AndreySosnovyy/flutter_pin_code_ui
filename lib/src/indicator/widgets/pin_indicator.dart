import 'package:flutter/material.dart';
import 'package:pin_ui/src/indicator/animation_controller.dart';
import 'package:pin_ui/src/indicator/widgets/pin_indicator_builder.dart';
import 'package:pin_ui/src/indicator/widgets/pin_indicator_item.dart';

/// {@template pin_ui.PinIndicator}
/// Simple pin indicator widget. Can be decorated using Flutter's BoxDecoration.
/// {@endtemplate}
class PinIndicator extends StatefulWidget {
  /// {@macro pin_ui.PinIndicator}
  const PinIndicator({
    required this.length,
    required this.currentLength,
    required this.isError,
    required this.isSuccess,
    this.controller,
    this.errorDecoration,
    this.successDecoration,
    this.inputDecoration,
    this.defaultDecoration,
    this.spacing = 24.0,
    this.size = 14.0,

    /// {@macro pin_ui.PinIndicator.successCollapseAnimationChild}
    this.loadingCollapseAnimationChild,

    /// {@macro pin_ui.PinIndicator.successCollapseAnimationChild}
    this.successCollapseAnimationChild,
    super.key,
  })  : assert(length >= currentLength),
        assert(length > 3),
        assert(spacing > 0),
        assert(size > 0);

  final PinIndicatorAnimationController? controller;
  final int length;
  final int currentLength;
  final bool isError;
  final bool isSuccess;
  final BoxDecoration? successDecoration;
  final BoxDecoration? errorDecoration;
  final BoxDecoration? defaultDecoration;
  final BoxDecoration? inputDecoration;
  final double spacing;
  final double size;

  /// {@macro pin_ui.PinIndicator.successCollapseAnimationChild}
  final Widget? successCollapseAnimationChild;

  /// {@macro pin_ui.PinIndicator.loadingCollapseAnimationChild}
  final Widget? loadingCollapseAnimationChild;

  @override
  State<PinIndicator> createState() => _PinIndicatorState();
}

class _PinIndicatorState extends State<PinIndicator> {
  BoxDecoration get successDecoration =>
      widget.successDecoration ??
      const BoxDecoration(shape: BoxShape.circle, color: Colors.green);

  BoxDecoration get errorDecoration =>
      widget.errorDecoration ??
      const BoxDecoration(shape: BoxShape.circle, color: Colors.red);

  BoxDecoration get defaultDecoration =>
      widget.defaultDecoration ??
      const BoxDecoration(shape: BoxShape.circle, color: Colors.black12);

  BoxDecoration get inputDecoration =>
      widget.inputDecoration ??
      const BoxDecoration(shape: BoxShape.circle, color: Colors.blue);

  @override
  Widget build(BuildContext context) {
    return PinIndicatorBuilder(
      length: widget.length,
      currentLength: widget.currentLength,
      isError: widget.isError,
      isSuccess: widget.isSuccess,
      errorItemBuilder: (_) => PinIndicatorItem(
        size: widget.size,
        decoration: errorDecoration,
      ),
      successItemBuilder: (_) => PinIndicatorItem(
        size: widget.size,
        decoration: successDecoration,
      ),
      inputItemBuilder: (_) => PinIndicatorItem(
        size: widget.size,
        decoration: inputDecoration,
      ),
      defaultItemBuilder: (_) => PinIndicatorItem(
        size: widget.size,
        decoration: defaultDecoration,
      ),
      controller: widget.controller,
      spacing: widget.spacing,
      size: widget.size,
      loadingCollapseAnimationChild: widget.loadingCollapseAnimationChild,
      successCollapseAnimationChild: widget.successCollapseAnimationChild,
    );
  }
}
