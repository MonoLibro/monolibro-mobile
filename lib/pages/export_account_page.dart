import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monolibro/components/monolibro_scaffold.dart';
import 'package:monolibro/components/paragraph.dart';
import 'package:monolibro/globals/internationalization.dart';
import 'package:monolibro/globals/theme_colors.dart';

class ExportAccountPage extends StatefulWidget {
  const ExportAccountPage({Key? key}) : super(key: key);

  @override
  _ExportAccountPageState createState() => _ExportAccountPageState();
}

class _ExportAccountPageState extends State<ExportAccountPage> {
  Map text = {};
  bool showWarning = true;

  String getText(String key) {
    if (text == {}) return "";
    return text[key].toString();
  }

  getData() async {
    var result = await Internationalization.getTranslationObject(
        context, "export_account_page");
    setState(() {
      text = result;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Widget buildWarningMessage(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(15),
        constraints: BoxConstraints(
          maxHeight: 200,
          maxWidth: MediaQuery.of(context).size.width - 10,
        ),
        decoration: BoxDecoration(
          color: ThemeColors.errorAccent[1],
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.defaultPanelShadow,
              blurRadius: 10,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(
                CarbonIcons.warning_alt,
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 1, bottom: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Paragraph(
                      text: getText("warningTitle"),
                      weight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Paragraph(
                          text: getText("warningContent"),
                          color: Colors.white,
                          size: 14,
                        ))
                  ],
                ),
              )
            ]),
            Container(
                height: 50,
                decoration: BoxDecoration(
                  color: ThemeColors.errorAccent[0],
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Material(
                    color: const Color(0x00000000),
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            showWarning = false;
                          });
                        },
                        child: Center(
                            child: Paragraph(
                          text: getText("warningConfirm"),
                          color: Colors.white,
                        )))))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    double qrSize = MediaQuery.of(context).size.width - 100;
    return MonolibroScaffold(
      title: getText("title"),
      color: ThemeColors.grayAccent[1],
      body: Stack(
        children: [
          Visibility(
              visible: !showWarning,
              child: Center(
                  child: Container(
                      color: Colors.white,
                      width: qrSize,
                      height: qrSize,
                      padding: const EdgeInsets.all(30),
                      child: Stack(
                        children: [
                          const Center(child: CircularProgressIndicator()),
                          Image.network(
                              "https://api.qrserver.com/v1/create-qr-code/?size=500x500&data=Example")
                        ],
                      )))),
          Visibility(
              visible: showWarning,
              child: Center(child: buildWarningMessage(context))),
        ],
      ),
    );
  }
}
