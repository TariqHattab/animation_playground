import 'dart:math' as math;

import 'package:animation_playground/utils/prime_numbers.dart';
import 'package:flutter/material.dart';

final Color primaryColor = Colors.orange;
final TargetPlatform platform = TargetPlatform.android;

class SPainter5 extends CustomPainter {
  final double seedRaduis;
  final double scaleFactor;

  final double tau;
  final double phi;
  final int seeds;
  final double lineWidth;

  SPainter5(this.seeds, this.seedRaduis, this.scaleFactor, double t, double p,
      this.lineWidth)
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
      drawSeed(canvas, x, y, size, i);
    }
  }

  @override
  bool shouldRepaint(SPainter5 oldDelegate) {
    return oldDelegate.seeds != this.seeds;
  }

// Draw a small circle representing a seed centered at (x,y).
  Offset? previosPoint;
  void drawSeed(
    Canvas canvas,
    double x,
    double y,
    Size size,
    int i,
  ) {
    var paint = Paint()
      ..strokeWidth = .5
      ..style = PaintingStyle.fill
      ..color = primaryColor;
    if (_shouldDrawLine(x, size, i)) {
      canvas.drawLine(
        previosPoint!,
        Offset(x, y),

        // Offset(size.width / 2, size.width / 2),
        paint..strokeWidth = lineWidth,
      );
    }
    canvas.drawCircle(Offset(x, y), seedRaduis, paint);
    if (i % 13 == 0) {
      previosPoint = Offset(x, y);
    }
  }

  bool _shouldDrawLine(double x, Size size, int i) =>
      previosPoint != null &&
      x != size.width / 2 &&
      i % 13 == 0 &&
      lineWidth != 0;
}

class SFsqrt extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SunflowerState();
  }
}

class _SunflowerState extends State<SFsqrt>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _controller;
  double seeds = 100.0;
  double seedRaduis = 2;
  double scaleFactor = 4;
  double t = 1;
  double p = 1;
  double maxTValue = 3.3;
  int get seedCount => seeds.floor();
  double d = 10;
  double lineWidth = .4;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    _controller.addListener(() {
      setState(() {
        t = maxTValue * _controller.value;
      });

      print("asdfasfdasfdf");
      print(_controller.value);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  void startAnimation() {
    _controller = _controller..duration = Duration(seconds: d.toInt());
    if (_controller.isAnimating) {
      _controller.stop();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: PageStorageKey<String>('page4'),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration:
            BoxDecoration(border: Border.all(color: Colors.transparent)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InteractiveViewer(
              maxScale: 2000,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent)),
                child: SizedBox(
                  width: 400,
                  height: 400,
                  child: CustomPaint(
                    painter: SPainter5(
                        seedCount, seedRaduis, scaleFactor, t, p, lineWidth),
                  ),
                ),
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  ..._buildSlider('Showing $seedCount seeds', 20, 3000, seeds,
                      (newValue) {
                    setState(() {
                      seeds = newValue;
                    });
                  }),
                  ..._buildSlider('Seed Raduis $seedRaduis ', 0, 3, seedRaduis,
                      (newValue) {
                    setState(() {
                      seedRaduis = newValue;
                    });
                  }),
                  ..._buildSlider(
                      'Scale Factor $scaleFactor ', 0, 15, scaleFactor,
                      (newValue) {
                    setState(() {
                      scaleFactor = newValue;
                    });
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ..._buildSlider(
                            'T $t ',
                            0,
                            maxTValue.toDouble(),
                            t,
                            (newValue) {
                              setState(() {
                                t = newValue;
                                _controller.value =
                                    newValue / maxTValue.toDouble();
                              });
                            },
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => startAnimation(),
                        child: CircleAvatar(
                          backgroundColor: primaryColor,
                          child: Icon(
                            _controller.isAnimating
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  ..._buildSlider('P $p ', 0, 3, p, (newValue) {
                    setState(() {
                      p = newValue;
                    });
                  }),
                  ..._buildSlider(
                      'Animation Duration ${d.toInt()} seconds ', 0, 100000, d,
                      (newValue) {
                    setState(() {
                      d = newValue;
                    });
                  }),
                  ..._buildSlider('Line Width $lineWidth ', 0, 1, lineWidth,
                      (newValue) {
                    setState(() {
                      lineWidth = newValue;
                    });
                  })
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSlider(String data, double min, double max, double value,
      void onChanged(dynamic newValue),
      {BigInt? bigMax}) {
    return [
      Text(
        data,
        style: TextStyle(height: 1),
      ),
      ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: 300),
        child: Slider.adaptive(
          min: min,
          max: bigMax?.toDouble() ?? max,
          value: value,
          onChanged: onChanged,
        ),
      ),
    ];
  }

  @override
  bool get wantKeepAlive => true;
}
