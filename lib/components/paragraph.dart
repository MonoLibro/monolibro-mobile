import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monolibro/globals/theme_colors.dart';
import 'package:monolibro/globals/typography.dart' as t;

class Paragraph extends StatelessWidget{
  const Paragraph({Key? key, this.text, this.color, this.size, this.weight}) : super(key: key);
  final String? text;
  final Color? color;
  final double? size;
  final FontWeight? weight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      style: TextStyle(
        fontFamily: t.Typography.latinFontPrimary,
        fontSize: size ?? t.Typography.paragraphSize,
        color: color ?? ThemeColors.grayAccent[3],
        decoration: TextDecoration.none,
        fontWeight: FontWeight.normal
      ),
    );
  }
  
}