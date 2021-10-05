import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monolibro/components/paragraph.dart';
import 'package:monolibro/globals/theme_colors.dart';
import 'package:monolibro/globals/typography.dart' as T;

class LargeIconButton extends StatelessWidget{
  const LargeIconButton({Key? key, required this.icon, required this.text, required this.onTap}) : super(key: key);
  final Widget icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: ThemeColors.defaultButtonShadow,
            blurRadius: 10,
          )
        ],
      ),
      child: Material(
        color: ThemeColors.defaultAccent[3],
        child: InkWell(
          splashColor: ThemeColors.defaultAccent[2],
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: icon,
              ),
              Paragraph(
                text: text,
                color: ThemeColors.grayAccent[0],
                size: T.Typography.buttonSize,
              )
            ],
          ),
        ),
      ),
    );
  }
}