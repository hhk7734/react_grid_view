part of 'react_grid_bloc.dart';

@immutable
abstract class ReactGridState extends Equatable {
  const ReactGridState();
}

class ReactGridInitial extends ReactGridState {
  @override
  List<Object> get props => [];
}

class ReactGridChildAddedSucces extends ReactGridState {
  final List<Widget> children;

  const ReactGridChildAddedSucces({@required this.children});

  @override
  List<Object> get props => [children];
}