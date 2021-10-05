import 'package:flutter/painting.dart';

class ThemeColors{
  static var defaultAccent = [
    const Color(0xFFFFF2CC),
    const Color(0xFFFFE699),
    const Color(0xFFFFD966),
    const Color(0xFFBF9000),
  ];

  static var grayAccent = [
    const Color(0xFFFFFFFF),
    const Color(0xFFF2F2F2),
    const Color(0xFFD9D9D9),
    const Color(0xFF404040),
    const Color(0xFF262626),
  ];

  static var defaultGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors:[
      ThemeColors.defaultAccent[1],
      ThemeColors.defaultAccent[0],
    ],
  );

  static var defaultButtonShadow = const Color(0x44000000);
}