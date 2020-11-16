import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'react_grid_event.dart';
part 'react_grid_state.dart';

class ReactGridBloc extends Bloc<ReactGridEvent, ReactGridState> {
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
    // TODO: implement mapEventToState
  }
}
