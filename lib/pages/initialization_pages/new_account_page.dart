import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monolibro/components/button.dart';
import 'package:monolibro/components/input_layout.dart';
import 'package:monolibro/components/input_text.dart';
import 'package:monolibro/components/monolibro_scaffold.dart';
import 'package:monolibro/controls/input_layout_control.dart';
import 'package:monolibro/globals/internationalization.dart';

class NewAccountPage extends StatefulWidget{
  const NewAccountPage({Key? key}) : super(key: key);

  @override
  _NewAccountPageState createState() => _NewAccountPageState();
}

class _NewAccountPageState extends State<NewAccountPage>{
  Map text = {};
  
  Future<void> getData() async {
    var result = await Internationalization.getTranslationObject(context, "new_account_page");
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

  InputGroup builder(int index){
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
              onPressed: (){},
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
        inputBuilder: (int inputIndex)=>Container(),
        count: 0,
        icon: const Icon(
          CarbonIcons.settings,
          size: 35,
        ),
        title: getText("advancedGroup")
      )
    ];
    return widgets[index];
  }

  @override
  Widget build(BuildContext context) {
    return MonolibroScaffold(
      title: getText("title"),
      fullIcon: true,
      body: InputLayout(
        control: InputLayoutControl(
          builder: builder,
          count: 2,
        ),
      ),
    );
  }
}