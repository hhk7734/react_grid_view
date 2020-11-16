import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:react_grid_view/react_grid_view.dart';

// class ReactPositioned extends Positioned {
//   ReactPositioned({Widget child}) : super(child: child);
// }

class ReactPositioned extends StatelessWidget {
  final Widget child;
  final int crossAxisCount;
  final int crossAxisOffsetCount;
  final int mainAxisCount;
  final int mainAxisOffsetCount;

  ReactPositioned({
    Key key,
    this.child,
    this.crossAxisCount,
    this.crossAxisOffsetCount,
    this.mainAxisCount,
    this.mainAxisOffsetCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          child: child,
          top: _mainAxisStride * mainAxisOffsetCount,
          left: _crossAxisStride * crossAxisOffsetCount,
          width: _crossAxisStride * crossAxisCount,
          height: _mainAxisStride * mainAxisCount,
        );
      },
    );
  }
}
