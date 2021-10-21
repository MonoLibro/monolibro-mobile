import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:flutter/widgets.dart';
import 'package:monolibro/components/button.dart';
import 'package:monolibro/components/input_text.dart';
import 'package:monolibro/components/paragraph.dart';
import 'package:monolibro/globals/typography.dart';

class NewActivity extends StatefulWidget{
  const NewActivity({Key? key, required this.text}) : super(key: key);
  final Map text;

  @override
  _NewActivityState createState() => _NewActivityState();
}

class _NewActivityState extends State<NewActivity>{
  bool keyboardOpened = false;
  
  @protected @override
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

  String getText(String key){
    if (widget.text == {}) return "";
    return widget.text[key].toString();
  }
  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 50, right: 30),
          child: Paragraph(
            text: getText("newActivity"),
            size: Typography.panelTitle,
          )
        ),
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
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 10, right: 30),
          width: MediaQuery.of(context).size.width * 0.70,
          child: InputText(
            hint: getText("totalAmount"),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 10, right: 30),
          width: MediaQuery.of(context).size.width * 0.70,
          child: Align(
            alignment: Alignment.centerRight,
            child: Button(
              text: getText("commit"),
              onPressed: (){}
            )
          ),
        ),
      ],
    );
  }
}