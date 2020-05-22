import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';

import '../rendering/render_react_grid.dart';

part './react_grid_element.dart';

class ReactGrid extends RenderObjectWidget {
  ReactGrid({
    Key key,
    @required this.crossAxisCount,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.gridAspectRatio = 1.0,
    this.children = const <Widget>[],
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
  })  : assert(children != null),
        assert(() {
          final int index = children.indexOf(null);
          if (index >= 0) {
            throw FlutterError(
                "$runtimeType's children must not contain any null values, "
                'but a null value was found at index $index');
          }
          return true;
        }()), // https://github.com/dart-lang/sdk/issues/29276
        super(key: key);

  final int crossAxisCount;

  final double mainAxisSpacing;

  final double crossAxisSpacing;

  /// gridAspectRatio == crossAxisStride / mainAxisStride
  final double gridAspectRatio;

  final List<Widget> children;

  final AlignmentGeometry alignment;

  final TextDirection textDirection;

  @override
  ReactGridElement createElement() {
    return ReactGridElement(this);
  }

  @override
  RenderReactGrid createRenderObject(BuildContext context) {
    return RenderReactGrid(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      gridAspectRatio: gridAspectRatio,
      alignment: alignment,
      textDirection: textDirection ?? Directionality.of(context),
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
      ..textDirection = textDirection ?? Directionality.of(context);
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
  @override
  Widget build(BuildContext context) {
    return _WrapReactPositioned(
      crossAxisOffsetCellCount: widget.crossAxisOffsetCellCount,
      mainAxisOffsetCellCount: widget.mainAxisOffsetCellCount,
      crossAxisCellCount: widget.crossAxisCellCount,
      mainAxisCellCount: widget.mainAxisCellCount,
      child: widget.child,
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
    @required Widget child,
  }) : super(key: key, child: child);

  final int crossAxisOffsetCellCount;

  final int mainAxisOffsetCellCount;

  final int crossAxisCellCount;

  final int mainAxisCellCount;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is ReactGridParentData);
    final ReactGridParentData parentData =
        renderObject.parentData as ReactGridParentData;
    bool needsLayout = false;

    if (parentData.crossAxisOffsetCellCount != crossAxisOffsetCellCount) {
      parentData.crossAxisOffsetCellCount = crossAxisOffsetCellCount;
      needsLayout = true;
    }

    if (parentData.mainAxisOffsetCellCount != mainAxisOffsetCellCount) {
      parentData.mainAxisOffsetCellCount = mainAxisOffsetCellCount;
      needsLayout = true;
    }

    if (parentData.crossAxisCellCount != crossAxisCellCount) {
      parentData.crossAxisCellCount = crossAxisCellCount;
      needsLayout = true;
    }

    if (parentData.mainAxisCellCount != mainAxisCellCount) {
      parentData.mainAxisCellCount = mainAxisCellCount;
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
