import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:react_grid_view/react_grid_view.dart';

class ReactGridView extends StatelessWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double gridAspectRatio;
  final int mainAxisCount;
  final double mainAxisSpacing;

  ReactGridView({
    Key key,
    @required this.children,
    @required this.crossAxisCount,
    this.crossAxisSpacing = 0.0,
    this.gridAspectRatio = 1.0,
    this.mainAxisCount = 0,
    this.mainAxisSpacing = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double _crossAxisStride;
        double _mainAxisStride;
        int _mainAxisCount;

        _crossAxisStride = constraints.biggest.width / crossAxisCount;
        _mainAxisStride = _crossAxisStride / gridAspectRatio;
        if (mainAxisCount == 0) {
          _mainAxisCount = constraints.biggest.height ~/ _mainAxisStride;
        } else {
          _mainAxisCount = mainAxisCount;
        }

        return BlocProvider<ReactGridBloc>(
          create: (context) {
            return ReactGridBloc(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: crossAxisSpacing,
              crossAxisStride: _crossAxisStride,
              gridAspectRatio: gridAspectRatio,
              mainAxisCount: _mainAxisCount,
              mainAxisSpacing: mainAxisSpacing,
              mainAxisStride: _mainAxisStride,
            );
          },
          child: BlocBuilder<ReactGridBloc, ReactGridState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Container(
                  height: context.select((ReactGridBloc bloc) =>
                      bloc.mainAxisCount * bloc.mainAxisStride),
                  child: Stack(
                    children: children,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
