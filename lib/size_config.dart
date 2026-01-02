import 'package:flutter/material.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;
  static late double scaleWidth;
  static late double scaleHeight;

  static const double baseWidth = 360;
  static const double baseHeight = 800;

  static void init(BuildContext context) {
    final mq = MediaQuery.of(context);
    _init(mq.size.width, mq.size.height);
  }

  static void initWithConstraints(BoxConstraints constraints) {
    final width = constraints.maxWidth;
    final height = constraints.maxHeight;
    if (width == 0 || height == 0) return;
    _init(width, height);
  }

  static void _init(double width, double height) {
    screenWidth = width;
    screenHeight = height;
    scaleWidth = screenWidth / baseWidth;
    scaleHeight = screenHeight / baseHeight;
  }

  static double w(double size) => size * scaleWidth;
  static double h(double size) => size * scaleHeight;
  static double sp(double size) {
    final scale = (scaleWidth < scaleHeight) ? scaleWidth : scaleHeight;
    if (scale <= 0 || scale.isNaN) return size;
    return size * scale.clamp(0.8, 1.3);
  }
}
