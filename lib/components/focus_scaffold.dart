import 'package:flutter/cupertino.dart';
import 'package:monolibro/components/logo_group.dart';
import 'package:monolibro/globals/theme_colors.dart';
import 'package:monolibro/globals/typography.dart';

class FocusScaffold extends StatelessWidget {
  const FocusScaffold({Key? key, this.child}) : super(key: key);
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    double bannerSize = MediaQuery.of(context).size.height * 0.38;
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(0, bannerSize, 0, 0),
          child: child,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: ThemeColors.defaultGradient,
            boxShadow: [
              BoxShadow(
                color: ThemeColors.defaultAppbarShadow,
                spreadRadius: 2,
                blurRadius: 5,
              )
            ],
          ),
          width: MediaQuery.of(context).size.width,
          height: bannerSize,
          padding: EdgeInsets.fromLTRB(
              10, MediaQuery.of(context).padding.top + 10, 10, 10),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: LogoGroup(
              fontSize: Typography.logoSizePrimary,
              logoSize: 50,
            ),
          ),
        ),
      ],
    );
  }
}
