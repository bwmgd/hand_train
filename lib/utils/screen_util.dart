import 'dart:ui';

import 'package:flutter/material.dart';

class ScreenUtil {
  static final MediaQueryData _window = MediaQueryData.fromWindow(window);
  static final double screenHeight = _window.size.height;
  static final double screenWidth = _window.size.width;
  static final double statusBarHeight = _window.padding.top;
}
