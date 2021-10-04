import 'package:flutter/cupertino.dart';
import 'package:monolibro/globals/theme_colors.dart';

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
            fontFamily: "TitilliumWeb",
          )
        ),
        Text(
          "Libro",
          style: TextStyle(
            color: ThemeColors.grayAccent[3],
            decoration: TextDecoration.none,
            fontWeight: FontWeight.w300,
            fontFamily: "TitilliumWeb",
          )
        ),
      ],
    );
  }
}