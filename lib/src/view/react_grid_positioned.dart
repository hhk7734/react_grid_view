import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:react_grid_view/react_grid_view.dart';

// class ReactPositioned extends Positioned {
//   ReactPositioned({Widget child}) : super(child: child);
// }

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
          child: reactPositioned.child,
          top: _mainAxisStride * reactPositioned.mainAxisOffsetCount,
          left: _crossAxisStride * reactPositioned.crossAxisOffsetCount,
          width: _crossAxisStride * reactPositioned.crossAxisCount,
          height: _mainAxisStride * reactPositioned.mainAxisCount,
        );
      },
    );
  }
}
