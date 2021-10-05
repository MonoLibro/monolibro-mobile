import 'package:flutter/cupertino.dart';
import 'package:monolibro/globals/theme_colors.dart';
import 'package:monolibro/globals/typography.dart';

class LoadingLogo extends StatelessWidget{
  const LoadingLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Image.asset(
            "assets/Logo.png",
            scale: 10,
          ),
        ),
        Text(
          "Mono",
          style: TextStyle(
            color: ThemeColors.defaultAccent[3],
            decoration: TextDecoration.none,
            fontWeight: FontWeight.normal,
            fontFamily: Typography.latinFontPrimary,
          )
        ),
        Text(
          "Libro",
          style: TextStyle(
            color: ThemeColors.grayAccent[3],
            decoration: TextDecoration.none,
            fontWeight: FontWeight.w300,
            fontFamily: Typography.latinFontPrimary,
          )
        ),
      ],
    );
  }
}