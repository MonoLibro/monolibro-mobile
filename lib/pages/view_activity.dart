import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monolibro/components/monolibro_scaffold.dart';
import 'package:monolibro/globals/internationalization.dart';
import 'package:monolibro/components/paragraph.dart';
import 'package:monolibro/globals/theme_colors.dart';
import 'package:monolibro/globals/typography.dart' as t;

class ViewActivity extends StatefulWidget{
  const ViewActivity({Key? key}) : super(key: key);

  @override
  _ViewActivityState createState() => _ViewActivityState();
}

class _ViewActivityState extends State<ViewActivity>{
  Map text = {};

  String getText(String key){
    if (text == {}) return "";
    return text[key].toString();
  }

  getData() async {
    var result = await Internationalization.getTranslationObject(context, "view_activity");
    setState(() {
      text = result;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Widget buildQrArea(BuildContext context, String code){
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
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: SizedBox(
              child: Image.network('https://api.qrserver.com/v1/create-qr-code/?size=500x500&data=$code&color=197-148-22')
            ),
          )
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 6; i++)
            Padding(
              padding: const EdgeInsets.all(5) ,
              child: Container(
                color: Colors.white,
                width: 40,
                height: 40,
                child: Center(
                  child: Paragraph(
                    text: code.substring(i, i+1),
                    size: 25,
                    color: ThemeColors.defaultAccent[3]
                  )
                )
              )
            )
          ],
        )
      ],
    );
  }

  Widget buildParticipantsPanel(BuildContext context){
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
        )
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child:  Paragraph(
              text: "Participants",
              size: 22,
            ),
          ),
          for (int i = 0; i < 10; i ++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Paragraph(
                  text: "hello",
                  size: 22,
                ),
                Paragraph(
                  text: "world",
                  size: 22,
                ),
              ],
            ),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context){
    return MonolibroScaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 20),
                child: Paragraph(
                  text: "Lunch with the team",
                  size: t.Typography.logoSizePrimary - 5,
                  weight: FontWeight.w500,
                )
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, bottom: 20),
                child: Paragraph(
                  text: "Lunch with the team",
                  size: t.Typography.focusSize,
                  color: ThemeColors.grayAccent[3],
                )
              ),
              buildQrArea(context, "123456"),
              const SizedBox(height: 30),
              buildParticipantsPanel(context)
            ]
          ),
        )
      ),
      title: "hello",
      color: ThemeColors.grayAccent[1]
    );
  }
}