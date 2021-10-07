import 'package:flutter/material.dart';
import 'package:monolibro/pages/initialization_pages/account_init_page.dart';
import 'package:monolibro/pages/initialization_pages/language_selector_page.dart';
import 'package:monolibro/pages/loading_page.dart';

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
      routes:{
        "/init": (context) => const LoadingPage(),
        "/init/language": (context) => const LanguageSelectorPage(),
        "/init/accountInit": (context) => const AccountInitPage(),
      }
    );
  }
}
