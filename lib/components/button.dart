import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:monolibro/globals/theme_colors.dart';
import 'package:monolibro/globals/typography.dart' as t;

class Button extends StatelessWidget{
  const Button({Key? key, required this.text, required this.onPressed}) : super(key: key);
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.defaultAccent[3],
        boxShadow: [
          BoxShadow(
            color: ThemeColors.defaultButtonShadow,
            blurRadius: 10,
          )
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(text),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
          primary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          textStyle: TextStyle(
            fontSize: t.Typography.paragraphSize,
            fontFamily: t.Typography.latinFontPrimary,
            fontWeight: FontWeight.bold
          ),
        )
      ),
    );
  }
}