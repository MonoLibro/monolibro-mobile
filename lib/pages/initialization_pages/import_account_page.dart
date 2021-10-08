import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:monolibro/components/monolibro_scaffold.dart';
import 'package:monolibro/components/paragraph.dart';
import 'package:monolibro/globals/internationalization.dart';
import 'package:monolibro/globals/theme_colors.dart';
import 'package:monolibro/globals/typography.dart' as t;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sprintf/sprintf.dart';

class ImportAccountPage extends StatefulWidget{
  const ImportAccountPage({Key? key}) : super(key: key);

  @override
  _ImportAccountPageState createState() => _ImportAccountPageState();
}

class _ImportAccountPageState extends State<ImportAccountPage>{
  Map text = {};
  var qrKey = GlobalKey(debugLabel: "importQr");
  QRViewController? qrViewController;

  @override
  void dispose(){
    qrViewController?.dispose();
    super.dispose();
  }

  Future<void> getData() async {
    var result = await Internationalization.getTranslationObject(context, "import_account_page");
    setState(() {
      text = result;
    });
  }

  String getText(String key){
    if (text == {}) return "";
    return text[key].toString();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Widget buildTutorial(int index){
    double horizontalMargin = MediaQuery.of(context).size.width * 0.20;
    double contentWidth = MediaQuery.of(context).size.width - horizontalMargin * 2;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: contentWidth,
            height: contentWidth,
            decoration: BoxDecoration(
              color: ThemeColors.grayAccent[2],
              borderRadius: const BorderRadius.all(Radius.circular(25)),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            width: contentWidth,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Paragraph(
                text: sprintf(getText("step"), [getText((index+1).toString())]),
                color: ThemeColors.defaultAccent[3],
                size: t.Typography.focusSize,
              ),
            ),
          ),
          SizedBox(
            width: contentWidth,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Paragraph(
                text: getText("instruction_$index"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildScanner() => QRView(
    key: qrKey,
    onQRViewCreated: (QRViewController controller){
      setState(() {qrViewController = controller;});
      controller.scannedDataStream.listen((Barcode? qrcode){});
    },
    overlay: QrScannerOverlayShape(
      cutOutSize: MediaQuery.of(context).size.width * 0.8,
      borderWidth: 0,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MonolibroScaffold(
      title: getText("title"),
      fullIcon: true,
      body: Container(
        child: Swiper(
          itemCount: 5,
          control: const SwiperControl(
            iconNext: Icons.arrow_forward_ios,
            iconPrevious: Icons.arrow_back_ios_new,
          ),
          loop: false,
          itemBuilder: (BuildContext context, int index){
            if (index == 4){
              return buildScanner();
            }
            return buildTutorial(index);
          },
        ),
      )
    );
  }
}