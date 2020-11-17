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

class ReactGridChildMoved extends ReactGridEvent {
  final Key key;
  final ReactPositioned reactPositioned;
  final bool isEnd;

  const ReactGridChildMoved(
      {this.key, this.reactPositioned, this.isEnd = false});

  @override
  List<Object> get props => [key, reactPositioned, isEnd];
}
