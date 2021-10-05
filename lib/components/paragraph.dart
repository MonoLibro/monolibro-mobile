import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monolibro/globals/theme_colors.dart';
import 'package:monolibro/globals/typography.dart' as T;

class Paragraph extends StatelessWidget{
  const Paragraph({Key? key, this.text, this.color}) : super(key: key);
  final String? text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      style: TextStyle(
        fontFamily: T.Typography.latinFontPrimary,
        fontSize: T.Typography.paragraphSize,
        color: color ?? ThemeColors.grayAccent[3],
        decoration: TextDecoration.none,
        fontWeight: FontWeight.normal
      ),
    );
  }
  
}