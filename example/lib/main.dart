import 'package:flutter/material.dart';
import 'package:react_grid_view/react_grid_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Test(),
    );
  }
}

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReactGridView(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        gridAspectRatio: 0.5,
        children: [
          ReactPositioned(
            crossAxisOffsetCellCount: 0,
            mainAxisOffsetCellCount: 0,
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: Container(
              color: Colors.red[100],
            ),
          ),
          ReactPositioned(
            crossAxisOffsetCellCount: 1,
            mainAxisOffsetCellCount: 0,
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: Container(
              color: Colors.red[200],
            ),
          ),
          ReactPositioned(
            crossAxisOffsetCellCount: 2,
            mainAxisOffsetCellCount: 0,
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: Container(
              color: Colors.red[300],
            ),
          ),
          ReactPositioned(
            crossAxisOffsetCellCount: 0,
            mainAxisOffsetCellCount: 1,
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: Container(
              color: Colors.red[400],
            ),
          ),
          ReactPositioned(
            crossAxisOffsetCellCount: 1,
            mainAxisOffsetCellCount: 1,
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: Container(
              color: Colors.red[500],
            ),
          ),
          ReactPositioned(
            crossAxisOffsetCellCount: 2,
            mainAxisOffsetCellCount: 1,
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: Container(
              color: Colors.red[100],
            ),
          ),
          ReactPositioned(
            crossAxisOffsetCellCount: 0,
            mainAxisOffsetCellCount: 2,
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: Container(
              color: Colors.red[200],
            ),
          ),
          ReactPositioned(
            crossAxisOffsetCellCount: 1,
            mainAxisOffsetCellCount: 2,
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: Container(
              color: Colors.red[300],
            ),
          ),
          ReactPositioned(
            crossAxisOffsetCellCount: 2,
            mainAxisOffsetCellCount: 2,
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: Container(
              color: Colors.red[400],
            ),
          ),
          ReactPositioned(
            crossAxisOffsetCellCount: 0,
            mainAxisOffsetCellCount: 3,
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: Container(
              color: Colors.red[500],
            ),
          ),
        ],
      ),
    );
  }
}
