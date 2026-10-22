// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:grocipe/repository/user_repo/user_data_provider.dart';
import 'package:grocipe/repository/user_repo/user_repo.dart';

class userRepoImp implements UserRepo {
  @override
  Future<void> deleteUser() {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> singUp(Map<String, dynamic> user) async {
    try {
      final res = await UserDataProvider.signUp(user);
      final data = jsonDecode(res);

      return data;
    } catch (e) {
      print(e.toString());
      return {'success': false, 'message': 'Check your network'};
    }
  }

  @override
  Future<Map<String, dynamic>> googleSingUp(String id) async {
    try {
      final res = await UserDataProvider.googleSignin(id);
      final data = jsonDecode(res);

      return data;
    } catch (e) {
      print(e.toString());
      return {'success': false, 'message': 'Check your network'};
    }
  }

  @override
  Future<Map<String, dynamic>> appleSingUp(String id) async {
    try {
      final res = await UserDataProvider.appleSignin(id);
      final data = jsonDecode(res);

      return data;
    } catch (e) {
      print(e.toString());
      return {'success': false, 'message': 'Check your network'};
    }
  }

  @override
  Future<Map<String, dynamic>> signIn(
      {required String email, required String password}) async {
    try {
      final res = await UserDataProvider.signIn(email, password);
      final data = jsonDecode(res);
      return data;
    } catch (e) {
      print(e.toString());
      return {'success': false, 'message': 'Check your network'};
    }
  }

  @override
  Future<Map<String, dynamic>> verifyEmail(
      {required String pin, required String email}) async {
    try {
      final res = await UserDataProvider.verify(pin: pin, email: email);
      final data = jsonDecode(res);
      return data;
    } catch (e) {
      print(e.toString());
      return {'success': false, 'message': 'Check your network'};
    }
  }

  @override
  Future<Map<String, dynamic>> resendOTP(
      {required String email, required String password}) async {
    // TODO: implement resendOTP
    try {
      final res = await UserDataProvider.resendOTP(email: email);
      final data = jsonDecode(res);
      return data;
    } catch (e) {
      print(e.toString());
      return {'success': false, 'message': 'Check your network'};
    }
  }

  @override
  Future<Map<String, dynamic>> updateUser(
      Map<String, dynamic> user, String token) async {
    // TODO: implement updateUser
    try {
      final res = await UserDataProvider.updateUser(user: user, token: token);
      final data = jsonDecode(res);
      return data;
    } catch (e) {
      print(e.toString());
      return {'success': false, 'message': 'Check your network'};
    }
  }

  @override
  Future<Map<String, dynamic>> changePassword(
    Map<String, dynamic> Data,
  ) async {
    // TODO: implement changePassword
    try {
      final res = await UserDataProvider.changePassword(
        data: Data,
      );
      final data = jsonDecode(res);
      return data;
    } catch (e) {
      print(e.toString());
      return {'success': false, 'message': 'Check your network'};
    }
  }

  @override
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final res = await UserDataProvider.forgotPassword(
        data: email,
      );
      final data = jsonDecode(res);
      return data;
    } catch (e) {
      print(e.toString());
      return {'success': false, 'message': 'Check your network'};
    }
  }

  @override
  Future<Map<String, dynamic>> resetPassword(Map<String, dynamic> Data) async {
    try {
      final res = await UserDataProvider.resetPassword(
        data: Data,
      );
      final data = jsonDecode(res);
      return data;
    } catch (e) {
      print(e.toString());
      return {'success': false, 'message': 'Check your network'};
    }
  }

  @override
  Future<Map<String, dynamic>> getUserprofile() async {
    // TODO: implement getUserprofile
    try {
      final res = await UserDataProvider.getUserProfile();
      final data = jsonDecode(res);
      return data;
    } catch (e) {
      print(e.toString());
      return {'success': false, 'message': 'Check your network'};
    }
  }

  @override
  Future<Map<String, dynamic>> deleteAccount(String password) async {
    try {
      final res = await UserDataProvider.deleteUser(password);
      final data = jsonDecode(res);
      return data;
    } catch (e) {
      print(e.toString());
      return {'success': false, 'message': 'Check your network'};
    }
  }

  @override
  Future<Map<String, dynamic>> verifyResetToken(
      {required String token, required String email}) async {
    try {
      final res = await UserDataProvider.resetToken(token: token, email: email);
      print(res);
      final data = jsonDecode(res);
      return data;
    } catch (e) {
      print(e.toString());
      return {'success': false, 'message': 'Check your network'};
    }
  }

  @override
  Future<Map<String, dynamic>> setPassword(
      {required String password, required String email}) async {
    try {
      final res =
          await UserDataProvider.setPassword(password: password, email: email);
      print(res);
      final data = jsonDecode(res);
      return data;
    } catch (e) {
      print(e.toString());
      return {'success': false, 'message': 'Check your network'};
    }
  }

  // @override
  // Future<Map<String, dynamic>> submitSurvey() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? surveyString = prefs.getString('survey_data');
  //   if (surveyString != null) {
  //     return Map<String, String>.from(jsonDecode(surveyString));
  //   }

  // }
}
