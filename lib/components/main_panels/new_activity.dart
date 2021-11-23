import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:monolibro/components/button.dart';
import 'package:monolibro/components/input_text.dart';
import 'package:monolibro/components/paragraph.dart';
import 'package:monolibro/globals/local_user.dart';
import 'package:monolibro/globals/typography.dart';
import 'package:monolibro/globals/ws_control.dart';
import 'package:monolibro/monolibro/models/activity.dart';
import 'package:monolibro/monolibro/models/user.dart';
import 'package:sprintf/sprintf.dart';
import 'package:string_validator/string_validator.dart';

class NewActivity extends StatefulWidget {
  const NewActivity({Key? key, required this.text}) : super(key: key);
  final Map text;

  @override
  _NewActivityState createState() => _NewActivityState();
}

class _NewActivityState extends State<NewActivity> {
  bool keyboardOpened = false;
  TextEditingController activityNameController = TextEditingController();
  TextEditingController totalPaidAmountController = TextEditingController();

  String prevText = "";
  bool activityNameError = false;
  bool totalPaidAmountError = false;
  String activityNameErrorMessage = "";
  String totalPaidAmountErrorMessage = "";

  @protected
  @override
  void initState() {
    super.initState();

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          keyboardOpened = visible;
        });
      },
    );
  }

  String getText(String key) {
    if (widget.text == {}) return "";
    return widget.text[key].toString();
  }

  @override
  void dispose(){
    activityNameController.dispose();
    totalPaidAmountController.dispose();
    super.dispose();
  }

  bool validateName(){
    String raw = activityNameController.text.trim();
    bool err = false;
    String msg = "";
    if (raw.isEmpty){
      err = true;
      String fieldName = getText("activityNameField");
      msg = sprintf(getText("cannotBeEmpty"), [fieldName]);
    }
    setState(() {
      activityNameError = err;
      activityNameErrorMessage = msg;
    });
    return err;
  }
  bool validatePrice(){
    String raw = totalPaidAmountController.text.trim();
    bool err = false;
    String msg = "";
    if (raw.isEmpty){
      err = true;
      String fieldName = getText("totalAmount");
      msg = sprintf(getText("cannotBeEmpty"), [fieldName]);
    }
    setState(() {
      totalPaidAmountError = err;
      totalPaidAmountErrorMessage = msg;
    });
    return err;
  }

  String generateRandomCode() {
    var r = Random();
    const _chars = '1234567890';
    return List.generate(6, (index) => _chars[r.nextInt(_chars.length)]).join();
  }


  Future<void> createActivity() async {
    bool v1 = validateName();
    bool v2 = validatePrice();

    if (v1 || v2) return;

    String code = generateRandomCode();
    String timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    LocalUser localUser = wsClientGlobal.wsClient.state.localUser!;
    User user = wsClientGlobal.wsClient.state.getUser(localUser.userID)!;
    double totalPrice = double.parse(totalPaidAmountController.text);
    String name = activityNameController.text;

    Activity activity = Activity(code, timestamp, user, totalPrice, name);

    wsClientGlobal.wsClient.state.addActivity(activity);

    print(wsClientGlobal.wsClient.state.activities);

    Navigator.pushNamed(
      context,
      "/main/view_activity",
      arguments: {
        "activity": code,
      }
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    totalPaidAmountController.addListener(() {
      String raw = totalPaidAmountController.text;
      if (raw.isEmpty) return;
      try{
        double parsed = double.parse(raw);
        if (parsed < 0) {
          totalPaidAmountController.text = prevText;
        }
        else {
          String newText = parsed.toStringAsPrecision(2);
          prevText = newText;
        }
      }
      on FormatException{
        totalPaidAmountController.text = prevText;
      }
      totalPaidAmountController.selection = TextSelection.collapsed(offset: totalPaidAmountController.text.length);
    });

    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 50, right: 30),
            child: Paragraph(
              text: getText("newActivity"),
              size: Typography.panelTitle,
            )),
        Visibility(
          visible: !keyboardOpened,
          child: Container(
            padding: const EdgeInsets.only(bottom: 30, right: 30),
            child: Image.asset("assets/wallet.png"),
            width: MediaQuery.of(context).size.width * 0.50,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 10, right: 30),
          width: MediaQuery.of(context).size.width * 0.70,
          child: InputText(
            hint: getText("activityName"),
            controller: activityNameController,
            error: activityNameError,
            errorMessage: activityNameErrorMessage,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 10, right: 30),
          width: MediaQuery.of(context).size.width * 0.70,
          child: InputText(
            hint: getText("totalAmount"),
            controller: totalPaidAmountController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: false,
            ),
            error: totalPaidAmountError,
            errorMessage: totalPaidAmountErrorMessage,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 10, right: 30),
          width: MediaQuery.of(context).size.width * 0.70,
          child: Align(
              alignment: Alignment.centerRight,
              child: Button(text: getText("commit"), onPressed: () { createActivity(); })
          ),
        ),
      ],
    );
  }
}
