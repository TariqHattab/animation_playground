import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double dx = 0;

  double dy = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.teal,
        margin: EdgeInsets.all(32),
        child: GestureDetector(
          onTap: () => {print("details.globalPosition")},
          onTapDown: (details) {
            setState(() {
              dx = details.globalPosition.dx;
              dy = details.globalPosition.dy;
            });
            print(details.globalPosition);
          },
          onTapUp: (details) {
            setState(() {
              dx = details.globalPosition.dx;
              dy = details.globalPosition.dy;
            });
            print(details.globalPosition);
            print(details.localPosition);
          },
          onPanUpdate: (tapInfo) {
            setState(() {
              dx = tapInfo.globalPosition.dx;
              dy = tapInfo.globalPosition.dy;
            });
            print(tapInfo.delta.dx);
            print(tapInfo.delta.dy);
          },
          // onVerticalDragUpdate: (details) => print(details),
          // onHorizontalDragUpdate: (details) => print(details),
          child: Stack(
            children: [
              Center(
                child: Text('hi'),
              ),
              Positioned(
                  left: dx - 50,
                  top: dy - 50,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.red,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
