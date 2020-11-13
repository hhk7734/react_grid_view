import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:react_grid_view/react_grid_view.dart';

class ReactGridView extends StatelessWidget {
  final List<Widget> children;

  ReactGridView({this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // print(constraints.biggest.width);
        return BlocProvider<ReactGridBloc>(
          create: (context) {
            return ReactGridBloc();
          },
          child: BlocBuilder<ReactGridBloc, ReactGridState>(
            builder: (context, state) {
              return Stack(
                children: children,
                fit: StackFit.expand,
              );
            },
          ),
        );
      },
    );
  }
}
