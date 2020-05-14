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
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
    @required Widget child,
  })  : assert(left == null || right == null || width == null),
        assert(top == null || bottom == null || height == null),
        super(key: key, child: child);

  ReactPositioned.fromRect({
    Key key,
    Rect rect,
    @required Widget child,
  })  : left = rect.left,
        top = rect.top,
        width = rect.width,
        height = rect.height,
        right = null,
        bottom = null,
        super(key: key, child: child);

  ReactPositioned.fromRelativeRect({
    Key key,
    RelativeRect rect,
    @required Widget child,
  })  : left = rect.left,
        top = rect.top,
        right = rect.right,
        bottom = rect.bottom,
        width = null,
        height = null,
        super(key: key, child: child);

  const ReactPositioned.fill({
    Key key,
    this.left = 0.0,
    this.top = 0.0,
    this.right = 0.0,
    this.bottom = 0.0,
    @required Widget child,
  })  : width = null,
        height = null,
        super(key: key, child: child);

  factory ReactPositioned.directional({
    Key key,
    @required TextDirection textDirection,
    double start,
    double top,
    double end,
    double bottom,
    double width,
    double height,
    @required Widget child,
  }) {
    assert(textDirection != null);
    double left;
    double right;
    switch (textDirection) {
      case TextDirection.rtl:
        left = end;
        right = start;
        break;
      case TextDirection.ltr:
        left = start;
        right = end;
        break;
    }
    return ReactPositioned(
      key: key,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: child,
    );
  }

  final double left;

  final double top;

  final double right;

  final double bottom;

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

    if (parentData.right != right) {
      parentData.right = right;
      needsLayout = true;
    }

    if (parentData.bottom != bottom) {
      parentData.bottom = bottom;
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
    properties.add(DoubleProperty('right', right, defaultValue: null));
    properties.add(DoubleProperty('bottom', bottom, defaultValue: null));
    properties.add(DoubleProperty('width', width, defaultValue: null));
    properties.add(DoubleProperty('height', height, defaultValue: null));
  }
}
