import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';

import '../rendering/react_grid.dart';

class ReactGrid extends MultiChildRenderObjectWidget {
  ReactGrid({
    Key key,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.overflow = Overflow.clip,
    List<Widget> children = const <Widget>[],
  }) : super(key: key, children: children);

  final AlignmentGeometry alignment;

  final TextDirection textDirection;

  final Overflow overflow;

  @override
  RenderReactGrid createRenderObject(BuildContext context) {
    return RenderReactGrid(
      alignment: alignment,
      textDirection: textDirection ?? Directionality.of(context),
      overflow: overflow,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderReactGrid renderObject) {
    renderObject
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
    @required this.left,
    @required this.top,
    @required this.width,
    @required this.height,
    @required Widget child,
  }) : super(key: key, child: child);

  final double left;

  final double top;

  final double width;

  final double height;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is ReactGridParentData);
    final ReactGridParentData parentData =
        renderObject.parentData as ReactGridParentData;
    bool needsLayout = false;

    if (parentData.left != left) {
      parentData.left = left;
      needsLayout = true;
    }

    if (parentData.top != top) {
      parentData.top = top;
      needsLayout = true;
    }

    if (parentData.width != width) {
      parentData.width = width;
      needsLayout = true;
    }

    if (parentData.height != height) {
      parentData.height = height;
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
    properties.add(DoubleProperty('left', left, defaultValue: null));
    properties.add(DoubleProperty('top', top, defaultValue: null));
    properties.add(DoubleProperty('width', width, defaultValue: null));
    properties.add(DoubleProperty('height', height, defaultValue: null));
  }
}
