import 'package:flutter/material.dart';
import 'package:monolibro/pages/initialization_pages/account_init_page.dart';
import 'package:monolibro/pages/initialization_pages/language_selector_page.dart';
import 'package:monolibro/pages/initialization_pages/import_account_page.dart';
import 'package:monolibro/pages/initialization_pages/new_account_page.dart';
import 'package:monolibro/pages/loading_page.dart';
import 'package:monolibro/pages/main_page.dart';
import 'package:monolibro/pages/view_activity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MonoLibro',
      debugShowCheckedModeBanner: false,
      initialRoute: "/view_activity",
      routes:{
        "/init": (context) => const LoadingPage(),
        "/view_activity": (context) => const ViewActivity(),
        "/init/language": (context) => const LanguageSelectorPage(),
        "/init/accountinit": (context) => const AccountInitPage(),
        "/init/importaccount": (context) => const ImportAccountPage(),
        "/init/newaccount": (context) => const NewAccountPage(),
        "/": (context) => const MainPage(),
      }
    );
  }
}
