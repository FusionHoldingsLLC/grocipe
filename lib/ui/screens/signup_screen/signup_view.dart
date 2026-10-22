// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/app/app_widgets/custom_text_button.dart';
import 'package:grocipe/app/app_widgets/password_field.dart';
import 'package:grocipe/app/app_widgets/svg_render_widget.dart';
import 'package:grocipe/blocs/user_bloc/user_bloc.dart';
import 'package:grocipe/helper/constants/svg_path.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/third_party/google.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/image_utils.dart';
import 'package:grocipe/helper/utils/validators.dart';
import 'package:grocipe/navigation/route_names.dart';
import 'package:grocipe/ui/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key, required this.email});
  static String id = "/sign_up";

  String email;
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with Validators {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool loading = false;
  final signupForm = GlobalKey<FormState>();
  final btnNotifier = ValueNotifier(false);

  File? imageFile;

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _emailController.text = widget.email;
    });
  }

  void pickImageFromGallery() async {
    imageFile = await ImageUtils.pickImage(95);
  }

  final _passwordFocusNode = FocusNode();

  final _validationRules = [
    'More than 8 characters',
    'Contain UPPER CASE and lower case letter',
    'Contain number',
    'Contain special character',
  ];

  final List<bool> _validationStatus = [false, false, false, false];

  void _validatePassword(String password) {
    setState(() {
      _validationStatus[0] = password.length > 8;
      _validationStatus[1] =
          RegExp(r'^(?=.*[a-z])(?=.*[A-Z])').hasMatch(password);
      _validationStatus[2] = RegExp(r'^(?=.*\d)').hasMatch(password);
      _validationStatus[3] =
          RegExp(r'^(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(password);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    var authProvider =
        Provider.of<AuthenticationProvider>(context, listen: true);
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        btnNotifier.value = (state is UserProcessing && state.isSignup) ||
            (state is UserProcessing && state.isLoginIN);

        if (state is userLoaded) {
          if (state.isExternal) {
            context.replaceNamed(Routes.mainScreen);
            // context.showSuccessSnackBar(state.message);
          } else {
            // context.showSuccessSnackBar(state.message);

            authProvider.update({
              "email": _emailController.text,
              "password": _passwordController.text
            });

            context.goNamed(Routes.verifyEmail);
          }
        } else if (state is UserError) {
          context.showErrorSnackBar(state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: const [SvgRenderWidget(svgPath: SvgPath.star), Gap(20)],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: signupForm,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                style: context.textTheme.titleMedium?.copyWith(
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
                          AppInputField(
                            title: l10n.password,
                            child: PasswordField(
                              validator: validatePassword,
                              onChanged: _validatePassword,
                              controller: _passwordController,
                            ),
                          ),
                          const Gap(20),
                          ...List.generate(_validationRules.length, (index) {
                            return Row(
                              children: [
                                Icon(
                                  _validationStatus[index]
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: _validationStatus[index]
                                      ? context.primaryColor
                                      : context.colors.orangeDecor,
                                ),
                                const SizedBox(width: 8),
                                Text(_validationRules[index]),
                              ],
                            );
                          }),
                          const Gap(20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 150,
            color: Colors.transparent,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppElevatedButton(
                      notifier: btnNotifier,
                      onPressed: signup,
                      child: const Text("Sign Up"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l10n.haveAccount),
                        CustomTextButton(
                          text: l10n.logIn,
                          onPressed: () {
                            context.replaceNamed(Routes.auth);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future googleSignin() async {
    try {
      final GoogleSignInAccount? googleAccount = await GoogleApi.googleSignIn();

      final GoogleSignInAuthentication googleAuthentication =
          await googleAccount!.authentication;

      if (googleAuthentication.idToken != null) {
        context.read<UserBloc>().add(
              GoogleSignInEvent(
                id: googleAuthentication.idToken!,
              ),
            );
      }
    } catch (e) {}
  }

  Future signup() async {
    if (!signupForm.currentState!.validate()) return;

    context.read<UserBloc>().add(
          SignUpEvent(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );
  }
}
