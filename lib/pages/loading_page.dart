import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monolibro/components/logo_group.dart';
import 'package:monolibro/globals/database.dart';
import 'package:monolibro/globals/theme_colors.dart';

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
    List<Map> localUsers = await dbWrapper.executeWithResult("select * from LocalUser;");
    Future.delayed(const Duration(milliseconds: 500),(){
      setState(() {
        status = LoadingStatus.ready;
      });
    });
    Future.delayed(const Duration(seconds: 1),(){
      if (localUsers.isEmpty){
        Navigator.pushReplacementNamed(context, "/init/language");
      }
      else{
        Navigator.pushReplacementNamed(context, "/");
      }
    });
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
