import 'package:flutter/cupertino.dart';
import 'package:monolibro/globals/theme_colors.dart';
import 'package:monolibro/globals/typography.dart';

class LogoGroup extends StatelessWidget {
  const LogoGroup({Key? key, this.fontSize, this.logoSize}) : super(key: key);

  final double? fontSize;
  final double? logoSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: logoSize,
          height: logoSize,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Image.asset(
            "assets/Logo.png",
            scale: (logoSize == null) ? 10 : null,
          ),
        ),
        Text("Mono",
            style: TextStyle(
              color: ThemeColors.defaultAccent[3],
              decoration: TextDecoration.none,
              fontWeight: FontWeight.normal,
              fontFamily: Typography.latinFontPrimary,
              fontSize: fontSize,
            )),
        Text("Libro",
            style: TextStyle(
              color: ThemeColors.grayAccent[3],
              decoration: TextDecoration.none,
              fontWeight: FontWeight.w300,
              fontFamily: Typography.latinFontPrimary,
              fontSize: fontSize,
            )),
      ],
    );
  }
}
