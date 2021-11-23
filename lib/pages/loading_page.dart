import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monolibro/components/logo_group.dart';
import 'package:monolibro/globals/cryptography_utils.dart';
import 'package:monolibro/globals/database.dart';
import 'package:monolibro/globals/message_utils.dart';
import 'package:monolibro/globals/theme_colors.dart';
import 'package:monolibro/globals/ws_control.dart';
import 'package:monolibro/monolibro/intention.dart';
import 'package:monolibro/monolibro/models/details.dart';
import 'package:monolibro/monolibro/models/payload.dart';
import 'package:monolibro/monolibro/operation.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:uuid/uuid.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

enum LoadingStatus{
  loading,
  ready,
}

class _LoadingPageState extends State<LoadingPage> {
  
  LoadingStatus status = LoadingStatus.loading;
  
  Future<void> getData() async {
    await dbWrapper.initialize();
    await wsClientGlobal.wsClient.state.init();
    List<Map> localUsers = await dbWrapper.executeWithResult("select * from LocalUser;");
    if (localUsers.isNotEmpty){
      Payload joinPayload = Payload(1, Uuid().v4(), Details(Intention.system, ""), Operation.joinNetwork, {
        "userID": localUsers[0]["userID"]
      });
      AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keys = CryptographyUtils.generateRSAKeyPair();
      String message = MessageUtils.serialize(joinPayload, keys.privateKey);
      wsClientGlobal.wsClient.channel.sink.add(message);
    }
    await Future.delayed(const Duration(milliseconds: 500),(){
      setState(() {
        status = LoadingStatus.ready;
      });
    });
    await Future.delayed(const Duration(milliseconds: 500),(){});
    if (localUsers.isEmpty){
      Navigator.pushReplacementNamed(context, "/init/language");
    }
    else{
      Navigator.pushReplacementNamed(context, "/");
    }
  }
  
  @override
  void initState() {
    getData();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: ThemeColors.defaultGradient,
      ),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        const LogoGroup(),
        SizedBox(
          child: Stack(
            children: [
              Visibility(
                visible: status == LoadingStatus.loading,
                child: CircularProgressIndicator(
                  color: ThemeColors.defaultAccent[3],
                ),
              ),
              Visibility(
                visible: status == LoadingStatus.ready,
                child: Icon(
                  CarbonIcons.checkmark,
                  color: ThemeColors.defaultAccent[3],
                  size: 50,
                ),
              )
            ],
          )
        )
      ]),
    );
  }
}
