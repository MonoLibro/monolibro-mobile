import 'package:flutter/widgets.dart';
import 'package:monolibro/components/button.dart';
import 'package:monolibro/components/logo_group.dart';
import 'package:monolibro/globals/internationalization.dart';
import 'package:monolibro/globals/theme_colors.dart';
import 'package:monolibro/globals/typography.dart';

class LanguageSelectorPage extends StatefulWidget {
  const LanguageSelectorPage({Key? key}) : super(key: key);

  @override
  _LanguageSelectorPageState createState() => _LanguageSelectorPageState();
}

class _LanguageSelectorPageState extends State<LanguageSelectorPage> {
  var text = {};
  var lang = "en";

  getData() async {
    var resultText = await Internationalization.getTranslationObject(context, "language_selector_page");
    var resultLang = await Internationalization.getLanguage();
    setState(() {
      text = resultText;
      lang = resultLang;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  String getText(String key){
    if (text == {}) return "";
    return text[key].toString();
  }

  changeLanguage(String lang) async {
    await Internationalization.setLanguage(lang);
    var resultLang = await Internationalization.getLanguage();
    var resultText = await Internationalization.getTranslationObject(context, "language_selector_page");
    setState(() {
      this.lang = resultLang;
      text = resultText;
    });
  }

  Widget buildLanguageSelector(String lang){
    return GestureDetector(
      onTap: (){
        changeLanguage(lang);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              height: 30,
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: Image.asset(Internationalization.iconAssetsPath[lang].toString()),
            ),
            Text(
              Internationalization.languageNames[lang].toString(),
              style: TextStyle(
                decoration: TextDecoration.none,
                color: lang == this.lang ? ThemeColors.grayAccent[3] : ThemeColors.defaultAccent[3],
                fontFamily: Typography.latinFontPrimary,
                fontSize: Typography.focusSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async => false,
        child: Container(
        decoration: BoxDecoration(
          gradient: ThemeColors.defaultGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LogoGroup(),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                // color: ThemeColors.grayAccent[0],
                child: Text(
                  getText("welcome"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ThemeColors.grayAccent[3],
                    decoration: TextDecoration.none,
                    fontSize: 16,
                    fontFamily: Typography.latinFontPrimary
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: ThemeColors.defaultAccent[0],
                  // borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    buildLanguageSelector("en"),
                    buildLanguageSelector("zhcn"),
                    buildLanguageSelector("zhtw"),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: Align(
                  child: Button(
                    text: getText("confirm"),
                    onPressed: (){},
                  ),
                  alignment: Alignment.centerRight,
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
