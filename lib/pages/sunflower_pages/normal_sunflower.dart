import 'dart:math' as math;

import 'package:flutter/material.dart';

final Color primaryColor = Colors.orange;
final TargetPlatform platform = TargetPlatform.android;

class SPainter1 extends CustomPainter {
  static const seedRadius = 2.0;
  static const scaleFactor = 4;
  static const tau = math.pi * 2;
  static final phi = (math.sqrt(5) + 1) / 2;
  final int seeds;
  SPainter1(this.seeds);
  @override
  void paint(Canvas canvas, Size size) {
    var center = size.width / 2;
    for (var i = 0; i < seeds; i++) {
      var theta = i * tau / phi;
      double r = math.sqrt(i) * scaleFactor;
      double x = center + r * math.cos(theta);
      double y = center - r * math.sin(theta);
      var offset = Offset(x, y);
      if (!size.contains(offset)) {
        continue;
      }
      drawSeed(canvas, x, y, size);
    }
  }

  @override
  bool shouldRepaint(SPainter1 oldDelegate) {
    return oldDelegate.seeds != this.seeds;
  }

// Draw a small circle representing a seed centered at (x,y).
  Offset? previosPoint;
  void drawSeed(
    Canvas canvas,
    double x,
    double y,
    Size size,
  ) {
    // previosPoint ??= Offset(size.width / 2, size.height / 2);
    var paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.fill
      ..color = primaryColor;
    // canvas.drawLine(previosPoint!, Offset(x, y), paint..strokeWidth = .5);
    canvas.drawCircle(Offset(x, y), seedRadius, paint);
    // previosPoint = Offset(x, y);
  }
}

class Sunflower extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SunflowerState();
  }
}

class _SunflowerState extends State<Sunflower>
    with AutomaticKeepAliveClientMixin {
  double seeds = 100.0;
  int get seedCount => seeds.floor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: PageStorageKey<String>('page1'),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.transparent)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.transparent)),
              child: SizedBox(
                width: 400,
                height: 400,
                child: CustomPaint(
                  painter: SPainter1(seedCount),
                ),
              ),
            ),
            Text('Showing $seedCount seeds'),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 300),
              child: Slider.adaptive(
                min: 20,
                max: 2000,
                value: seeds,
                onChanged: (newValue) {
                  setState(() {
                    seeds = newValue;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
