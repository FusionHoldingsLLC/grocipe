import 'package:flutter/material.dart';
import 'package:grocipe/helper/third_party/hive.dart';

class MainProvider extends ChangeNotifier {
  String preferredLanguage = HiveFunction.getLanguage();
  updateLanguage(String lang) {
    preferredLanguage = lang;
    HiveFunction.insertLanguage(lang);
    notifyListeners();
  }
}
