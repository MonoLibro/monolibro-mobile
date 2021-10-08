import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:monolibro/components/focus_scaffold.dart';
import 'package:monolibro/components/large_icon_button.dart';
import 'package:monolibro/components/paragraph.dart';
import 'package:monolibro/globals/internationalization.dart';
import 'package:monolibro/globals/theme_colors.dart';
import 'package:monolibro/globals/typography.dart' as t;

class AccountInitPage extends StatefulWidget{
  const AccountInitPage({Key? key}) : super(key: key);

  @override
  _AccountInitPageState createState() => _AccountInitPageState();
}

class _AccountInitPageState extends State<AccountInitPage>{
  Map text = {};
  final promptSequence = ["hasAccount","newToApp"];
  final buttonSequence = ["importAccount","newAccount"];
  final pageSequence = ["/init/importaccount", "/init/newaccount"];
  final buttonIconSequence = [
    FaIcon(
      FontAwesomeIcons.fileImport,
      color: ThemeColors.grayAccent[0],
      size: 40,
    ),
    Icon(
      Icons.person_add,
      color: ThemeColors.grayAccent[0],
      size: 40,
    )
  ];

  String getText(String key){
    if (text == {}) return "";
    return text[key].toString();
  }

  getData() async {
    var result = await Internationalization.getTranslationObject(context, "account_init_page");
    setState(() {
      text = result;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Widget buildOption(int index){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Paragraph(text:getText(promptSequence[index])),
        ),
        LargeIconButton(
          text: getText(buttonSequence[index]),
          icon: buttonIconSequence[index],
          onTap: (){
            Navigator.pushNamed(context, pageSequence[index]);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context){
    return Container(
      color: Colors.white,
      child: FocusScaffold(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                getText("getStarted"),
                style: TextStyle(
                  fontFamily: t.Typography.latinFontPrimary,
                  color: ThemeColors.defaultAccent[3],
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildOption(0),
                  buildOption(1),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}