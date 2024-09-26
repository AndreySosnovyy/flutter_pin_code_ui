import 'dart:async';

import 'package:flutter/cupertino.dart';

/// Widget that builds a widget every time it is being pointed or pointer leaves the widget.
typedef PointBuilder = Widget Function(BuildContext context, bool isPointed);

///
typedef PointChangedCallback = void Function(bool isPointed);

/// {@template point_detector_builder}
/// Widget that build child via builder that rebuilds evert time it is being
/// pointed or leaved by pointer.
/// {@endtemplate}
class PointDetectorBuilder extends StatefulWidget {
  /// {@macro point_detector_builder}
  const PointDetectorBuilder({
    required this.builder,
    this.onChanged,
    this.shape = BoxShape.rectangle,
    this.placeholder,
    super.key,
  });

  /// Builder method that rebuilds widget every time it is being pointed or leaved by pointer.
  final PointBuilder builder;

  /// Callback that is called when pointer state changes.
  final PointChangedCallback? onChanged;

  /// Shape of the widget built via builder.
  final BoxShape shape;

  /// Widget that will be displayed when initial calculations are not done.
  final Widget? placeholder;

  @override
  State<PointDetectorBuilder> createState() => _PointDetectorBuilderState();
}

class _PointDetectorBuilderState extends State<PointDetectorBuilder> {
  bool _isPointed = true;

  final initializeCompleter = Completer<void>();

  Size? widgetSize;
  Offset? widgetOffset;
  Offset? pointerOffset;

  void onDragUpdate(DragUpdateDetails details) {
    updatePointerOffset(details);
    checkIfPointed();
  }

  void updatePointerOffset(DragUpdateDetails details) {
    pointerOffset = details.globalPosition;
  }

  void updateWidgetData() {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    widgetOffset = box.localToGlobal(Offset.zero);
    widgetSize = box.size;
  }

  void checkIfPointed() {
    if (pointerOffset == null || widgetSize == null || widgetOffset == null) {
      return;
    }
    final bool isPointed;
    switch (widget.shape) {
      case BoxShape.rectangle:
        isPointed = pointerOffset!.dx >= widgetOffset!.dx &&
            pointerOffset!.dx <= widgetOffset!.dx + widgetSize!.width &&
            pointerOffset!.dy >= widgetOffset!.dy &&
            pointerOffset!.dy <= widgetOffset!.dy + widgetSize!.height;
      case BoxShape.circle:
        isPointed = true;
    }
    if (_isPointed != isPointed) {
      setState(() => _isPointed = isPointed);
      widget.onChanged?.call(isPointed);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      updateWidgetData();
      setState(() => initializeCompleter.complete());
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    updateWidgetData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (!initializeCompleter.isCompleted) {
      return widget.placeholder ?? const SizedBox.shrink();
    }
    // TODO(Sosnovyy): replace current dragging logic with a complete one
    return GestureDetector(
      onVerticalDragUpdate: onDragUpdate,
      onHorizontalDragUpdate: onDragUpdate,
      child: widget.builder(context, _isPointed),
    );
  }
}
