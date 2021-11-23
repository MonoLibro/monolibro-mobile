import 'package:flutter/material.dart';
import 'package:monolibro/pages/export_account_page.dart';
import 'package:monolibro/pages/initialization_pages/account_init_page.dart';
import 'package:monolibro/pages/initialization_pages/import_account_page.dart';
import 'package:monolibro/pages/initialization_pages/language_selector_page.dart';
import 'package:monolibro/pages/initialization_pages/new_account_page.dart';
import 'package:monolibro/pages/loading_page.dart';
import 'package:monolibro/pages/main_page.dart';
import 'package:monolibro/pages/options_page.dart';
import 'package:monolibro/pages/view_activity_page.dart';

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
        initialRoute: "/init",
        routes: {
          "/view_activity": (context) => const ViewActivityPage(),
          "/options": (context) => const OptionsPage(),
          "/options/export": (context) => const ExportAccountPage(),
          "/init": (context) => const LoadingPage(),
          "/init/language": (context) => const LanguageSelectorPage(),
          "/init/accountinit": (context) => const AccountInitPage(),
          "/init/importaccount": (context) => const ImportAccountPage(),
          "/init/newaccount": (context) => const NewAccountPage(),
          "/": (context) => const MainPage(),
        });
  }
}
