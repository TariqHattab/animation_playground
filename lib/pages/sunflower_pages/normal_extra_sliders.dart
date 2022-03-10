import 'dart:math' as math;

import 'package:flutter/material.dart';

final Color primaryColor = Colors.orange;
final TargetPlatform platform = TargetPlatform.android;

class SPainter2 extends CustomPainter {
  final double seedRaduis;
  final double scaleFactor;

  final double tau;
  final double phi;
  final int seeds;
  SPainter2(this.seeds, this.seedRaduis, this.scaleFactor, double t, double p)
      : this.tau = math.pi * t,
        this.phi = (math.sqrt(5) + p) / 2;
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
  bool shouldRepaint(SPainter2 oldDelegate) {
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
    previosPoint ??= Offset(size.width / 2, size.height / 2);
    var paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.fill
      ..color = primaryColor;
    // canvas.drawLine(previosPoint!, Offset(x, y), paint..strokeWidth = .5);
    canvas.drawCircle(Offset(x, y), seedRaduis, paint);
    previosPoint = Offset(x, y);
  }
}

class SFExtraSliders extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SunflowerState();
  }
}

class _SunflowerState extends State<SFExtraSliders>
    with AutomaticKeepAliveClientMixin {
  double seeds = 100.0;
  double seedRaduis = 2;
  double scaleFactor = 4;
  double t = .6;
  double p = 1;
  int get seedCount => seeds.floor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: PageStorageKey<String>('page3'),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.transparent)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ..._buildSlider('Showing $seedCount seeds', 20, 2000, seeds,
                (newValue) {
              setState(() {
                seeds = newValue;
              });
            }),
            ..._buildSlider('Seed Raduis $seedRaduis ', 0, 15, seedRaduis,
                (newValue) {
              setState(() {
                seedRaduis = newValue;
              });
            }),
            InteractiveViewer(
              maxScale: 200,
              minScale: .1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent)),
                child: SizedBox(
                  width: 400,
                  height: 400,
                  child: CustomPaint(
                    painter:
                        SPainter2(seedCount, seedRaduis, scaleFactor, t, p),
                  ),
                ),
              ),
            ),
            ..._buildSlider('Scale Factor $scaleFactor ', 0, 15, scaleFactor,
                (newValue) {
              setState(() {
                scaleFactor = newValue;
              });
            }),
            ..._buildSlider('T $t ', 0, 600, t, (newValue) {
              setState(() {
                t = newValue;
              });
            }),
            ..._buildSlider('P $p ', 0, 15, p, (newValue) {
              setState(() {
                p = newValue;
              });
            })
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSlider(String data, double min, double max, double value,
      void onChanged(dynamic newValue)) {
    return [
      Text(data),
      ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: 300),
        child: Slider.adaptive(
          min: min,
          max: max,
          value: value,
          onChanged: onChanged,
        ),
      ),
    ];
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
