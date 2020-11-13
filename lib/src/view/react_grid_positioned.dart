import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:react_grid_view/react_grid_view.dart';

// class ReactPositioned extends Positioned {
//   ReactPositioned({Widget child}) : super(child: child);
// }

class ReactPositioned extends StatelessWidget {
  final Widget child;
  final double top;
  final double left;

  ReactPositioned({this.child, this.top, this.left});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReactGridBloc, ReactGridState>(
      buildWhen: (previous, current) {
        return true;
      },
      builder: (context, state) {
        return Positioned(
          child: child,
          top: top,
          left: left,
        );
      },
    );
  }
}
