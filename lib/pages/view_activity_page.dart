import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monolibro/components/monolibro_scaffold.dart';
import 'package:monolibro/components/paragraph.dart';
import 'package:monolibro/globals/internationalization.dart';
import 'package:monolibro/globals/theme_colors.dart';
import 'package:monolibro/globals/typography.dart' as t;
import 'package:monolibro/globals/ws_control.dart';
import 'package:monolibro/monolibro/models/activity.dart';
import 'package:monolibro/monolibro/models/activity_entry.dart';

class ViewActivityPage extends StatefulWidget {
  const ViewActivityPage({Key? key}) : super(key: key);

  @override
  _ViewActivityPageState createState() => _ViewActivityPageState();
}

class _ViewActivityPageState extends State<ViewActivityPage> {
  Map text = {};
  Map data = {};
  late Activity activity;

  String getText(String key) {
    if (text == {}) return "";
    return text[key].toString();
  }

  getData() async {
    var result = await Internationalization.getTranslationObject(
        context, "view_activity_page");
    setState(() {
      text = result;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Widget buildParticipant(BuildContext context, String name, String payment, bool isSelf){
    print("in  11");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Paragraph(
            text: name,
            size: 22,
            color: isSelf ? ThemeColors.defaultAccent[3] : null,
          ),
          Paragraph(
            text: payment,
            size: 22,
            color: isSelf ? ThemeColors.defaultAccent[3] : null,
          ),
        ],
      ),
    );
  }

  List<Widget> buildOtherParticipants(context){
    List<Widget> result = [];
    String selfID = wsClientGlobal.wsClient.state.localUser!.userID;
    for (ActivityEntry entry in activity.entries){
      if (entry.user.userID == selfID) continue;
      String name = entry.user.firstName + " " + entry.user.lastName;
      result.add(
        buildParticipant(context, name, entry.price.toStringAsPrecision(2), false)
      );
    }
    return result;
  }

  Widget buildQrArea(BuildContext context, String code) {
    double size = MediaQuery.of(context).size.width - 140;
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: Container(
              width: size,
              height: size,
              padding: const EdgeInsets.all(45),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: SizedBox(
                  child: Image.network(
                      'https://api.qrserver.com/v1/create-qr-code/?size=500x500&data=$code&color=197-148-22')),
            )),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 6; i++)
              Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                      color: Colors.white,
                      width: 40,
                      height: 40,
                      child: Center(
                          child: Paragraph(
                              text: code.substring(i, i + 1),
                              size: 25,
                              color: ThemeColors.defaultAccent[3]))))
          ],
        )
      ],
    );
  }

  Widget buildParticipantsPanel(BuildContext context) {
    String selfName = wsClientGlobal.wsClient.state.localUser!.firstName + " " + wsClientGlobal.wsClient.state.localUser!.lastName;
    return Container(
        width: MediaQuery.of(context).size.width,
        constraints: const BoxConstraints(
          minHeight: 150,
        ),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            )),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Paragraph(
                text: getText("members"),
                size: 22,
              ),
            ),
            buildParticipant(context, selfName, activity.getSelfSum().toStringAsFixed(2), true),
            for (Widget i in buildOtherParticipants(context)) i,
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments! as Map;
    activity = wsClientGlobal.wsClient.state.getActivity(data["activity"])!;
    return MonolibroScaffold(
      body: SingleChildScrollView(
        child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 20),
              child: Paragraph(
                text: activity.name,
                size: t.Typography.logoSizePrimary - 5,
                weight: FontWeight.w500,
              )
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 20),
              child: Paragraph(
                text: getText("youPaid") + activity.getSelfSum().toStringAsFixed(2) + " | " + getText("totalPaid") + activity.totalPrice.toStringAsFixed(2),
                size: t.Typography.focusSize - 5,
                color: ThemeColors.grayAccent[3],
              )
            ),
            buildQrArea(context, activity.code),
            const SizedBox(height: 30),
            buildParticipantsPanel(context)
          ]
        ),
      )
    ),
    title: getText("title"),
    color: ThemeColors.grayAccent[1]);
  }
}
