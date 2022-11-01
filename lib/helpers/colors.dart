import 'package:flutter/material.dart';

class MyColors {
  static const MaterialColor pallete =
      MaterialColor(_palletePrimaryValue, <int, Color>{
    50: Color(0xFFE0ECFD),
    100: Color(0xFFB3CFFA),
    200: Color(0xFF80AFF7),
    300: Color(0xFF4D8EF4),
    400: Color(0xFF2676F1),
    500: Color(_palletePrimaryValue),
    600: Color(0xFF0056ED),
    700: Color(0xFF004CEB),
    800: Color(0xFF0042E8),
    900: Color(0xFF0031E4),
  });
  static const int _palletePrimaryValue = 0xFF005EEF;

  static const MaterialColor palleteAccent =
      MaterialColor(_palleteAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_palleteAccentValue),
    400: Color(0xFFA5B3FF),
    700: Color(0xFF8B9DFF),
  });
  static const int _palleteAccentValue = 0xFFD8DEFF;

  static const codGray = Color(0xFF070706);
  static const darkGray = Color(0xFF3B3B3B);
  static const lightGray = Color(0xFF919191);
  static const white = Colors.white;
  static const red = Colors.red;
  static const orange = Colors.orange;
  static final lightBlue = Colors.blue.shade200;
  static final lightPink = Colors.pink.shade200;
  static final lightGreen = Colors.green.shade200;
  static final lightAmber = Colors.amber.shade200;
  static final lightCyan = Colors.cyan.shade200;
  static final lightDeepOrange = Colors.deepOrange.shade200;
  static final lightPurple = Colors.purple.shade200;
  static final lightDeepPurple = Colors.deepPurple.shade200;
  static final lightIndigo = Colors.indigo.shade200;
  static final lightLime = Colors.lime.shade200;
  static final lightRed = Colors.red.shade200;
  static final lightTeal = Colors.teal.shade200;

  static final list = <Color>[
    lightBlue,
    lightPink,
    lightGreen,
    lightAmber,
    lightCyan,
    lightDeepOrange,
    lightPurple,
    lightDeepPurple,
    lightIndigo,
    lightLime,
    lightRed,
    lightTeal,
  ];
}
