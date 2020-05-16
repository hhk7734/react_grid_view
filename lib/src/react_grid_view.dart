import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import './widgets/react_grid.dart';

class ReactGridView extends StatefulWidget {
  const ReactGridView({
    this.key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.padding,
    this.primary,
    this.physics,
    this.controller,
    this.dragStartBehavior = DragStartBehavior.start,
    @required this.crossAxisCount,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.gridAspectRatio = 1.0,
    this.children = const <Widget>[],
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.overflow = Overflow.clip,
  }) : super(key: key);

  final Key key;

  final Axis scrollDirection;

  final bool reverse;

  final EdgeInsetsGeometry padding;

  final ScrollController controller;

  final bool primary;

  final ScrollPhysics physics;

  final DragStartBehavior dragStartBehavior;

  final int crossAxisCount;

  final double mainAxisSpacing;

  final double crossAxisSpacing;

  final double gridAspectRatio;

  final List<Widget> children;

  final AlignmentGeometry alignment;

  final TextDirection textDirection;

  final Overflow overflow;

  @override
  _ReactGridViewState createState() => _ReactGridViewState();
}

class _ReactGridViewState extends State<ReactGridView> {
  ScrollController controller;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double mainAxisStride =
        width / widget.crossAxisCount / widget.gridAspectRatio;

    double height = 0;
    widget.children.forEach((element) {
      ReactPositioned child = element as ReactPositioned;
      double _height =
          (child.mainAxisCellCount + child.mainAxisOffsetCellCount + 1) *
              mainAxisStride;
      if (_height > height) height = _height;
    });

    controller = widget.controller != null
        ? widget.controller
        : PrimaryScrollController.of(context);

    return SingleChildScrollView(
      key: widget.key,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      padding: widget.padding,
      primary: widget.primary,
      physics: widget.physics,
      controller: controller,
      dragStartBehavior: widget.dragStartBehavior,
      child: Container(
        width: width,
        height: height,
        child: ReactGrid(
          key: widget.key,
          crossAxisCount: widget.crossAxisCount,
          mainAxisSpacing: widget.mainAxisSpacing,
          crossAxisSpacing: widget.crossAxisSpacing,
          gridAspectRatio: widget.gridAspectRatio,
          children: widget.children,
          alignment: widget.alignment,
          textDirection: widget.textDirection ?? Directionality.of(context),
          overflow: widget.overflow,
          controller: controller,
        ),
      ),
    );
  }
}
