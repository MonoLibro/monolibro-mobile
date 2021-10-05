import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:monolibro/globals/local_storage.dart';

class Internationalization{
  static var languages = <String>["en","zhcn","zhtw"];
  static var iconAssetsPath = <String,String>{
    "en":"assets/Languages/En.png",
    "es":"assets/Languages/Es.png",
    "zhcn":"assets/Languages/Zhcn.png",
    "zhtw":"assets/Languages/Zhtw.png",
    "jp":"assets/Languages/Jp.png",
  };
  static var languageNames = <String,String>{
    "en":"English",
    "es":"Español",
    "zhcn":"简体中文",
    "zhtw":"繁體中文",
    "jp":"日本語",
  };

  static String? getIconAssetsPath(String lang){
    if (languages.contains(lang)){
      return iconAssetsPath[lang];
    }
    return null;
  }

  static Future<void> setLanguage(String lang) async {
    if (!languages.contains(lang)) lang = "en";
    await LocalStorage.setItem("lang", lang);
  }

  static Future<String> getLanguage() async {
    String lang = await LocalStorage.getItem("lang");
    if (languages.contains(lang)) return lang;
    await Internationalization.setLanguage("en");
    return "en";
  }

  static Future<Map> getTranslationObject(BuildContext context, String filename) async {
    String lang = await getLanguage();
    String data = await DefaultAssetBundle.of(context).loadString("langs/language_selector_page.json");
    return jsonDecode(data)[lang];
  }
}