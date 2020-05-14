import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ReactGridParentData extends ContainerBoxParentData<RenderBox> {
  int crossAxisOffsetCellCount;

  int mainAxisOffsetCellCount;

  int crossAxisCellCount;

  int mainAxisCellCount;

  double top;

  double left;

  double width;

  double height;

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
    @required this.crossAxisCount,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.gridAspectRatio,
    List<RenderBox> children,
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    TextDirection textDirection,
    Overflow overflow = Overflow.clip,
  })  : assert(alignment != null),
        assert(overflow != null),
        _alignment = alignment,
        _textDirection = textDirection,
        _overflow = overflow {
    addAll(children);
  }

  final int crossAxisCount;

  final double mainAxisSpacing;

  final double crossAxisSpacing;

  /// gridAspectRatio == crossAxisStride / mainAxisStride
  final double gridAspectRatio;

  double mainAxisStride;

  double crossAxisStride;

  bool _hasVisualOverflow = false;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! ReactGridParentData)
      child.parentData = ReactGridParentData();
  }

  Alignment _resolvedAlignment;

  void _resolve() {
    if (_resolvedAlignment != null) return;
    _resolvedAlignment = alignment.resolve(textDirection);
  }

  void _markNeedResolution() {
    _resolvedAlignment = null;
    markNeedsLayout();
  }

  AlignmentGeometry get alignment => _alignment;
  AlignmentGeometry _alignment;
  set alignment(AlignmentGeometry value) {
    assert(value != null);
    if (_alignment == value) return;
    _alignment = value;
    _markNeedResolution();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    _markNeedResolution();
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

  static bool layoutReactPositionedChild(RenderBox child,
      ReactGridParentData childParentData, Size size, Alignment alignment) {
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
    _resolve();
    assert(_resolvedAlignment != null);
    _hasVisualOverflow = false;
    if (childCount == 0) {
      size = constraints.biggest;
      assert(size.isFinite);
      return;
    }

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

      _hasVisualOverflow = layoutReactPositionedChild(
              child, childParentData, size, _resolvedAlignment) ||
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
    properties
        .add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection));
    properties.add(EnumProperty<Overflow>('overflow', overflow));
  }
}
