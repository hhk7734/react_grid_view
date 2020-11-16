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
}

class ReactGridItem extends StatelessWidget {
  final ReactPositioned reactPositioned;

  ReactGridItem({Key key, this.reactPositioned}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ReactGridItemOverlay overlay;
    return BlocBuilder<ReactGridBloc, ReactGridState>(
      buildWhen: (previous, current) {
        return true;
      },
      builder: (context, state) {
        double _crossAxisStride =
            context.select((ReactGridBloc bloc) => bloc.crossAxisStride);
        double _mainAxisStride =
            context.select((ReactGridBloc bloc) => bloc.mainAxisStride);
        return Positioned(
          child: GestureDetector(
            child: reactPositioned.child,
            onLongPressStart: (details) {
              overlay = ReactGridItemOverlay(
                height: _mainAxisStride * reactPositioned.mainAxisCount,
                initOffset: details.globalPosition - details.localPosition,
                overlayState: Overlay.of(context, debugRequiredFor: this),
                width: _crossAxisStride * reactPositioned.crossAxisCount,
              );
            },
            onLongPressMoveUpdate: (details) {
              overlay.onLongPressMoveUpdate(details);
            },
            onLongPressEnd: (details) {
              overlay.close();
              overlay = null;
            },
          ),
          top: _mainAxisStride * reactPositioned.mainAxisOffsetCount,
          left: _crossAxisStride * reactPositioned.crossAxisOffsetCount,
          width: _crossAxisStride * reactPositioned.crossAxisCount,
          height: _mainAxisStride * reactPositioned.mainAxisCount,
        );
      },
    );
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
