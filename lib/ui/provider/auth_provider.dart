import 'package:flutter/material.dart';

class AuthenticationProvider extends ChangeNotifier {
  Map<String, dynamic> signUpdata = {};
  update(Map<String, dynamic> map) {
    signUpdata = map;
    notifyListeners();
  }

}
