import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ReactGridParentData extends ContainerBoxParentData<RenderBox> {
  ReactGridParentData(this.controller);

  int crossAxisOffsetCellCount;

  int mainAxisOffsetCellCount;

  int crossAxisCellCount;

  int mainAxisCellCount;

  double top;

  double left;

  double width;

  double height;

  bool onDragging = false;

  ScrollController controller;

  @override
  String toString() {
    final List<String> values = <String>[
      if (top != null) 'top=${debugFormatDouble(top)}',
      if (left != null) 'left=${debugFormatDouble(left)}',
      if (width != null) 'width=${debugFormatDouble(width)}',
      if (height != null) 'height=${debugFormatDouble(height)}',
    ];
    if (values.isEmpty) values.add('not ReactPositioned');
    values.add(super.toString());
    return values.join('; ');
  }
}

class RenderReactGrid extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, ReactGridParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, ReactGridParentData> {
  RenderReactGrid({
    @required int crossAxisCount,
    double mainAxisSpacing,
    double crossAxisSpacing,
    double gridAspectRatio,
    List<RenderBox> children,
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    TextDirection textDirection,
    Overflow overflow = Overflow.clip,
    this.controller,
  })  : assert(alignment != null),
        assert(overflow != null),
        _crossAxisCount = crossAxisCount,
        _mainAxisSpacing = mainAxisSpacing,
        _crossAxisSpacing = crossAxisSpacing,
        _gridAspectRatio = gridAspectRatio,
        _alignment = alignment,
        _textDirection = textDirection,
        _overflow = overflow {
    addAll(children);
  }

  final ScrollController controller;

  double mainAxisStride;

  double crossAxisStride;

  bool _hasVisualOverflow = false;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! ReactGridParentData) {
      child.parentData = ReactGridParentData(controller);
    }
  }

  int get crossAxisCount => _crossAxisCount;
  int _crossAxisCount;
  set crossAxisCount(int value) {
    assert(value > 0);
    if (_crossAxisCount == value) return;
    _crossAxisCount = value;
    markNeedsLayout();
  }

  double get mainAxisSpacing => _mainAxisSpacing;
  double _mainAxisSpacing;
  set mainAxisSpacing(double value) {
    assert(value >= 0);
    if (_mainAxisSpacing == value) return;
    _mainAxisSpacing = value;
    markNeedsLayout();
  }

  double get crossAxisSpacing => _crossAxisSpacing;
  double _crossAxisSpacing;
  set crossAxisSpacing(double value) {
    assert(value >= 0);
    if (_crossAxisSpacing == value) return;
    _crossAxisSpacing = value;
    markNeedsLayout();
  }

  /// gridAspectRatio == crossAxisStride / mainAxisStride
  double get gridAspectRatio => _gridAspectRatio;
  double _gridAspectRatio;
  set gridAspectRatio(double value) {
    assert(value > 0);
    if (_gridAspectRatio == value) return;
    _gridAspectRatio = value;
    markNeedsLayout();
  }

  AlignmentGeometry get alignment => _alignment;
  AlignmentGeometry _alignment;
  set alignment(AlignmentGeometry value) {
    assert(value != null);
    if (_alignment == value) return;
    _alignment = value;
    markNeedsLayout();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsLayout();
  }

  Overflow get overflow => _overflow;
  Overflow _overflow;
  set overflow(Overflow value) {
    assert(value != null);
    if (_overflow != value) {
      _overflow = value;
      markNeedsPaint();
    }
  }

  static double getIntrinsicDimension(
      RenderBox firstChild, double mainChildSizeGetter(RenderBox child)) {
    double extent = 0.0;
    RenderBox child = firstChild;
    while (child != null) {
      final ReactGridParentData childParentData =
          child.parentData as ReactGridParentData;
      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }
    return extent;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return getIntrinsicDimension(
        firstChild, (RenderBox child) => child.getMinIntrinsicWidth(height));
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return getIntrinsicDimension(
        firstChild, (RenderBox child) => child.getMaxIntrinsicWidth(height));
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return getIntrinsicDimension(
        firstChild, (RenderBox child) => child.getMinIntrinsicHeight(width));
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return getIntrinsicDimension(
        firstChild, (RenderBox child) => child.getMaxIntrinsicHeight(width));
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }

  static bool layoutReactPositionedChild(
    RenderBox child,
    ReactGridParentData childParentData,
    Size size,
  ) {
    assert(child.parentData == childParentData);

    /// size is size of ReactGrid

    bool hasVisualOverflow = false;
    BoxConstraints childConstraints = const BoxConstraints();

    childConstraints = childConstraints.tighten(
      width: childParentData.width,
      height: childParentData.height,
    );

    child.layout(childConstraints, parentUsesSize: true);

    double x;
    x = childParentData.left;

    if (x < 0.0 || x + child.size.width > size.width) hasVisualOverflow = true;

    double y;
    y = childParentData.top;

    if (y < 0.0 || y + child.size.height > size.height)
      hasVisualOverflow = true;

    childParentData.offset = Offset(x, y);

    return hasVisualOverflow;
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    _hasVisualOverflow = false;

    // double width = constraints.minWidth;
    // double height = constraints.minHeight;

    RenderBox child = firstChild;

    size = constraints.biggest;
    crossAxisStride = size.width / crossAxisCount;
    mainAxisStride = crossAxisStride / gridAspectRatio;

    assert(size.isFinite);

    child = firstChild;

    while (child != null) {
      final ReactGridParentData childParentData =
          child.parentData as ReactGridParentData;
      if (!childParentData.onDragging) {
        childParentData.left =
            crossAxisStride * childParentData.crossAxisOffsetCellCount +
                crossAxisSpacing / 2;

        childParentData.top =
            mainAxisStride * childParentData.mainAxisOffsetCellCount +
                mainAxisSpacing / 2;
      }

      childParentData.width =
          childParentData.crossAxisCellCount * crossAxisStride -
              crossAxisSpacing;

      childParentData.height =
          childParentData.mainAxisCellCount * mainAxisStride - mainAxisSpacing;

      _hasVisualOverflow =
          layoutReactPositionedChild(child, childParentData, size) ||
              _hasVisualOverflow;

      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @protected
  void paintReactGrid(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_overflow == Overflow.clip && _hasVisualOverflow) {
      context.pushClipRect(
          needsCompositing, offset, Offset.zero & size, paintReactGrid);
    } else {
      paintReactGrid(context, offset);
    }
  }

  @override
  Rect describeApproximatePaintClip(RenderObject child) =>
      _hasVisualOverflow ? Offset.zero & size : null;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('crossAxisCount', crossAxisCount));
    properties.add(DoubleProperty('mainAxisSpacing', mainAxisSpacing));
    properties.add(DoubleProperty('crossAxisSpacing', crossAxisSpacing));
    properties.add(DoubleProperty('gridAspectRatio', gridAspectRatio));
    properties
        .add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection));
    properties.add(EnumProperty<Overflow>('overflow', overflow));
  }
}
