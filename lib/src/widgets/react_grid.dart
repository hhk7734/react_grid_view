import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';

import '../rendering/react_grid.dart';

class ReactGrid extends MultiChildRenderObjectWidget {
  ReactGrid({
    Key key,
    @required this.crossAxisCount,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.gridAspectRatio = 1.0,
    List<Widget> children = const <Widget>[],
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.overflow = Overflow.clip,
    this.controller,
  }) : super(key: key, children: children);

  final AlignmentGeometry alignment;

  final TextDirection textDirection;

  final Overflow overflow;

  final int crossAxisCount;

  final double mainAxisSpacing;

  final double crossAxisSpacing;

  /// gridAspectRatio == crossAxisStride / mainAxisStride
  final double gridAspectRatio;

  final ScrollController controller;

  @override
  RenderReactGrid createRenderObject(BuildContext context) {
    return RenderReactGrid(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      gridAspectRatio: gridAspectRatio,
      alignment: alignment,
      textDirection: textDirection ?? Directionality.of(context),
      overflow: overflow,
      controller: controller,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderReactGrid renderObject) {
    renderObject
      ..crossAxisCount = crossAxisCount
      ..mainAxisSpacing = mainAxisSpacing
      ..crossAxisSpacing = crossAxisSpacing
      ..gridAspectRatio = gridAspectRatio
      ..alignment = alignment
      ..textDirection = textDirection ?? Directionality.of(context)
      ..overflow = overflow;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('crossAxisCount', crossAxisCount));
    properties.add(DoubleProperty('mainAxisSpacing', mainAxisSpacing));
    properties.add(DoubleProperty('crossAxisSpacing', crossAxisSpacing));
    properties.add(DoubleProperty('gridAspectRatio', gridAspectRatio));
    properties
        .add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection,
        defaultValue: null));
    properties.add(EnumProperty<Overflow>('overflow', overflow));
  }
}

class ReactPositioned extends StatefulWidget {
  const ReactPositioned({
    Key key,
    @required this.crossAxisOffsetCellCount,
    @required this.mainAxisOffsetCellCount,
    @required this.crossAxisCellCount,
    @required this.mainAxisCellCount,
    @required this.child,
  }) : super(key: key);

  final int crossAxisOffsetCellCount;

  final int mainAxisOffsetCellCount;

  final int crossAxisCellCount;

  final int mainAxisCellCount;

  final Widget child;

  @override
  _ReactPositionedState createState() => _ReactPositionedState();
}

class _ReactPositionedState extends State<ReactPositioned> {
  double left;

  double top;

  Widget child;

  double width;

  double height;

  @override
  void initState() {
    super.initState();
    child = GestureDetector(
      child: widget.child,
      onLongPressStart: (details) {
        RenderObject renderObject = context.findRenderObject();
        ReactGridParentData parentData = renderObject.parentData;
        parentData.onDragging = true;
        parentData.left = details.globalPosition.dx - parentData.width / 2;
        left = parentData.left;
        parentData.top = details.globalPosition.dy -
            parentData.height / 2 +
            parentData.controller.offset;
        top = parentData.top;
        setState(() {});
      },
      onLongPressMoveUpdate: (details) {
        RenderObject renderObject = context.findRenderObject();
        ReactGridParentData parentData = renderObject.parentData;
        parentData.left = details.globalPosition.dx - parentData.width / 2;
        left = parentData.left;
        parentData.top = details.globalPosition.dy -
            parentData.height / 2 +
            parentData.controller.offset;
        top = parentData.top;
        setState(() {});
      },
      onLongPressEnd: (details) {
        RenderObject renderObject = context.findRenderObject();
        ReactGridParentData parentData = renderObject.parentData;
        parentData.onDragging = false;
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _WrapReactPositioned(
      crossAxisOffsetCellCount: widget.crossAxisOffsetCellCount,
      mainAxisOffsetCellCount: widget.mainAxisOffsetCellCount,
      crossAxisCellCount: widget.crossAxisCellCount,
      mainAxisCellCount: widget.mainAxisCellCount,
      left: left,
      top: top,
      width: width,
      height: height,
      child: child,
    );
  }
}

class _WrapReactPositioned extends ParentDataWidget<ReactGridParentData> {
  const _WrapReactPositioned({
    Key key,
    @required this.crossAxisOffsetCellCount,
    @required this.mainAxisOffsetCellCount,
    @required this.crossAxisCellCount,
    @required this.mainAxisCellCount,
    @required this.left,
    @required this.top,
    @required this.width,
    @required this.height,
    @required Widget child,
  }) : super(key: key, child: child);

  final int crossAxisOffsetCellCount;

  final int mainAxisOffsetCellCount;

  final int crossAxisCellCount;

  final int mainAxisCellCount;

  final double left;

  final double top;

  final double width;

  final double height;

  /// Write the current data of this widget into the given render object's
  /// parent data.
  ///
  /// The framework calls this function whenever it detects that the
  /// [RenderObject] associated with the [child] has outdated
  /// [RenderObject.parentData].
  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is ReactGridParentData);
    final ReactGridParentData oldParentData =
        renderObject.parentData as ReactGridParentData;
    bool needsLayout = false;

    if (oldParentData.crossAxisOffsetCellCount != crossAxisOffsetCellCount) {
      oldParentData.crossAxisOffsetCellCount = crossAxisOffsetCellCount;
      needsLayout = true;
    }

    if (oldParentData.mainAxisOffsetCellCount != mainAxisOffsetCellCount) {
      oldParentData.mainAxisOffsetCellCount = mainAxisOffsetCellCount;
      needsLayout = true;
    }

    if (oldParentData.crossAxisCellCount != crossAxisCellCount) {
      oldParentData.crossAxisCellCount = crossAxisCellCount;
      needsLayout = true;
    }

    if (oldParentData.mainAxisCellCount != mainAxisCellCount) {
      oldParentData.mainAxisCellCount = mainAxisCellCount;
      needsLayout = true;
    }

    if (oldParentData.left != left) {
      oldParentData.left = left;
      needsLayout = true;
    }
    if (oldParentData.top != top) {
      oldParentData.top = top;
      needsLayout = true;
    }
    if (oldParentData.width != width) {
      oldParentData.width = width;
      needsLayout = true;
    }
    if (oldParentData.width != width) {
      oldParentData.width = width;
      needsLayout = true;
    }

    if (needsLayout) {
      final AbstractNode targetParent = renderObject.parent;
      if (targetParent is RenderObject) targetParent.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => ReactGrid;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty(
        'crossAxisOffsetCellCount', crossAxisOffsetCellCount,
        defaultValue: null));
    properties.add(IntProperty(
        'mainAxisOffsetCellCount', mainAxisOffsetCellCount,
        defaultValue: null));
    properties.add(IntProperty('crossAxisCellCount', crossAxisCellCount,
        defaultValue: null));
    properties.add(IntProperty('mainAxisCellCount', mainAxisCellCount,
        defaultValue: null));
  }
}
