import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monolibro/components/logo_group.dart';
import 'package:monolibro/globals/theme_colors.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: ThemeColors.defaultGradient,
      ),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        const LogoGroup(),
        CircularProgressIndicator(
          color: ThemeColors.defaultAccent[3],
        ),
      ]),
    );
  }
}
