import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:monolibro/components/button.dart';
import 'package:monolibro/components/input_layout.dart';
import 'package:monolibro/components/input_text.dart';
import 'package:monolibro/components/monolibro_scaffold.dart';
import 'package:monolibro/controls/input_layout_control.dart';
import 'package:monolibro/globals/internationalization.dart';
import 'package:monolibro/globals/ws_control.dart';
import 'package:sprintf/sprintf.dart';

class OptionsPage extends StatefulWidget {
  const OptionsPage({Key? key}) : super(key: key);

  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  Map text = {};

  Future<void> getData() async {
    var result = await Internationalization.getTranslationObject(
        context, "options_page");
    setState(() {
      text = result;
    });
  }

  TextEditingController userIDController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool userIDError = false;
  bool firstNameError = false;
  bool lastNameError = false;
  bool emailError = false;
  
  String userIDErrorMessage = "";
  String firstNameErrorMessage = "";
  String lastNameErrorMessage = "";
  String emailErrorMessage = "";

  @override
  void initState() {
    getData();
    super.initState();
  }

  bool validateUserID(String userID){
    // not empty, 32 char, [A-Z|a-z|0-9|_|-]*, do not starts or ends with space
    String errorMessage = "";
    bool error = false;
    userID = userID.trim();
    if (userID.isEmpty){
      // errorMessage = "User ID cannot be empty";
      errorMessage = sprintf(getText("cannotBeEmpty"), [getText("userID")]);
      error = true;
    }
    if (userID.length > 32){
      errorMessage = sprintf(getText("cannotBeLongerThen"), [getText("userID"), "32"]);
      // errorMessage = "User ID cannot be longer then 32 letters or numbers";
      error = true;
    }
    RegExp regExp = RegExp(
      r"[a-z|A-Z|0-9|_|-]*",
      caseSensitive: false,
      multiLine: false,
    );
    if (regExp.stringMatch(userID) != userID){
      errorMessage = sprintf(getText("onlyContains"), [getText("userID"), "${getText('engChars')}${getText('comma')}${getText('numChars')}${getText('comma')}${getText('underscores')}${getText('and')}${getText('dashes')}"]);
      // errorMessage = "User ID must only contains English charactors, numbers, underscores and dashes";
      error = true;
    }
    setState(() {
      userIDError = error;
      userIDErrorMessage = errorMessage;
    });
    return error;
  }

  bool validateFirstName(String firstName){
    // not empty, 256 char, [A-Z|a-z|0-9|_|-]*, do not starts or ends with space
    String errorMessage = "";
    bool error = false;
    firstName = firstName.trim();
    if (firstName.isEmpty){
      errorMessage = sprintf(getText("cannotBeEmpty"), [getText("firstName")]);
      error = true;
    }
    if (firstName.length > 256){
      errorMessage = sprintf(getText("cannotBeLongerThen"), [getText("firstName"), "32"]);
      error = true;
    }
    RegExp regExp = RegExp(
      r"[a-z|A-Z]*",
      caseSensitive: false,
      multiLine: false,
    );
    if (regExp.stringMatch(firstName) != firstName){
      errorMessage = sprintf(getText("onlyContains"), [getText("firstName"), "${getText('engChars')}${getText('comma')}${getText('numChars')}${getText('comma')}${getText('underscores')}${getText('and')}${getText('dashes')}"]);
      error = true;
    }
    setState(() {
      firstNameError = error;
      firstNameErrorMessage = errorMessage;
    });
    return error;
  }

  bool validateLastName(String lastName){
    // not empty, 256 char, [A-Z|a-z|0-9|_|-]*, do not starts or ends with space
    String errorMessage = "";
    bool error = false;
    lastName = lastName.trim();
    if (lastName.isEmpty){
      errorMessage = sprintf(getText("cannotBeEmpty"), [getText("lastName")]);
      error = true;
    }
    if (lastName.length > 256){
      error = true;
      errorMessage = sprintf(getText("cannotBeLongerThen"), [getText("lastName"), "32"]);
    }
    RegExp regExp = RegExp(
      r"[a-z|A-Z]*",
      caseSensitive: false,
      multiLine: false,
    );
    if (regExp.stringMatch(lastName) != lastName){
      errorMessage = sprintf(getText("onlyContains"), [getText("lastName"), "${getText('engChars')}${getText('comma')}${getText('numChars')}${getText('comma')}${getText('underscores')}${getText('and')}${getText('dashes')}"]);
      error = true;
    }
    setState(() {
      lastNameError = error;
      lastNameErrorMessage = errorMessage;
    });
    return error;
  }

  bool validateEmail(String email){
    // not empty, 256 char, [0-9|a-z|A-Z|_|-|\.]*@[0-9|a-z|A-Z|_|-|\.]*\.(com|net|edu|org|gov|my|uk|jp|cn|tw|sg), do not starts or ends with space
    String errorMessage = "";
    bool error = false;
    email = email.trim();
    if (email.isEmpty){
      errorMessage = sprintf(getText("cannotBeEmpty"), [getText("email")]);
      error = true;
    }
    if (email.length > 256){
      errorMessage = "Email cannot be longer then 256 letters or numbers";
      errorMessage = sprintf(getText("cannotBeLongerThen"), [getText("email"), "32"]);
    }
    RegExp regExp = RegExp(
      r"[0-9|a-z|A-Z|_|-|\.]*@[0-9|a-z|A-Z|_|-|\.]*\.(com|net|edu|org|gov|my|uk|jp|cn|tw|sg)",
      caseSensitive: false,
      multiLine: false,
    );
    if (regExp.stringMatch(email) != email){
      errorMessage = getText('mustBeEmailFormat');
      error = true;
    }
    setState(() {
      emailError = error;
      emailErrorMessage = errorMessage;
    });
    return error;
  }

  Future<void> update() async {
    var localUser = wsClientGlobal.wsClient.state.localUser!;
    localUser.userID = userIDController.text;
    localUser.firstName = firstNameController.text;
    localUser.lastName = lastNameController.text;
    localUser.email = emailController.text;
    Fluttertoast.showToast(
        msg: "Account updated.",
    );
  }

  String getText(String key) {
    if (text == {}) return "";
    return text[key].toString();
  }

  InputGroup builder(int index) {
    List<InputGroup> widgets = [
      InputGroup(
        inputBuilder: (int inputIndex) => [
          InputText(hint: getText("userID")),
          InputText(hint: getText("firstName")),
          InputText(hint: getText("lastName")),
          InputText(hint: getText("email")),
          Align(
            alignment: Alignment.centerRight,
            child: Button(
              text: getText("confirm"),
              onPressed: () {
                bool a = validateUserID(userIDController.text);
                bool b = validateFirstName(firstNameController.text);
                bool c = validateLastName(lastNameController.text);
                bool d = validateEmail(emailController.text);
                if (!(a || b || c || d)){
                  update();
              }
              },
            ),
          ),
        ][inputIndex],
        count: 5,
        icon: const Icon(
          CarbonIcons.user,
          size: 35,
        ),
        title: getText("userGroup"),
      ),
      InputGroup(
          inputBuilder: (int inputIndex) =>
              InputText(hint: getText("language")),
          count: 1,
          icon: const Icon(
            CarbonIcons.settings_adjust,
            size: 35,
          ),
          title: getText("generalGroup"))
    ];
    return widgets[index];
  }

  @override
  Widget build(BuildContext context) {
    return MonolibroScaffold(
      left: Button(
        text: "Export",
        onPressed: (){
          Navigator.pushNamed(context, "/main/options/export");
        },
      ),
      title: getText("title"),
      body: InputLayout(
        control: InputLayoutControl(
          builder: builder,
          count: 2,
        ),
      ),
    );
  }
}
