import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:monolibro/components/button.dart';
import 'package:monolibro/components/paragraph.dart';
import 'package:monolibro/globals/local_storage.dart';
import 'package:monolibro/globals/theme_colors.dart';
import 'package:monolibro/globals/typography.dart' as t;
import 'package:monolibro/globals/ws_control.dart';
import 'package:monolibro/monolibro/models/activity.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key, required this.text, required this.index})
      : super(key: key);
  Map text;
  int index;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool notification = false;
  
  String getText(String key) {
    if (widget.text == {}) return "";
    return widget.text[key].toString();
  }

  Future<void> toggleNotification() async {
    print("awa");
    bool notification = false;
    if (await LocalStorage.hasItem("notification")){
      notification = (await LocalStorage.getItem("notification")) == "true";
    }
    String status = (!notification) ? "On" : "Off";
    Fluttertoast.showToast(
      msg: "Monthly notification: $status",
    );
    await LocalStorage.setItem("notification", (!notification) ? "true" : "false");
    this.notification = !notification;
  }

  @override
  Widget build(BuildContext context) {
    double totalSelfPrice = 0;
    var keys = wsClientGlobal.wsClient.state.activities.keys;
    for (var i in keys){
      Activity a = wsClientGlobal.wsClient.state.activities[i]!;
      totalSelfPrice += a.getSelfSum();
    }
    return Expanded(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Paragraph(
            text: getText("dashboard"),
            size: t.Typography.panelTitle,
          )
        ),
        Padding(
          padding: const EdgeInsets.only(right: 30, top: 30, left: 10),
          child: Container(
            height: 150,
            width: 300,
            decoration: BoxDecoration(
              color: ThemeColors.grayAccent[1],
              borderRadius: const BorderRadius.all(Radius.circular(10))
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Paragraph(
                      text: getText("spent"),
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Paragraph(
                    text: totalSelfPrice.toString(),
                    color: ThemeColors.defaultAccent[3],
                    size: t.Typography.largeNumber,
                    weight: FontWeight.w300,
                  )
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10, bottom: 5),
                    child: Paragraph(
                      text: getText("thisMonth"),
                    )
                  ),
                ),
              ],
            )
          )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Button(
                text: "Remainder",
                onPressed: (){
                  toggleNotification();
                }
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Button(
                text: "Clear",
                onPressed: (){
                  
                }
              ),
            )
          ],
        ),
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
                )
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 30),
                child: Paragraph(
                  text: "0.00",
                  color: ThemeColors.successAccent[0],
                )
              ),
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
                  )
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 30),
                  child: Paragraph(
                    text: "0.00",
                    color: ThemeColors.errorAccent[0],
                  )
                ),
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
      )
    );
  }
}
