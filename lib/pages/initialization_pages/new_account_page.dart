import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monolibro/components/button.dart';
import 'package:monolibro/components/input_layout.dart';
import 'package:monolibro/components/input_text.dart';
import 'package:monolibro/components/monolibro_scaffold.dart';
import 'package:monolibro/components/paragraph.dart';
import 'package:monolibro/controls/input_layout_control.dart';
import 'package:monolibro/globals/cryptography_utils.dart';
import 'package:monolibro/globals/database.dart';
import 'package:monolibro/globals/internationalization.dart';
import 'package:monolibro/globals/message_utils.dart';
import 'package:monolibro/globals/theme_colors.dart';
import 'package:monolibro/globals/ws_control.dart';
import 'package:monolibro/monolibro/intention.dart';
import 'package:monolibro/monolibro/models/details.dart';
import 'package:monolibro/monolibro/models/payload.dart';
import 'package:monolibro/monolibro/operation.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:sprintf/sprintf.dart';
import 'package:uuid/uuid.dart';

class NewAccountPage extends StatefulWidget {
  const NewAccountPage({Key? key}) : super(key: key);

  @override
  _NewAccountPageState createState() => _NewAccountPageState();
}

class _NewAccountPageState extends State<NewAccountPage> {
  Map text = {};
  
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

  bool isCreating = false;

  Future<void> getData() async {
    var result = await Internationalization.getTranslationObject(
      context, "new_account_page");
    setState(() {
      text = result;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  String getText(String key) {
    if (text == {}) return "";
    return text[key].toString();
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

  Future<void> registerAccount() async {
    String userID = userIDController.text;
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String email = emailController.text;
    Uuid uuid = const Uuid();
    AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keyPair = CryptographyUtils.generateRSAKeyPair();
    Payload accountCreationPayload = Payload(1, uuid.v4(), Details(Intention.broadcast, ""), Operation.createAccountInit, {
      "userID": userID,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "publicKey": "",
      "timestamp": (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
    });

    Payload joinNetworkPayload = Payload(1, uuid.v4(), Details(Intention.system, ""), Operation.joinNetwork, {
      "userID": userID,
    });
    
    String createAccountSinkData = MessageUtils.serialize(accountCreationPayload, keyPair.privateKey);
    String joinNetworkSinkData = MessageUtils.serialize(accountCreationPayload, keyPair.privateKey);

    await Future.delayed(const Duration(microseconds: 50), ()=>wsClientGlobal.wsClient.channel.sink.add(joinNetworkSinkData));
    await Future.delayed(const Duration(microseconds: 50), ()=>wsClientGlobal.wsClient.channel.sink.add(createAccountSinkData));

    dbWrapper.execute("insert into LocalUser values ('$userID', '$firstName', '$lastName', '$email', '', '', 0)");
    
    Future.delayed(
      const Duration(seconds: 1),
      ()=>Navigator.popAndPushNamed(context, "/init")
    );
  }

  InputGroup builder(int index) {
    List<InputGroup> widgets = [
      InputGroup(
        inputBuilder: (int inputIndex) => [
          InputText(
            controller: userIDController,
            error: userIDError,
            errorMessage: userIDErrorMessage,
            hint: getText("userID")
          ),
          InputText(
            controller: firstNameController,
            error: firstNameError,
            errorMessage: firstNameErrorMessage,
            hint: getText("firstName")
          ),
          InputText(
            controller: lastNameController,
            error: lastNameError,
            errorMessage: lastNameErrorMessage,
            hint: getText("lastName")
          ),
          InputText(
            controller: emailController,
            errorMessage: emailErrorMessage,
            error: emailError,
            hint: getText("email")
          ),
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
                  setState(() {
                    isCreating = true;
                  });
                  registerAccount();
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
          expandable: true,
          inputBuilder: (int inputIndex) => Container(),
          count: 0,
          icon: const Icon(
            CarbonIcons.settings,
            size: 35,
          ),
          title: getText("advancedGroup"))
    ];
    return widgets[index];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !isCreating,
      child: Stack(
        children: [
          MonolibroScaffold(
            title: getText("title"),
            fullIcon: true,
            body: InputLayout(
              control: InputLayoutControl(
                builder: builder,
                count: 2,
              ),
            ),
          ),
          Visibility(
            visible: isCreating,
            child: Container(
              color: const Color(0xAA000000),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Container(
                  color: Colors.white,
                  width: 200,
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircularProgressIndicator(color: ThemeColors.defaultAccent[3]),
                      Paragraph(
                        text: getText("creatingAccount"),
                      )
                    ],
                  )
                )
              )
            )
          ),
        ],
      )
    );
  }
}
