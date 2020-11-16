part of 'react_grid_bloc.dart';

@immutable
abstract class ReactGridEvent extends Equatable {
  const ReactGridEvent();
}

class ReactGridChildAdded extends ReactGridEvent {
  final ReactPositioned reactPositioned;

  const ReactGridChildAdded({this.reactPositioned});

  @override
  List<Object> get props => [reactPositioned];
}
