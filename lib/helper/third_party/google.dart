// ignore_for_file: avoid_print

import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';

class GoogleApi {
  static String iosClientId =
      "792947408004-oe4se0fts40vf3l4hp17m6fkod2tk064.apps.googleusercontent.com";

  static Future<GoogleSignInAccount?> googleSignIn() async {
    //Default definition
    GoogleSignIn? googleSignIn;
    if (Platform.isAndroid) {
      print("-----START------");
      googleSignIn = GoogleSignIn(
        scopes: [
          'profile',
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
      );
      print(googleSignIn);
    }
    if (Platform.isIOS || Platform.isMacOS) {
      googleSignIn = GoogleSignIn(
        clientId: GoogleApi.iosClientId,
        scopes: [
          'email',
        ],
      );
    }
    GoogleSignInAccount? g;
    try {
      g = await googleSignIn?.signIn();
    } catch (e) {
      print(e.toString());
    }

    return g;
  }
}
