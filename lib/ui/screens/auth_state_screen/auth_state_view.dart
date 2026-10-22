import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/loading_widget.dart';
import 'package:grocipe/blocs/user_bloc/user_bloc.dart';
import 'package:grocipe/helper/third_party/hive.dart';
import 'package:grocipe/navigation/route_names.dart';
import 'package:grocipe/ui/provider/auth_provider.dart';
import 'package:provider/provider.dart' as provider;

class AuthStateScreen extends StatefulWidget {
  const AuthStateScreen({super.key});

  @override
  State<AuthStateScreen> createState() => _AuthStateScreenState();
}

class _AuthStateScreenState extends State<AuthStateScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    var authProvider =
        provider.Provider.of<AuthenticationProvider>(context, listen: false);

    context.read<UserBloc>().add(SigninEvent(
        email: authProvider.signUpdata["email"],
        password: authProvider.signUpdata["password"]));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        final user = HiveFunction.getUser();
        if (state is userLoaded) {
          if (user.firstName.isNotEmpty) {
            context.replaceNamed(Routes.mainScreen);
          } else {
            context.replaceNamed(Routes.nameScreen);
          }
        }
      },
      builder: (context, state) {
        return const Scaffold(
          body: Center(
              child:
                  LoadingWidget(loaderMessage: "Setting up your account...")),
        );
      },
    );
  }
}
