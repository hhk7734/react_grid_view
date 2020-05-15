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
  }) : super(key: key, children: children);

  final AlignmentGeometry alignment;

  final TextDirection textDirection;

  final Overflow overflow;

  final int crossAxisCount;

  final double mainAxisSpacing;

  final double crossAxisSpacing;

  /// gridAspectRatio == crossAxisStride / mainAxisStride
  final double gridAspectRatio;

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
    properties
        .add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection,
        defaultValue: null));
    properties.add(EnumProperty<Overflow>('overflow', overflow));
  }
}

class ReactPositioned extends ParentDataWidget<ReactGridParentData> {
  const ReactPositioned({
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
