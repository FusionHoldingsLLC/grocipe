// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/app/app_widgets/custom_text_button.dart';
import 'package:grocipe/app/app_widgets/password_field.dart';
import 'package:grocipe/app/app_widgets/svg_render_widget.dart';
import 'package:grocipe/blocs/user_bloc/user_bloc.dart';
import 'package:grocipe/helper/constants/svg_path.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/third_party/hive.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/validators.dart';
import 'package:grocipe/navigation/route_names.dart';
import 'package:grocipe/ui/provider/auth_provider.dart';
import 'package:provider/provider.dart' as provider;

class LoginScreen extends ConsumerStatefulWidget {
  LoginScreen({super.key, required this.email});

  String email;
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with Validators {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  bool obscuretext = true;
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  final loginForm = GlobalKey<FormState>();
  final btnNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    setState(() {
      _emailController.text = widget.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    var authProvider =
        provider.Provider.of<AuthenticationProvider>(context, listen: true);

    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        btnNotifier.value = state is UserProcessing && state.isLoginIN;
        if (state is userLoaded) {
          // context.showSuccessSnackBar(state.message);

          final user = HiveFunction.getUser();
          authProvider.update({
            "email": _emailController.text,
            "password": _passwordController.text
          });

          if (user.firstName.isNotEmpty) {
            context.replaceNamed(Routes.mainScreen);
          } else {
            context.replaceNamed(Routes.nameScreen);
          }
        } else if (state is UserError) {
          print(state.message);
          context.showErrorSnackBar(state.message);

          if (state.message == 'User is not verified.') {
            authProvider.update({"email": _emailController.text});
            context.goNamed(Routes.verifyEmail);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: const [SvgRenderWidget(svgPath: SvgPath.star), Gap(20)],
          ),
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: SafeArea(
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.8,
                child: Form(
                  key: loginForm,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Gap(70),
                            const Center(
                              child: SvgRenderWidget(
                                svgPath: "assets/svgs/loading1.svg",
                                width: 100,
                                height: 100,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Text('Continue with email',
                                  textAlign: TextAlign.center,
                                  style:
                                      context.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25,
                                  )),
                            ),
                            const Gap(30),

                            AppInputField(
                              title: l10n.email,
                              child: TextFormField(
                                controller: _emailController,
                                validator: validateEmail,
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: l10n.hintEmail,
                                ),
                              ),
                            ),

                            const Gap(20),
                            // const SizedBox(height: 16),
                            AppInputField(
                              title: l10n.password,
                              child: PasswordField(
                                validator: validatePassword,
                                controller: _passwordController,
                              ),
                            ),

                            const Gap(5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomTextButton(
                                  text: l10n.forgot,
                                  onPressed: () {
                                    context.goNamed(Routes.forgotPassword);
                                  },
                                  color:
                                      Theme.of(context).colorScheme.onTertiary,
                                )
                              ],
                            ),
                            const Gap(15),
                            AppElevatedButton(
                              notifier: btnNotifier,
                              onPressed: login,
                              child: Text(l10n.logIn),
                            ),
                          ],
                        ),
                        const Gap(30)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: 100,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l10n.dHaveAccount),
                      CustomTextButton(
                        text: " ${l10n.signUp}",
                        onPressed: () {
                          context.replaceNamed(Routes.emailChecker);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future login() async {
    if (!loginForm.currentState!.validate()) return;

    context.read<UserBloc>().add(SigninEvent(
        email: _emailController.text, password: _passwordController.text));
  }
}
