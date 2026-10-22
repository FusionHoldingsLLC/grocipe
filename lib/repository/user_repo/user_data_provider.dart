// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocipe/helper/settings/constants.dart';
import 'package:grocipe/helper/third_party/hive.dart';
import 'package:grocipe/models/user.dart';
import 'package:http/http.dart' as http;

class UserDataProvider {
  static Future<String> signUp(Map data) async {
    try {
      final res = await http.post(
        Uri.parse(
          '${Constants.url}/auth/register/',
        ),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        },
        body: json.encode(data),
      );

      return res.body;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<String> googleSignin(String id) async {
    try {
      final res = await http.post(
        Uri.parse(
          '${Constants.url}/auth/google-auth/',
        ),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json',
          'x-google-id-token': id
        },
        // body: json.encode(data),
      );

      return res.body;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<String> appleSignin(String id) async {
    try {
      final res = await http.post(
        Uri.parse(
          '${Constants.url}/auth/apple-auth/',
        ),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json',
          'x-apple-id-token': id
        },
        // body: json.encode(data),
      );

      return res.body;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<String> signIn(String email, String password) async {
    print(json.encode({'username': email, 'password': password}));
    try {
      final res = await http.post(
          Uri.parse(
            '${Constants.url}/auth/login/?username=$email&password=$password',
          ),
          headers: {
            "accept": "application/json",
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: {
            'username': email,
            'password': password,
            "scope": '',
            "client_id": '',
            "client_secret": '',
            "grant_type": 'password',
          });

      return res.body;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<String> verify(
      {required String pin, required String email}) async {
    try {
      final res = await http.get(
        Uri.parse(
          '${Constants.url}/auth/verify/?email=$email&verification_code=$pin',
        ),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        },
      );

      return res.body;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<String> resendOTP({required String email}) async {
    try {
      final res = await http.post(
        Uri.parse(
          '${Constants.url}/auth/user/verify/resend',
        ),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        },
        body: {
          'email': email,
        },
      );

      return res.body;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<String> resetToken(
      {required String token, required String email}) async {
    try {
      final res = await http.get(
        Uri.parse(
          '${Constants.url}/auth/verify-password-reset-code?verification_code=$token&email=$email',
        ),
        // headers: {
        //   "Authorization": "Bearer ${HiveFunction.getUser().accessToken}",
        //   "Accept": "application/json",
        //   "token": HiveFunction.getUser().accessToken,
        //   'Content-Type': 'application/json'
        // },
      );

      return res.body;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<String> setPassword(
      {required String password, required String email}) async {
    try {
      final res = await http.post(
          Uri.parse(
            '${Constants.url}/auth/reset-password/confirm?email=$email',
          ),
          headers: {
            // "Authorization": "Bearer ${HiveFunction.getUser().accessToken}",
            "Accept": "application/json",
            // "token": HiveFunction.getUser().accessToken,
            'Content-Type': 'application/json'
          },
          body: json.encode({'password': password}));

      return res.body;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<String> forgotPassword({
    required String data,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(
          '${Constants.url}/auth/forgot-password/?email=$data',
        ),
      );

      return res.body;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<String> resetPassword({
    required Map<String, dynamic> data,
  }) async {
    try {
      print('-------------');
      final res = await http.post(
        Uri.parse(
          '${Constants.url}/auth/user/reset-password',
        ),
        body: data,
      );

      return res.body;
    } catch (e) {
      throw e.toString();
    }
  }

// -----------------------------------
  static Future<String> updateUser(
      {required Map<String, dynamic> user, required String token}) async {
    try {
      final res = await http.patch(
        Uri.parse(
          '${Constants.url}/auth/update/',
        ),
        headers: {
          "Authorization": "Bearer ${HiveFunction.getUser().accessToken}",
          "Accept": "application/json",
          "token": HiveFunction.getUser().accessToken,
          'Content-Type': 'application/json'
        },
        body: json.encode(user),
      );

      return checkAndrefeshToken(
        response: res,
        funt: () {
          updateUser(user: user, token: token);
        },
      );
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<String> changePassword({
    required Map<String, dynamic> data,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(
          '${Constants.url}/auth/change-password/',
        ),
        headers: {
          "Authorization": "Bearer ${HiveFunction.getUser().accessToken}",
          "Accept": "application/json",
          "token": HiveFunction.getUser().accessToken,
          'Content-Type': 'application/json'
        },
        body: json.encode(data),
      );

      return checkAndrefeshToken(
          response: res,
          funt: () {
            changePassword(data: data);
          });
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<String> getUserProfile() async {
    try {
      final res = await http.get(
        Uri.parse(
          '${Constants.url}/api/v1/auth/me/',
        ),
        headers: {
          "Authorization": "Bearer ${HiveFunction.getUser().accessToken}",
          "Accept": "application/json",
          "token": HiveFunction.getUser().accessToken,
          'Content-Type': 'application/json'
        },
      );

      return checkAndrefeshToken(
          response: res,
          funt: () {
            getUserProfile();
          });
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<String> deleteUser(String password) async {
    try {
      final res = await http.delete(
        Uri.parse(
          '${Constants.url}/auth/delete/?password_data=$password',
        ),
        headers: {
          "Authorization": "Bearer ${HiveFunction.getUser().accessToken}",
          "Accept": "application/json",
          "token": HiveFunction.getUser().accessToken,
          'Content-Type': 'application/json'
        },
      );

      return checkAndrefeshToken(
          response: res,
          funt: () {
            deleteUser(password);
          });
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<String> checkAndrefeshToken(
      {required http.Response response, required VoidCallback funt}) async {
    print(response.statusCode);
    if (response.statusCode == 401) {
      print("jndpsno");
      final res = await http.post(
        Uri.parse(
          '${Constants.url}/auth/refresh/',
        ),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        },
        body: json.encode(
          {'refresh_token': HiveFunction.getUser().refreshToken},
        ),
      );
      if (res.statusCode > 200 && res.statusCode < 300) {
        var body = json.decode(res.body);
        User user = HiveFunction.getUser().copyWith(
          accessToken: body['access_token'],
          refreshToken: body['refresh_token'],
        );
        HiveFunction.insertUser(user);
        funt.call();
      }
    }
    return response.body;
  }
}
