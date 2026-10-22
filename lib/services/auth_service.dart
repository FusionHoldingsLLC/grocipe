import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocipe/api/api_urls.dart';
import 'package:grocipe/api/network.dart';
import 'package:grocipe/blocs/user_bloc/user_bloc.dart';
import 'package:grocipe/helper/third_party/hive.dart';
import 'package:grocipe/models/user.dart';
import 'package:grocipe/ui/provider/profile_provider.dart';

class AuthService {
  final Ref ref;

  AuthService(this.ref);

  Network get network => ref.read(networkProvider);
  ProfileProvider get profile => ref.read(profileProvider.notifier);

  Future<bool> login({
    required String password,
    required String email,
  }) async {
    final res = await network.call(
        "${UrlConfig.login}?username=$email&password=$password",
        RequestMethod.post,
        data: jsonEncode({
          'username': email,
          'password': password,
          "scope": '',
          "client_id": '',
          "client_secret": '',
          "grant_type": '',
        }),
        showLog: true);
    var response = res.data;

    if (response['detail'] is List) {
      List.from(res.data ?? []);
      return false;
    } else if (response['access_token'] != null) {
      User user = User.fromJson(response);
      await profile.setUserData(user);

      return true;
    }
    return false;
  }

  Future<bool> updateUserData(
    BuildContext context, {
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    Map<String, dynamic> data = {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "profile_picture_url": "",
      "trial_start_date": DateTime.now().toIso8601String()
    };

    final res = await network.call(UrlConfig.updateUser, RequestMethod.patch,
        data: jsonEncode(data), showLog: true);
    var response = res.data;

    if (response['detail'] is List) {
      List.from(res.data ?? []);
      return false;
    } else {
      var savedUser = HiveFunction.getUser();

      savedUser = savedUser.copyWith(
          firstName: response['first_name'], lastName: response['last_name']);

      // User user = User.fromJson(response);
      await profile.setUserData(savedUser);

      context.read<UserBloc>().add(
            RestoreUserEvent(user: savedUser),
          );

      return true;
    }
  }

  Future<Map?> checkEmailExist(String email) async {
    Map<String, dynamic>? queryParams = {"email": email};

    final res = await network.call(
      UrlConfig.emailChecker,
      queryParams: queryParams,
      RequestMethod.post,
      showLog: true,
    );
    print(res.data);
    return res.data;
  }

  Future<bool> refreshToken() async {
    var currentUser = HiveFunction.getUser();
    final res = await network.call(
      UrlConfig.refreshToken,
      RequestMethod.post,
      data: jsonEncode({
        "refresh_token": currentUser.refreshToken,
      }),
      showLog: true,
    );
    var response = res.data;

    if (response['access_token'] != null) {
      var user = HiveFunction.getUser();

      await profile.setUserData(user.copyWith(
          accessToken: response['access_token'],
          refreshToken: response['refresh_token']));

      return true;
    }
    return false;
  }
}

final authService = Provider<AuthService>((ref) => AuthService(ref));
