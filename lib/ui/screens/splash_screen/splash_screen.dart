// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/blocs/user_bloc/user_bloc.dart';
import 'package:grocipe/helper/size_config/size_config.dart';
import 'package:grocipe/helper/third_party/hive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SizeConfig.init(context);
    });
    super.initState();
    init();
  }

  init() {
    Future.delayed(const Duration(seconds: 3), () {
      if (HiveFunction.userExist()) {
        print(HiveFunction.getUser().toJson());

        var user = HiveFunction.getUser();
        print(user.refreshToken);
        context.read<UserBloc>().add(
              RestoreUserEvent(user: HiveFunction.getUser()),
            );
      } else {
        context.go('/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is userLoaded) {
          context.replace('/main_screen');
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(child: Image.asset('assets/images/onboarding/logo.png')),
        );
      },
    );
  }
}
