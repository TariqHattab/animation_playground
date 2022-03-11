import 'package:animation_playground/pages/cureves_animations.dart';
import 'package:animation_playground/pages/homepage.dart';
import 'package:animation_playground/pages/sunflower.dart';
import 'package:animation_playground/pages/sunflower_pages/plus_one_line.dart';
import 'package:animation_playground/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: buttonsColor,
        primarySwatch: buttonsColor,
        iconTheme: IconThemeData(color: Colors.orange),
        sliderTheme: SliderThemeData.fromPrimaryColors(
          primaryColor: Colors.orange,
          primaryColorLight: Colors.orange,
          primaryColorDark: Colors.orange,
          valueIndicatorTextStyle: DefaultTextStyle.fallback().style,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: SunflowerLine(),
    );
  }
}

class Pages extends StatelessWidget {
  const Pages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        // HomePage(),
        // CurvesAnimations(),
        SunflowerPages(),
      ],
    );
  }
}
