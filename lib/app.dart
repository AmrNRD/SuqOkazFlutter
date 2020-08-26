import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:suqokaz/utils/constants.dart';

import 'main.dart';

class Application {
  static final Application _application = Application._internal();

  factory Application() {
    return _application;
  }

  Application._internal();

  List<String> languagesCode = ['en', 'ar'];

  Iterable<Locale> supportedLocales() => ['en', 'ar'].map<Locale>((language) => Locale(language));

  String getCurrentLocale (){
      return Constants.isRTL ? "ar" : "en";
  }

  void updateLocale(String lang, context) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', lang);
    Root.setLocale(context, Locale(lang));
  }
}

Application application = Application();
