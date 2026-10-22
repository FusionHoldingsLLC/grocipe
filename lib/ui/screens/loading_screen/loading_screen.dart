// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/loading_widget.dart';
import 'package:grocipe/blocs/user_bloc/user_bloc.dart';
import 'package:grocipe/helper/size_config/size_config.dart';
import 'package:grocipe/helper/third_party/hive.dart';
import 'package:grocipe/helper/third_party/stripe.dart';
import 'package:grocipe/navigation/route_names.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SizeConfig.init(context);
    });
    // initUniLinks();

    super.initState();
    init();
  }

  init() {
    Future.delayed(const Duration(seconds: 3), () {
      if (HiveFunction.userExist()) {
        print(HiveFunction.getUser().toJson());
        context.read<UserBloc>().add(
              RestoreUserEvent(user: HiveFunction.getUser()),
            );
      } else {
        _loadDataOnInit();
      }
    });
  }

  Future _loadDataOnInit() async {
    try {
      StripePaymentHandle paymentHandle = StripePaymentHandle(context: context);
      String result = await paymentHandle.checkSubscriptionType();
      context.read<UserBloc>().add(
            RestoreUserEvent(user: HiveFunction.getUser()),
          );

      if (result != null || result.isNotEmpty || result != "Free") {
        context.replaceNamed(Routes.onboardingPlanScreen);
      } else {
        context.replaceNamed(Routes.mainScreen);
      }
    } catch (e) {
      print("Error loading subscription type: $e");
    }
  }

  StreamSubscription? _sub;

  // Future<void> initUniLinks() async {
  //   // ... check initialLink
  //   final initialUri = await getInitialUri();
  //   if (initialUri != null) {
  //     onReceivingLink(initialUri.toString());
  //   }
  //   // Attach a listener to the stream
  //   _sub = linkStream.listen(
  //     (String? link) {
  //       if (link != null) {
  //         onReceivingLink(link);
  //       }
  //     },
  //     onError: (err) {},
  //   );
  // }

  onReceivingLink(String? link) {
    if (link != null) {
      int m = link.indexOf(':');
      String param = link.substring(m + 1);
      print(param);
      context.go("/" + param);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is userLoaded) {
          _loadDataOnInit();
        }
      },
      builder: (context, state) {
        return const Scaffold(
          body: Center(
              child: LoadingWidget(
            loaderMessage: 'Personalizing..',
          )),
        );
      },
    );
  }
}
