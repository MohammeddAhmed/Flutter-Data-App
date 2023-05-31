import 'package:flutter/material.dart';
import 'package:data/pref/shared_pref_controller.dart';

class LanguageProvider extends ChangeNotifier{
  String language = SharedPrefController().getValue<String>(PrefKeys.language.name) ?? 'en';

  void changeLanguage(String language){
    this.language = language;
    SharedPrefController().setValue<String>(PrefKeys.language.name, language);
    notifyListeners();
    
  }
}