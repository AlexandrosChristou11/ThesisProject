import 'package:flutter/material.dart';
import 'package:sep21/Screens/bottom_bar.dart';
import 'package:sep21/Screens/feed.dart';
import 'package:sep21/Widgets/feeds_products.dart';

class MainScreens extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return PageView(children: [
      BottomBarScreen(), Feed()
    ],);
  }
}

