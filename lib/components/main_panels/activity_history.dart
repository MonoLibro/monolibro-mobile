import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monolibro/components/paragraph.dart';
import 'package:monolibro/globals/theme_colors.dart';
import 'package:monolibro/globals/typography.dart' as t;

class ActivityHistory extends StatefulWidget {
  const ActivityHistory({Key? key, required this.text, required this.index})
      : super(key: key);
  final Map text;
  final int index;

  @override
  _ActivityHistoryState createState() => _ActivityHistoryState();
}

class _ActivityHistoryState extends State<ActivityHistory> {
  String getText(String key) {
    if (widget.text == {}) return "";
    return widget.text[key].toString();
  }

  Widget buildListItem(BuildContext context, int index, int maxIndex,
      bool pending, String date, double price, String title) {
    double position = 0;
    double size = 60;
    if (maxIndex == 1) {
      size = 0;
    }
    if (index == 0 && maxIndex > 1) {
      position = 30;
      size = 30;
    }
    if ((index == (maxIndex - 1)) && (maxIndex > 1)) {
      position = 0;
      size = 30;
    }
    Color textColor =
        pending ? ThemeColors.defaultAccent[3] : ThemeColors.successAccent[1];
    Color dotColor =
        pending ? ThemeColors.defaultAccent[3] : ThemeColors.successAccent[0];
    return Material(
        color: const Color(0x00000000),
        child: InkWell(
            onTap: () {},
            child: SizedBox(
                height: 60,
                child: Row(children: [
                  Stack(
                    children: [
                      Positioned(
                          left: 39,
                          top: position,
                          child: Container(
                            color: ThemeColors.grayAccent[3],
                            width: 2,
                            height: size,
                          )),
                      SizedBox(
                          width: 80,
                          child: Center(
                              child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(7)),
                              color: dotColor,
                            ),
                          ))),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 15, top: 5),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Paragraph(
                              text: title,
                            ),
                            Row(
                              children: [
                                Paragraph(
                                  text: pending ? getText("pending") : date,
                                  size: t.Typography.subheaderSize,
                                  color: textColor,
                                ),
                                Paragraph(
                                  text: " | ",
                                  size: t.Typography.subheaderSize,
                                  // color: textColor,
                                ),
                                Paragraph(
                                  text: price.toStringAsFixed(2),
                                  size: t.Typography.subheaderSize,
                                  color: textColor,
                                ),
                              ],
                            )
                          ]))
                ]))));
  }

  @override
  Widget build(BuildContext context) {
    int scrollPadding = ((widget.index == 2) ? 270 : 350);
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(color: ThemeColors.grayAccent[1], width: 80),
        ),
        Align(
            alignment: Alignment.topCenter,
            child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Paragraph(
                  text: getText("activityHistory"),
                  size: t.Typography.panelTitle,
                ))),
        Positioned(
            bottom: 30,
            child: SizedBox(
                width: MediaQuery.of(context).size.width - 100,
                height: MediaQuery.of(context).size.height - scrollPadding,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                      // History childs
                      children: [
                        for (var j = 0; j < 20; j++)
                          buildListItem(context, j, 20, j == 0, "2020-10-10",
                              40, "Title_$j"),
                      ]),
                )))
      ],
    );
  }
}
