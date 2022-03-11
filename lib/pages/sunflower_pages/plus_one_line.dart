import 'dart:math' as math;

import 'package:animation_playground/pages/sunflower.dart';
import 'package:animation_playground/utils/consts.dart';
import 'package:flutter/material.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';

final Color primaryColor = Colors.orange;
final TargetPlatform platform = TargetPlatform.android;

class SPainter3 extends CustomPainter {
  final double seedRaduis;
  final double scaleFactor;

  double tau = 0;
  final double phi;
  final int seeds;
  final double lineWidth;
  final Color lineColor;
  final ColorTween colorAnim;
  final bool useGradaint;
  final double maxTvalue;
  final Animation<double> animation;

  SPainter3(
    this.seeds,
    this.seedRaduis,
    this.scaleFactor,
    double t,
    double p,
    this.lineWidth,
    this.lineColor,
    Color begin,
    Color endColor,
    this.useGradaint,
    Animation<double> repaint,
    this.maxTvalue,
  )   : this.phi = (math.sqrt(5) + p) / 2,
        this.colorAnim = ColorTween(begin: begin, end: endColor),
        this.animation = repaint,
        super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    var t = maxTvalue * animation.value;
    tau = math.pi * t;
    print('custom animation rebuilt');
    print(tau);
    var center = size.width / 2;
    Color? gradiantColor;
    for (var i = 0; i < seeds; i++) {
      if (useGradaint) {
        gradiantColor = colorAnim.lerp(i / seeds);
      }
      num theta = i * tau / phi;
      double r = math.sqrt(i) * scaleFactor;
      double x = center + r * math.cos(theta);
      double y = center - r * math.sin(theta);
      Offset offset = Offset(x, y);
      if (!size.contains(offset)) {
        continue;
      }
      drawSeed(canvas, x, y, size, useGradaint, gradiantColor);
    }
  }

  @override
  bool shouldRepaint(SPainter3 oldDelegate) {
    return true;
    // return oldDelegate.seeds != this.seeds ||
    //     oldDelegate.lineColor != lineColor ||
    //     oldDelegate.colorAnim.begin != colorAnim.begin ||
    //     oldDelegate.colorAnim.end != colorAnim.end;
  }

// Draw a small circle representing a seed centered at (x,y).
  Offset? previosPoint;
  void drawSeed(
    Canvas canvas,
    double x,
    double y,
    Size size,
    bool useGradaint,
    Color? gradiantColor,
  ) {
    var paint = Paint()
      ..strokeWidth = .5
      ..style = PaintingStyle.fill
      ..color = lineColor;
    if (useGradaint && gradiantColor != null) {
      paint.color = gradiantColor;
    }
    if (_shouldDrawLine(x, size)) {
      canvas.drawLine(
          previosPoint!, Offset(x, y), paint..strokeWidth = lineWidth);
    }
    canvas.drawCircle(Offset(x, y), seedRaduis, paint);
    previosPoint = Offset(x, y);
  }

  bool _shouldDrawLine(double x, Size size) =>
      previosPoint != null && x != size.width / 2 && lineWidth != 0;
}

class SunflowerLine extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SunflowerState();
  }
}

class _SunflowerState extends State<SunflowerLine>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _controller;

  double seeds = 100.0;
  double seedRaduis = 2;
  double scaleFactor = 4;
  double t = 1;
  double p = 1;
  double maxTValue = 3.3;
  double d = 10;
  double lineWidth = .4;
  bool isAnimating = false;
  bool reversedAnim = false;
  bool darkMode = true;
  bool isLarge = false;
  bool useGradaint = false;
  Color lineColor = primaryColor;
  Color dotColor = primaryColor;
  Color startColor = primaryColor;
  Color endColor = primaryColor;
  int maxAnimDuration = 10000000;

  int get seedCount => seeds.floor();
  // Color pickerColor = primaryColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this);

    _controller.addListener(() {
      // setState(() {
      // t = maxTValue * _controller.value;
      // });

      // print("asdfasfdasfdf");
      // print(_controller.value);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  void toggleAnimation() {
    if (_controller.isCompleted) {
      _resumeAnimFromStart();
    }
    _controller = _controller..duration = Duration(seconds: d.toInt());
    if (isAnimating) {
      _stopAnim();
    } else {
      _startAnim();
    }
  }

  void _resumeAnimFromStart() {
    _controller.value = 0;
    setState(() {
      isAnimating = false;
    });
  }

  void _stopAnim() {
    _controller.stop();
    setState(() {
      isAnimating = false;
    });
  }

  void toggleAnimationOnly() {
    _controller = _controller..duration = Duration(seconds: d.toInt());

    _startAnim();
  }

  void _startAnim() {
    if (reversedAnim) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      isAnimating = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('main page rebuilt');
    return Scaffold(
      key: PageStorageKey<String>('page2'),
      backgroundColor: darkMode ? Colors.black : Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isLarge = !isLarge;
          });
        },
        child: Icon(
          isLarge ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        ),
      ),
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
                  height: isLarge ? 700 : 400,
                  child: CustomPaint(
                    painter: SPainter3(
                      seedCount,
                      seedRaduis,
                      scaleFactor,
                      t,
                      p,
                      lineWidth,
                      lineColor,
                      startColor,
                      endColor,
                      useGradaint,
                      _controller.view,
                      maxTValue,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  ..._buildSlider('Showing $seedCount seeds', 20, 60000, seeds,
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
                  }), //T
                  _buildStartReversT(),
                  // ..._buildSlider('P $p ', 0, 3, p, (newValue) {
                  //   setState(() {
                  //     p = newValue;
                  //   });
                  // }),
                  //Animation Duration
                  ..._buildSlider(
                    'Animation Duration ${d.toInt()} seconds ',
                    1,
                    maxAnimDuration.toDouble(),
                    d,
                    (newValue) {
                      setState(() {
                        d = newValue;
                      });
                      toggleAnimationOnly();
                    },
                    onPressed2: () {
                      var newValue = d - (d * .25);
                      if (newValue > 0) {
                        setState(() {
                          d = newValue;
                        });
                        toggleAnimationOnly();
                      }
                    },
                    onPressed3: () {
                      var newValue = d + (d * .25);
                      if (newValue < maxAnimDuration) {
                        setState(() {
                          d = newValue;
                        });
                        toggleAnimationOnly();
                      }
                    },
                  ),
                  ..._buildSlider(
                    'Line Width $lineWidth ',
                    0,
                    1,
                    lineWidth,
                    (newValue) {
                      setState(() {
                        lineWidth = newValue;
                      });
                    },
                    onPressed2: () {
                      var newValue = lineWidth - (lineWidth * .25);
                      if (newValue > 0) {
                        setState(() {
                          lineWidth = newValue;
                        });
                      }
                    },
                    onPressed3: () {
                      var newValue = lineWidth + (lineWidth * .25);
                      if (newValue < 1) {
                        setState(() {
                          lineWidth = newValue;
                        });
                      }
                    },
                  ),
                  verticalSpace(20),
                  _buildButtonsRow(context),
                  verticalSpace(40),

                  if (useGradaint)
                    _buildPickGradiant(context)
                  else
                    SizedBox(
                        height: 500,
                        width: 500,
                        child: _buildColorButton(context)),

                  verticalSpace(40),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  Row _buildButtonsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCircleButton(
            onPressed: () {
              setState(() {
                darkMode = !darkMode;
              });
            },
            icon: darkMode ? Icons.light_mode : Icons.dark_mode),
        horizontalSpace(20),
        _buildCircleButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SunflowerPages(),
                ));
          },
          icon: Icons.plagiarism_outlined,
        ),
        horizontalSpace(20),
        _buildCircleButton(
          onPressed: () {
            setState(() {
              isLarge = !isLarge;
            });
          },
          icon: isLarge ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        ),
        horizontalSpace(20),
        _buildCircleButton(
          onPressed: () {
            setState(() {
              useGradaint = !useGradaint;
            });
          },
          icon: Icons.insights,
        ),
        horizontalSpace(20),
      ],
    );
  }

  Column _buildPickGradiant(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        verticalSpace(40),
        SizedBox(height: 450, child: _pickStartColor(context)),
        verticalSpace(10),
        SizedBox(height: 450, child: _pickEndColor(context)),
        verticalSpace(40),
      ],
    );
  }

  Widget _buildColorButton(BuildContext context) {
    // return _buildCircleButton(
    //     onPressed: () async {
    //       var tempColor = lineColor;
    // await showDialog(
    //     context: context,
    //     builder: (_) {
    //       return StatefulBuilder(builder: (context, setStatPicker) {
    //         return AlertDialog(
    //           title: const Text('Pick a color!'),
    //           content: SingleChildScrollView(
    //             // child:
    return Theme(
      data:
          ThemeData(brightness: darkMode ? Brightness.dark : Brightness.light),
      child: ColorPicker(
        pickerColor: lineColor,
        onColorChanged: (Color newColor) {
          print('ashdfsadf');
          setState(() {
            lineColor = newColor;
          });
        },
      ),
    );
    // Use Material color picker:

    //         child: MaterialPicker(
    //           pickerColor: tempColor,
    //           onColorChanged: (Color newColor) {
    //             print('ashdfsadf');
    //             setStatPicker(() {
    //               tempColor = newColor;
    //             });
    //           },
    //         ),
    //       ),
    //       actions: <Widget>[
    //         ElevatedButton(
    //           child: const Text('Got it'),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //             setState(() {
    //               lineColor = tempColor;
    //             });
    //           },
    //         ),
    //       ],
    //     );
    //   });
    // });
    // },
    // icon: Icons.palette_outlined);
  }

  Widget _pickStartColor(BuildContext context) {
    return Theme(
      data:
          ThemeData(brightness: darkMode ? Brightness.dark : Brightness.light),
      child: ColorPicker(
        pickerAreaHeightPercent: .8,
        pickerColor: startColor,
        onColorChanged: (Color newColor) {
          setState(() {
            startColor = newColor;
          });
        },
      ),
    );
  }

  Widget _pickEndColor(BuildContext context) {
    return Theme(
      data:
          ThemeData(brightness: darkMode ? Brightness.dark : Brightness.light),
      child: ColorPicker(
        pickerAreaHeightPercent: .8,
        pickerColor: endColor,
        onColorChanged: (Color newColor) {
          setState(() {
            endColor = newColor;
          });
        },
      ),
    );
  }

  Row _buildStartReversT() {
    void Function(dynamic) onChange = (newValue) {
      // setState(() {
      t = newValue;
      _controller.value = newValue / maxTValue.toDouble();
      _startAnim();
      // });
    };
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            if (reversedAnim == false) _setReversed(true);

            toggleAnimation();
          },
          child: CircleAvatar(
            backgroundColor: primaryColor,
            child: Icon(
              isAnimating && reversedAnim ? Icons.pause : Icons.replay,
              color: Colors.white,
            ),
          ),
        ),
        ValueListenableBuilder<double>(
            valueListenable: _controller.view,
            builder: (context, double value, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: _buildSlider(
                    'T ${maxTValue * value} ', 0, maxTValue, t, onChange),
              );
            }),
        GestureDetector(
          onTap: () {
            if (reversedAnim == true) {
              _setReversed(false);
            }

            toggleAnimation();
          },
          child: CircleAvatar(
            backgroundColor: primaryColor,
            child: Icon(
              isAnimating && !reversedAnim ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  GestureDetector _buildCircleButton(
      {required void Function() onPressed, required IconData icon}) {
    return GestureDetector(
        onTap: onPressed,
        child: CircleAvatar(
          radius: 20,
          child: Icon(icon, color: Colors.orange[700]),
        ));
  }

  SizedBox verticalSpace(double value) => SizedBox(height: value);
  SizedBox horizontalSpace(double value) => SizedBox(width: value);

  void _setReversed(bool isReversed) {
    setState(() {
      reversedAnim = isReversed;
    });
  }

  List<Widget> _buildSlider(
    String data,
    double min,
    double max,
    double value,
    void onChanged(dynamic newValue), {
    BigInt? bigMax,
    void Function()? onPressed1,
    void Function()? onPressed2,
    void Function()? onPressed3,
    void Function()? onPressed4,
  }) {
    return [
      verticalSpace(25),
      Text(
        data,
        style: TextStyle(
            height: 1, color: darkMode ? Colors.orange : Colors.black),
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onPressed1 != null)
            GestureDetector(
                onTap: onPressed1,
                child: CircleAvatar(
                  radius: 15,
                  child: Icon(
                    Icons.remove,
                  ),
                )),
          if (onPressed2 != null)
            GestureDetector(
                onTap: onPressed2,
                onLongPress: onPressed2,
                child: CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.remove, color: Colors.orange),
                )),
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 300),
            child: Slider.adaptive(
              min: min,
              max: bigMax?.toDouble() ?? max,
              value: value,
              onChanged: onChanged,
            ),
          ),
          if (onPressed3 != null)
            GestureDetector(
                onTap: onPressed3,
                child: CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.add, color: Colors.orange),
                )),
          if (onPressed4 != null)
            GestureDetector(
                onTap: onPressed4,
                child: CircleAvatar(
                  radius: 15,
                  child: Icon(
                    Icons.remove,
                  ),
                )),
        ],
      ),
      verticalSpace(25),
    ];
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
