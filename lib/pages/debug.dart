import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monolibro/components/paragraph.dart';
import 'package:monolibro/globals/ws_control.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({ Key? key }) : super(key: key);

  @override
  _DebugPageState createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  String message = "None";
  
  @override
  void initState() {
    wsClientGlobal.wsClient.state.debugStream.stream.listen((String newMessage) {
      setState(() {
        message = newMessage;
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Paragraph(
          text: message,
        )
      )
    );
  }
}