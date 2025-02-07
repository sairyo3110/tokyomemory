// constants.dart
import 'package:flutter/material.dart';

class Constants {
  static const double bottomNavigationHeight = 58.0;

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
