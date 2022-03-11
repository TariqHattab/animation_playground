import 'package:animation_playground/pages/sunflower_pages/normal_extra_sliders.dart';
import 'package:animation_playground/pages/sunflower_pages/normal_sunflower.dart';
import 'package:animation_playground/pages/sunflower_pages/plus_one_line.dart';
import 'package:animation_playground/pages/sunflower_pages/primary_line.dart';
import 'package:animation_playground/pages/sunflower_pages/sqroot.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

final pagePacket = PageStorageBucket();

class SunflowerPages extends StatelessWidget {
  const SunflowerPages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageStorage(
      bucket: pagePacket,
      child: PageView(
        allowImplicitScrolling: true,
        key: PageStorageKey<String>('mainPage'),
        scrollDirection: Axis.vertical,
        children: [
          Sunflower(),
          SFExtraSliders(),
          // SunflowerLine(),
          SunflowerPrimaryLine(),
          SFsqrt(),
        ],
      ),
    );
  }
}
