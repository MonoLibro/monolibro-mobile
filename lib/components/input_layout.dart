import 'package:carbon_icons/carbon_icons.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monolibro/components/paragraph.dart';
import 'package:monolibro/globals/theme_colors.dart';
import 'package:monolibro/controls/input_layout_control.dart';
import 'package:monolibro/globals/typography.dart' as t;

class InputLayout extends StatelessWidget{
  const InputLayout({Key? key, required this.control}) : super(key: key);
  final int sidebarWidthThreshold = 50;
  final InputLayoutControl control;

  List<Widget> buildGroups(BuildContext context, double sidebarWidth){
    List<Widget> result = [];
    for (var i = 0; i < control.count; i++){
      var group = control.builder(i);
      var expandable = group.expandable ?? false;
      Widget title = Row(
        children: [
          SizedBox(
            width: sidebarWidth,
            child: group.icon,
          ),
          Visibility(
            visible: expandable,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Expandable(
                expanded: const Icon(CarbonIcons.chevron_down),
                collapsed: const Icon(CarbonIcons.chevron_right),
              )
            )
          ),
          Container(
            margin: EdgeInsets.only(left: expandable ? 0: 20),
            child: Paragraph(
              size: t.Typography.focusSize,
              text: group.title,
              weight: FontWeight.w100,
            ),
          ),
        ],
      );
      if (expandable){
        title = Material(
          color: const Color(0x00000000),
          child: ExpandableButton(child: title)
        );
      }
      List<Widget> columnContents = [];
      for (var j = 0; j < group.count; j++){
        Widget item = group.inputBuilder(j);
        columnContents.add(
          Padding(
            child: item,
            padding: EdgeInsets.fromLTRB(sidebarWidth + 20, 10, 10 ,10),
          )
        );
      }
      Widget column;
      if (expandable){
        column = Expandable(
          expanded: Column(children: columnContents),
          collapsed: Container(),
        );
      }
      else {
        column = Column(children: columnContents);
      }
      if (expandable){
        result.add(
          ExpandableNotifier(
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              child:Column(
                children: [
                  title,
                  column,
                ]
              ),
            ),
          ),
        );
      }
      else {
        result.add(
          Container(
            padding: const EdgeInsets.only(top: 10),
            child:Column(
              children: [
                title,
                column,
              ]
            ),
          ),
        );
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    double sidebarWidth = MediaQuery.of(context).size.width * 0.20;
    if (sidebarWidth < sidebarWidthThreshold){
      sidebarWidth = sidebarWidthThreshold.toDouble();
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                color: ThemeColors.grayAccent[1],
                width: sidebarWidth,
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            child: SingleChildScrollView(
              child: Column(
                children: buildGroups(context, sidebarWidth),
              )
            )
          )
        ],
      )
    );
  }
}