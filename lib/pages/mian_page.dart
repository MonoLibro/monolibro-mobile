import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monolibro/components/mian_panels/new_activity.dart';
import 'package:monolibro/components/monolibro_scaffold.dart';
import 'package:monolibro/components/paragraph.dart';
import 'package:monolibro/globals/internationalization.dart';
import 'package:monolibro/globals/theme_colors.dart';
import 'package:monolibro/globals/typography.dart' as t;
import 'package:qr_code_scanner/qr_code_scanner.dart';

class PanelData{
  PanelData({required this.index, required this.padding, required this.position, required this.color});
  int index;
  double padding;
  double position;
  Color color;

  @override
  String toString(){
    return "PanelData(index=$index, padding=$padding, position=$position)";
  }
}

class MainPage extends StatefulWidget{
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>{
  Map text = {};
  Map activityCodePanelConfig = {
    "position": 0,
    "height": (context) => MediaQuery.of(context).size.height * 0.8,
    "showed": false,
  };
  int index = 0;

  List panelData = [
    (BuildContext context) => PanelData(index: 0, padding: 20, position: 0, color: const Color(0x00000000)),
    (BuildContext context) => PanelData(index: 1, padding: 20, position: MediaQuery.of(context).size.width - 50, color: const Color(0xFFFFFFFF)),
    (BuildContext context) => PanelData(index: 2, padding: 20, position: MediaQuery.of(context).size.width * 2 - 100, color: ThemeColors.grayAccent[1]),
    (BuildContext context) => PanelData(index: 3, padding: 20, position: MediaQuery.of(context).size.width * 2 - 0, color: const Color(0xFFFFFFFF)),
  ];

  var qrKey = GlobalKey(debugLabel: "activityQr");
  QRViewController? qrViewController;

  @override
  void dispose(){
    qrViewController?.dispose();
    super.dispose();
  }

  Future<void> getData() async {
    var result = await Internationalization.getTranslationObject(context, "main_page");
    setState(() {
      text = result;
    });
  }
  
  @override
  void initState() {
    getData();
    super.initState();
  }
  
  String getText(String key){
    if (text == {}) return "";
    return text[key].toString();
  }
  
  void showVerticalPanel(){
    setState(() {
      activityCodePanelConfig["position"] = -activityCodePanelConfig["height"](context);
      activityCodePanelConfig["showed"] = true;
    });
    Future.delayed(
      const Duration(milliseconds: 100),
      ()=>setState(() {
        activityCodePanelConfig["position"] = 0;
      })
    );
  }

  void verticalDragUpdateCallback(DragUpdateDetails details){
    var delta = details.delta.dy;
    setState(() {
      var newPos = activityCodePanelConfig["position"] - delta;
      activityCodePanelConfig["position"] = (newPos > 0) ? 0 : newPos;
    });
  }

  void verticalDragEndCallback(DragEndDetails details){
    var velocity = details.velocity.pixelsPerSecond.dy;
    var downVelocity = velocity > 500;
    var upVelocity = velocity < -500;
    var upPosition = activityCodePanelConfig["position"] > -(activityCodePanelConfig["height"](context).toDouble() * 0.60);
    bool up = upVelocity;
    if (!upVelocity){
      if (downVelocity){
        up = false;
      }
      else if (upPosition){
        up = true;
      }
      else {
        up = false;
      }
    }
    setState(() {
      activityCodePanelConfig["position"] = up ? 0 : -(activityCodePanelConfig["height"](context) + 40);
    });
    Future.delayed(
      const Duration(milliseconds: 150),
      (){
        setState(() {
          activityCodePanelConfig["showed"] = up;
        });
      }
    );
  }

  int getHorizontalSwipeDirection(velocity){
    if (velocity > 500){
      return 1;
    }
    else if (velocity < -500){
      return -1;
    }
    else {
      return 0;
    }
  }

  int getHorizontalPixelThreshold(context, position){
    double width = MediaQuery.of(context).size.width;
    double threshold = width / 2;
    if (position < -threshold/2){
       return -1;
    }
    else if (position < threshold){
      return 0;
    }
    else {
      return 1;
    }
  }

  void setToCurrentPage(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    var oldPanels = [
      (index == 0) ? null : panelData[index - 1](context),
      panelData[index](context),
      (index == 3) ? null : panelData[index + 1](context),
      (index >= 2) ? null : panelData[index + 2](context),
    ];
    setState(() {
      oldPanels[1].position = 0.toDouble();
      oldPanels[1].padding = 20.toDouble();
      panelData[index] = (BuildContext c) => oldPanels[1];
      if (oldPanels[0] != null){
        oldPanels[0].padding = 30.toDouble();
        oldPanels[0].position = (-width/2).toDouble();
        panelData[index - 1] = (BuildContext c) => oldPanels[0];
      }
      if (oldPanels[2] != null){
        oldPanels[2].position = (width - 50).toDouble();
        panelData[index + 1] = (BuildContext c) => oldPanels[2];
      }
      if (oldPanels[3] != null){
        oldPanels[3].position = (width * 2 - 90).toDouble();
        panelData[index + 2] = (BuildContext c) => oldPanels[3];
      }
    });
  }

  void setToNextPage(BuildContext context){
    if (index == 3) {
      setToCurrentPage(context);
      return;
    }
    int nextIndex = index + 1;
    double width = MediaQuery.of(context).size.width;
    PanelData currentPage = panelData[nextIndex](context);
    currentPage.position = 0.toDouble();
    currentPage.padding = 20.toDouble();

    PanelData? prevPage;
    if (nextIndex > 0){
      // has prev page
      prevPage = panelData[nextIndex - 1](context);
      prevPage?.position = (-width/2).toDouble();
      prevPage?.padding = 30.toDouble();
    }
    
    PanelData? nextPage;
    if (nextIndex < 3){
      // has next page
      nextPage = panelData[nextIndex + 1](context);
      nextPage?.position = (width - 50).toDouble();
      nextPage?.padding = 20.toDouble();
    }
    
    PanelData? gappedPage;
    if (nextIndex < 2){
      // has gapped page
      gappedPage = panelData[nextIndex + 2](context);
      gappedPage?.position = (width * 2 - 90).toDouble();
      gappedPage?.padding = 20.toDouble();
    }

    setState(() {
      panelData[nextIndex] = (context) => currentPage;
      if (prevPage != null){
        panelData[nextIndex - 1] = (context) => prevPage;
      }
      if (nextPage != null){
        panelData[nextIndex + 1] = (context) => nextPage;
      }
      if (gappedPage != null){
        panelData[nextIndex + 2] = (context) => gappedPage;
      }
    });
    Future.delayed(
      const Duration(milliseconds: 100),
      () => index ++,
    );
  }

  void setToPrevPage(BuildContext context){
    if (index == 0) {
      setToCurrentPage(context);
      return;
    }
    int prevIndex = index - 1;
    double width = MediaQuery.of(context).size.width;
    PanelData currentPage = panelData[prevIndex](context);
    currentPage.position = 0.toDouble();
    currentPage.padding = 20.toDouble();

    PanelData? prevPage;
    if (prevIndex > 0){
      // has prev page
      prevPage = panelData[prevIndex - 1](context);
      prevPage?.position = (-width/2).toDouble();
      prevPage?.padding = 30.toDouble();
    }
    
    PanelData? nextPage;
    if (prevIndex < 3){
      // has next page
      nextPage = panelData[prevIndex + 1](context);
      nextPage?.position = (width - 50).toDouble();
      nextPage?.padding = 20.toDouble();
    }
    
    PanelData? gappedPage;
    if (prevIndex < 2){
      // has gapped page
      gappedPage = panelData[prevIndex + 2](context);
      gappedPage?.position = (width * 2 - 90).toDouble();
      gappedPage?.padding = 20.toDouble();
    }

    setState(() {
      panelData[prevIndex] = (context) => currentPage;
      if (prevPage != null){
        panelData[prevIndex - 1] = (context) => prevPage;
      }
      if (nextPage != null){
        panelData[prevIndex + 1] = (context) => nextPage;
      }
      if (gappedPage != null){
        panelData[prevIndex + 2] = (context) => gappedPage;
      }
    });
    Future.delayed(
      const Duration(milliseconds: 100),
      () => index --,
    );
  }

  void horizontalDragUpdateCallback(DragUpdateDetails details){
    double delta = details.delta.dx;
    if (index == 0) {
      setToCurrentPage(context);
      return;
    }
    double width = MediaQuery.of(context).size.width;
    PanelData currentPage = panelData[index](context);
    if (currentPage.position < 0){
      currentPage.padding -= delta * 0.05;
    }
    currentPage.position += delta;

    PanelData? prevPage;
    if (index > 0){
      // has prev page
      prevPage = panelData[index - 1](context);
      if ((prevPage?.position ?? 0) < 0){
        prevPage?.padding -= delta * 0.05;
      }
      prevPage?.position += delta;
    }
    
    PanelData? nextPage;
    if (index < 3){
      // has next page
      nextPage = panelData[index + 1](context);
      nextPage?.position += delta;
      nextPage?.padding = 20.toDouble();
    }

    setState(() {
      panelData[index] = (context) => currentPage;
      if (prevPage != null){
        panelData[index - 1] = (context) => prevPage;
      }
      if (nextPage != null){
        panelData[index + 1] = (context) => nextPage;
      }
    });
  }

  void horizontalDragEndCallback(DragEndDetails details){
    var velocity = details.velocity.pixelsPerSecond.dx;
    var position = panelData[index](context).position;
    var direction = getHorizontalSwipeDirection(velocity);
    var threshold = getHorizontalPixelThreshold(context, position);
    if (threshold == -1){
      if (direction < 1){
        setToNextPage(context);
      }
      else{
        setToCurrentPage(context);
      }
    }
    else if (threshold == -0){
      if (direction == 0){
        setToCurrentPage(context);
      }
      else if (direction == 1){
        setToPrevPage(context);
      }
      else {
        setToNextPage(context);
      }
    }
    else if (threshold == 1){
      if (direction > -1){
        setToPrevPage(context);
      }
      else{
        setToCurrentPage(context);
      }
    }
  }

  Widget getPanelPage(int index, Map text){
    if (index == 1){
      return NewActivity(text: text);
    }
    // if (index == 2){
    //   return ActivityHistory(text: text);
    // }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return MonolibroScaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: horizontalDragUpdateCallback,
        onHorizontalDragEnd: horizontalDragEndCallback,
        child: Stack(
          children: [

            // Background Gesture Detector Overlay
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),

            // Main Content
            Container(
              color: ThemeColors.grayAccent[1],
              child: Column(
                children: [
                  SizedBox(
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: (QRViewController controller){
                        setState(() {qrViewController = controller;});
                        controller.scannedDataStream.listen((Barcode? qrcode){});
                      },
                      overlay: QrScannerOverlayShape(
                        cutOutSize: MediaQuery.of(context).size.width * 0.6,
                        borderWidth: 0,
                        overlayColor: ThemeColors.grayAccent[1],
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Paragraph(text:getText("or"),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Paragraph(
                      text:getText("codePrompt"),
                      size: t.Typography.appbarTitleSize,
                    ),
                  ),
                  GestureDetector(
                    onTap: showVerticalPanel,
                    child: Container(
                      color: ThemeColors.grayAccent[1],
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (var i = 0; i < 6; i++)
                          Container(
                            color: ThemeColors.grayAccent[2],
                            width: 40,
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ),

            // PANELS
            for (var i = 1; i < 4; i++)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              left: panelData[i](context).position,
              child: AnimatedPadding(
                padding: EdgeInsets.all(panelData[i](context).padding),
                duration: const Duration(milliseconds: 100),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    boxShadow: [
                      BoxShadow(
                        color: ThemeColors.defaultPanelShadow,
                        blurRadius: 15,
                      ),
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(15))
                  ),
                  height: MediaQuery.of(context).size.height - (8 * (panelData[i](context).padding)),
                  width: MediaQuery.of(context).size.width - (2 * (panelData[i](context).padding)),
                  child: Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height - (8 * (panelData[i](context).padding)),
                        width: 30,
                        decoration: BoxDecoration(
                          color: panelData[i](context).color,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 10,
                            height: 80,
                            decoration: BoxDecoration(
                              color: ThemeColors.grayAccent[2],
                              borderRadius: const BorderRadius.all(Radius.circular(5))
                            ),
                          )
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height - (8 * (panelData[i](context).padding)),
                        width: MediaQuery.of(context).size.width - (2 * (panelData[i](context).padding)) - 30,
                        child: getPanelPage(
                          i,
                          text,
                        ),
                      ),
                    ],
                  ),
                )
              )
            ),

            // Code Panel Stack
            Visibility(
              visible: activityCodePanelConfig["showed"],
              child: GestureDetector(
                onVerticalDragUpdate: verticalDragUpdateCallback,
                onVerticalDragEnd: verticalDragEndCallback,
                child:Stack(
                  children: [
                    Container(
                      color: ThemeColors.overlayColor,
                    ),
                    AnimatedPositioned(
                      bottom: activityCodePanelConfig["position"].toDouble(),
                      duration: const Duration(milliseconds: 100),
                      child: Container(
                        height: activityCodePanelConfig["height"](context),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          boxShadow: [
                            BoxShadow(
                              color: ThemeColors.defaultPanelShadow,
                              blurRadius: 30,
                            )
                          ],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Container(
                                height: 10,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: ThemeColors.grayAccent[2],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Paragraph(
                                text:getText("codePrompt"),
                                size: t.Typography.appbarTitleSize,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  for (var i = 0; i < 6; i++)
                                  Container(
                                    color: ThemeColors.grayAccent[2],
                                    width: 40,
                                    height: 40,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ),
          ],
        )
      )
    );
  }
}