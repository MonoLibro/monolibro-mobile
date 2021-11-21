import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monolibro/components/paragraph.dart';
import 'package:monolibro/globals/theme_colors.dart';
import 'package:monolibro/globals/typography.dart' as t;

class Dashboard extends StatefulWidget {
  Dashboard({Key? key, required this.text, required this.index})
      : super(key: key);
  Map text;
  int index;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String getText(String key) {
    if (widget.text == {}) return "";
    return widget.text[key].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Paragraph(
              text: getText("dashboard"),
              size: t.Typography.panelTitle,
            )),
        Padding(
            padding: const EdgeInsets.only(right: 30, top: 30, left: 10),
            child: Container(
                height: 150,
                width: 300,
                decoration: BoxDecoration(
                    color: ThemeColors.grayAccent[1],
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          child: Paragraph(
                            text: getText("spent"),
                          )),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(5),
                        child: Paragraph(
                          text: "123.45",
                          color: ThemeColors.defaultAccent[3],
                          size: t.Typography.largeNumber,
                          weight: FontWeight.w300,
                        )),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding: const EdgeInsets.only(right: 10, bottom: 5),
                          child: Paragraph(
                            text: getText("thisMonth"),
                          )),
                    ),
                  ],
                ))),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Paragraph(
                    text: getText("requiredOut"),
                  )),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 30),
                  child: Paragraph(
                    text: "123.45",
                    color: ThemeColors.successAccent[0],
                  )),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 30),
          child: Container(
            color: ThemeColors.grayAccent[2],
            height: 3,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Paragraph(
                    text: getText("requiredIn"),
                  )),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 30),
                  child: Paragraph(
                    text: "123.00",
                    color: ThemeColors.errorAccent[0],
                  )),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 30),
          child: Container(
            color: ThemeColors.grayAccent[2],
            height: 3,
          ),
        ),
      ],
    ));
  }
}
