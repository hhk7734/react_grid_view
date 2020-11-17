import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:equatable/equatable.dart';

import 'package:react_grid_view/react_grid_view.dart';

part 'react_grid_event.dart';
part 'react_grid_state.dart';

class ReactGridBloc extends Bloc<ReactGridEvent, ReactGridState> {
  List<Widget> children = new List();
  Map<Key, ReactPositioned> reactPositionedMap = new Map();
  int crossAxisCount;
  double crossAxisSpacing;
  double crossAxisStride;
  double gridAspectRatio;
  int mainAxisCount;
  double mainAxisSpacing;
  double mainAxisStride;

  ReactGridBloc({
    @required this.crossAxisCount,
    this.crossAxisSpacing = 0.0,
    @required this.crossAxisStride,
    @required this.gridAspectRatio,
    @required this.mainAxisCount,
    this.mainAxisSpacing = 0.0,
    @required this.mainAxisStride,
  }) : super(ReactGridInitial());

  @override
  Stream<ReactGridState> mapEventToState(
    ReactGridEvent event,
  ) async* {
    if (event is ReactGridChildAdded) {
      yield* _mapReactGridChildAddedToState(event);
    } else if (event is ReactGridChildMoved) {
      yield* _mapReactGridChildMovedToState(event);
    }
  }

  Stream<ReactGridState> _mapReactGridChildAddedToState(
      ReactGridChildAdded event) async* {
    if (!_checkBeInStack(event.reactPositioned)) return;
    if (!_checkOverlap(event.reactPositioned, reactPositionedMap)) {
      UniqueKey key = UniqueKey();
      reactPositionedMap.putIfAbsent(key, () => event.reactPositioned);
      children.add(ReactGridItem(
        key: key,
        reactPositioned: event.reactPositioned,
      ));
      yield ReactGridChildAddedSucces(children: children);
    }
  }

  Stream<ReactGridState> _mapReactGridChildMovedToState(
      ReactGridChildMoved event) async* {
    if (!_checkBeInStack(event.reactPositioned)) return;
    if (event.isEnd) {
      reactPositionedMap[event.key].setCountFromOther(event.reactPositioned);
    } else {
      if (!_checkOverlap(
          event.reactPositioned, reactPositionedMap, event.key)) {
        yield ReactGridChildMovedSuccess(
            [event.key], {event.key: event.reactPositioned});
      }
    }
  }

  bool _checkBeInStack(ReactPositioned reactPositioned) {
    if (reactPositioned.crossAxisLeftOffsetCount < 0) return false;
    if (reactPositioned.mainAxisTopOffsetCount < 0) return false;
    if (reactPositioned.crossAxisRightOffsetCount > crossAxisCount)
      return false;
    if (reactPositioned.mainAxisBottomOffsetCount > mainAxisCount) return false;
    return true;
  }

  bool _checkOverlap(ReactPositioned reactPositioned,
      Map<Key, ReactPositioned> reactPositionedMap,
      [Key key]) {
    for (var index in reactPositionedMap.keys) {
      if (key != index) {
        ReactPositioned positioned = reactPositionedMap[index];
        int innerBottom;
        int innerLeft;
        int innerRight;
        int innerTop;

        innerBottom = reactPositioned.mainAxisBottomOffsetCount <
                positioned.mainAxisBottomOffsetCount
            ? reactPositioned.mainAxisBottomOffsetCount
            : positioned.mainAxisBottomOffsetCount;
        innerTop = reactPositioned.mainAxisTopOffsetCount >
                positioned.mainAxisTopOffsetCount
            ? reactPositioned.mainAxisTopOffsetCount
            : positioned.mainAxisTopOffsetCount;

        innerLeft = reactPositioned.crossAxisLeftOffsetCount >
                positioned.crossAxisLeftOffsetCount
            ? reactPositioned.crossAxisLeftOffsetCount
            : positioned.crossAxisLeftOffsetCount;
        innerRight = reactPositioned.crossAxisRightOffsetCount <
                positioned.crossAxisRightOffsetCount
            ? reactPositioned.crossAxisRightOffsetCount
            : positioned.crossAxisRightOffsetCount;

        if (innerBottom > innerTop && innerLeft < innerRight) return true;
      }
    }
    return false;
  }
}
