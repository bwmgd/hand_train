import 'package:flutter/material.dart';

class MyThemeData {
  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.transparent);

  static ThemeData darkTheme = ThemeData.dark()
      .copyWith(scaffoldBackgroundColor: const Color(0xB32F3F47));
}
