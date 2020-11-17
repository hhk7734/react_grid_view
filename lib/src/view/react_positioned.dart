import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:react_grid_view/react_grid_view.dart';

class ReactPositioned {
  final Widget child;
  int crossAxisCount;
  int crossAxisOffsetCount;
  int mainAxisCount;
  int mainAxisOffsetCount;

  ReactPositioned({
    this.child,
    this.crossAxisCount,
    this.crossAxisOffsetCount,
    this.mainAxisCount,
    this.mainAxisOffsetCount,
  });

  ReactPositioned copyWithoutChild() {
    return ReactPositioned(
      child: null,
      crossAxisCount: crossAxisCount,
      crossAxisOffsetCount: crossAxisOffsetCount,
      mainAxisCount: mainAxisCount,
      mainAxisOffsetCount: mainAxisOffsetCount,
    );
  }

  void setCountFromOther(ReactPositioned other) {
    crossAxisCount = other.crossAxisCount;
    crossAxisOffsetCount = other.crossAxisOffsetCount;
    mainAxisCount = other.mainAxisCount;
    mainAxisOffsetCount = other.mainAxisOffsetCount;
  }
}

class ReactGridItem extends StatefulWidget {
  final ReactPositioned reactPositioned;

  ReactGridItem({Key key, this.reactPositioned}) : super(key: key);

  @override
  _ReactGridItemState createState() => _ReactGridItemState();
}

class _ReactGridItemState extends State<ReactGridItem> {
  ReactGridItemOverlay overlay;

  double crossAxisStride;
  double mainAxisStride;

  int moveCrossOffsetCount = 0;
  int moveMainOffsetCount = 0;

  ReactPositioned lastReactPositioned;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReactGridBloc, ReactGridState>(
      buildWhen: (previous, current) {
        if (current is ReactGridChildMovedSuccess) {
          if (current.keyList.contains(widget.key)) {
            return true;
          }
        }
        return false;
      },
      builder: (context, state) {
        crossAxisStride =
            context.select((ReactGridBloc bloc) => bloc.crossAxisStride);
        mainAxisStride =
            context.select((ReactGridBloc bloc) => bloc.mainAxisStride);

        if (state is ReactGridChildMovedSuccess) {
          lastReactPositioned = state.reactPositionedMap[widget.key];
        } else {
          lastReactPositioned = widget.reactPositioned;
        }

        return Positioned(
          child: GestureDetector(
            child: widget.reactPositioned.child,
            onLongPressStart: (details) => onLongPressStart(details),
            onLongPressMoveUpdate: (details) =>
                onLongPressMoveUpdate(details, context),
            onLongPressEnd: (details) => onLongPressEnd(details, context),
          ),
          top: mainAxisStride * lastReactPositioned.mainAxisOffsetCount,
          left: crossAxisStride * lastReactPositioned.crossAxisOffsetCount,
          width: crossAxisStride * lastReactPositioned.crossAxisCount,
          height: mainAxisStride * lastReactPositioned.mainAxisCount,
        );
      },
    );
  }

  void onLongPressStart(LongPressStartDetails details) {
    overlay = ReactGridItemOverlay(
      height: mainAxisStride * widget.reactPositioned.mainAxisCount,
      initOffset: details.globalPosition - details.localPosition,
      overlayState: Overlay.of(context, debugRequiredFor: widget),
      width: crossAxisStride * widget.reactPositioned.crossAxisCount,
    );
  }

  void onLongPressMoveUpdate(
      LongPressMoveUpdateDetails details, BuildContext context) {
    overlay.onLongPressMoveUpdate(details);
    int _currentMoveCrossOffsetCount =
        (details.localOffsetFromOrigin.dx / crossAxisStride).round();
    int _currentMoveMainOffsetCount =
        (details.localOffsetFromOrigin.dy / mainAxisStride).round();

    if (_currentMoveCrossOffsetCount != moveCrossOffsetCount ||
        _currentMoveMainOffsetCount != moveMainOffsetCount) {
      moveCrossOffsetCount = _currentMoveCrossOffsetCount;
      moveMainOffsetCount = _currentMoveMainOffsetCount;
      ReactPositioned _reactPositioned =
          widget.reactPositioned.copyWithoutChild();
      _reactPositioned.crossAxisOffsetCount += moveCrossOffsetCount;
      _reactPositioned.mainAxisOffsetCount += moveMainOffsetCount;

      context.read<ReactGridBloc>().add(ReactGridChildMoved(
          key: widget.key, reactPositioned: _reactPositioned));
    }
  }

  void onLongPressEnd(LongPressEndDetails details, BuildContext context) {
    overlay.close();
    overlay = null;

    moveCrossOffsetCount = 0;
    moveMainOffsetCount = 0;

    context.read<ReactGridBloc>().add(ReactGridChildMoved(
        key: widget.key, reactPositioned: lastReactPositioned, isEnd: true));
  }
}

class ReactGridItemOverlay {
  final double height;
  final Offset initOffset;
  Offset lastOffset;
  OverlayEntry overlayEntry;
  final OverlayState overlayState;
  final double width;

  ReactGridItemOverlay({
    this.height,
    this.initOffset,
    @required this.overlayState,
    this.width,
  }) {
    lastOffset = initOffset;
    overlayEntry = OverlayEntry(builder: build);
    overlayState.insert(overlayEntry);
  }

  void onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    lastOffset = initOffset + details.localOffsetFromOrigin;
    overlayEntry.markNeedsBuild();
  }

  Widget build(BuildContext context) {
    final RenderBox box = overlayState.context.findRenderObject() as RenderBox;
    final Offset overlayTopLeft = box.localToGlobal(Offset.zero);
    return Positioned(
      left: lastOffset.dx - overlayTopLeft.dx,
      top: lastOffset.dy - overlayTopLeft.dy,
      child: IgnorePointer(
        child: Opacity(
          opacity: 0.5,
          child: Container(
            width: width,
            height: height,
            color: Colors.green,
          ),
        ),
        ignoringSemantics: true,
      ),
    );
  }

  void close() {
    overlayEntry.remove();
    overlayEntry = null;
  }
}
