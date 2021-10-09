import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monolibro/components/logo_group.dart';
import 'package:monolibro/globals/theme_colors.dart';
import 'package:monolibro/globals/typography.dart' as t;

class MonolibroScaffold extends StatelessWidget{
  const MonolibroScaffold({Key? key, this.title, this.color, this.body, this.popButton, this.left, this.fullIcon}) : super(key: key);
  final String? title;
  final Color? color;
  final Widget? body;
  final bool? popButton;
  final Widget? left;
  final bool? fullIcon;

  @override
  Widget build(BuildContext context){
    bool hasTitle = title != null;
    bool hasPopButton = popButton ?? true;
    bool hasFullIcon = fullIcon ?? false;
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: hasTitle ? 178 : 110),
          color: color ?? const Color(0xFFFFFFFF),
          child: body,
        ),
        Visibility(
          visible: hasTitle,
          child: Positioned(
            top: 110,
            child: Container(
              height: 68,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(hasPopButton ? 10 : 25 , 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Visibility(
                        visible: popButton ?? true,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Material(
                            color: ThemeColors.defaultAccent[0],
                            child: IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              color: ThemeColors.grayAccent[3],
                              splashColor: ThemeColors.defaultAccent[1],
                              focusColor: ThemeColors.defaultAccent[1],
                              hoverColor: ThemeColors.defaultAccent[1],
                              highlightColor: ThemeColors.defaultAccent[1],
                              icon: const Icon(Icons.arrow_back_ios_new),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        title ?? "",
                        style: TextStyle(
                          fontSize: t.Typography.appbarTitleSize,
                          decoration: TextDecoration.none,
                          color: ThemeColors.grayAccent[3],
                          fontFamily: t.Typography.latinFontPrimary,
                          fontWeight: FontWeight.w200,
                        )
                      )
                    ],
                  ),
                  Container(
                    child: left,
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: ThemeColors.defaultAccent[0],
                boxShadow: [BoxShadow(
                  color: ThemeColors.defaultAppbarShadow,
                  spreadRadius: 2,
                  blurRadius: 5,
                )],
              ),
            ),
          ),
        ),
        Container(
          height: 110,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 10, 10, 10),
          child: Stack(
            children: [
              Visibility(
                visible: ! hasFullIcon,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child:Image.asset("assets/Logo.png")
                  )
                ),
              ),
              Visibility(
                visible: hasFullIcon,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: LogoGroup(
                    fontSize: t.Typography.logoSizePrimary,
                    logoSize: 50,
                  ),
                )
              ),
            ],
          ),
          decoration: BoxDecoration(
            gradient: ThemeColors.defaultGradient,
            boxShadow: [BoxShadow(
              color: ThemeColors.defaultAppbarShadow,
              spreadRadius: 2,
              blurRadius: 5,
            )],
          ),
        ),
      ],
    );
  }
}