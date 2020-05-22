import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ReactGridParentData extends ContainerBoxParentData<RenderBox> {
  int crossAxisOffsetCellCount;

  int mainAxisOffsetCellCount;

  int crossAxisCellCount;

  int mainAxisCellCount;

  double width;

  double height;

  @override
  String toString() {
    final List<String> values = <String>[
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
  })  : assert(alignment != null),
        _crossAxisCount = crossAxisCount,
        _mainAxisSpacing = mainAxisSpacing,
        _crossAxisSpacing = crossAxisSpacing,
        _gridAspectRatio = gridAspectRatio,
        _alignment = alignment,
        _textDirection = textDirection {
    addAll(children);
  }

  double mainAxisStride;

  double crossAxisStride;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! ReactGridParentData)
      child.parentData = ReactGridParentData();
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

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;

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

      double left = crossAxisStride * childParentData.crossAxisOffsetCellCount +
          crossAxisSpacing / 2;

      double top = mainAxisStride * childParentData.mainAxisOffsetCellCount +
          mainAxisSpacing / 2;

      childParentData.offset = Offset(left, top);

      childParentData.width =
          childParentData.crossAxisCellCount * crossAxisStride -
              crossAxisSpacing;

      childParentData.height =
          childParentData.mainAxisCellCount * mainAxisStride - mainAxisSpacing;

      BoxConstraints childConstraints = const BoxConstraints();

      childConstraints = childConstraints.tighten(
        width: childParentData.width,
        height: childParentData.height,
      );

      child.layout(childConstraints, parentUsesSize: true);

      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
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
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection));
  }
}
