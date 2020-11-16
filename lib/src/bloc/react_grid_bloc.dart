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
    }
  }

  Stream<ReactGridState> _mapReactGridChildAddedToState(
      ReactGridChildAdded event) async* {
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

        innerBottom = reactPositioned.mainAxisCount +
                    reactPositioned.mainAxisOffsetCount <
                positioned.mainAxisCount + positioned.mainAxisOffsetCount
            ? reactPositioned.mainAxisCount +
                reactPositioned.mainAxisOffsetCount
            : positioned.mainAxisCount + positioned.mainAxisOffsetCount;
        innerTop =
            reactPositioned.mainAxisOffsetCount > positioned.mainAxisOffsetCount
                ? reactPositioned.mainAxisOffsetCount
                : positioned.mainAxisOffsetCount;

        innerLeft = reactPositioned.crossAxisOffsetCount >
                positioned.crossAxisOffsetCount
            ? reactPositioned.crossAxisOffsetCount
            : positioned.crossAxisOffsetCount;
        innerRight = reactPositioned.crossAxisCount +
                    reactPositioned.crossAxisOffsetCount <
                positioned.crossAxisCount + positioned.crossAxisOffsetCount
            ? reactPositioned.crossAxisCount +
                reactPositioned.crossAxisOffsetCount
            : positioned.crossAxisCount + positioned.crossAxisOffsetCount;

        if (innerBottom > innerTop && innerLeft < innerRight) return true;
      }
    }
    return false;
  }
}
