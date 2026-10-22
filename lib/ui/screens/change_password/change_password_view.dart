import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_back_button.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/password_field.dart';
import 'package:grocipe/blocs/user_bloc/user_bloc.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/size_config/size_config.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/validators.dart';

class ChnagePassword extends StatefulWidget {
  const ChnagePassword({super.key});

  @override
  State<ChnagePassword> createState() => _ChnagePasswordState();
}

class _ChnagePasswordState extends State<ChnagePassword> with Validators {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _npasswordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();
  bool obscuretext2 = true;
  bool obscuretext = true;
  bool obscuretext3 = true;
  final formKey = GlobalKey<FormState>();

  final List<String> _validationRules = [
    'More than 8 characters',
    'Contain UPPER CASE and lower case letter',
    'Contain Number',
    'Contain special character',
  ];

  final List<bool> _validationStatus = [false, false, false, false];
  final _passwordFocusNode = FocusNode();
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
  void dispose() {
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is userLoaded) {
          // context.showSuccessSnackBar(state.message);
          context.pop();
        } else if (state is UserError) {
          context.showErrorSnackBar(state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: const AppBackButton(),
            leadingWidth: 100,
            title: Text(
              l10n.changePassword,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(10),
                    Text(
                      l10n.setNewPassword,
                      style: context.textTheme.titleMedium,
                    ),
                    const Gap(25),
                    Text(
                      l10n.currentPassword,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Gap(5),
                    PasswordField(
                      controller: _passwordController,
                      validator: validatePassword,
                      hintText: "Password",
                    ),
                    const Gap(20),
                    const Text(
                      "Create new Password",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Gap(5),
                    PasswordField(
                      controller: _npasswordController,
                      validator: validatePassword,
                      onChanged: _validatePassword,
                      hintText: "Password",
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
                    const Text(
                      "Confirm new Password",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Gap(5),
                    PasswordField(
                      controller: _cpasswordController,
                      validator: (value) => validateConfirmPassword(
                          passowrd: _npasswordController.text,
                          confirmPassword: value),
                      hintText: l10n.confirmPassword,
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: 150,
            child: Center(
              child: SizedBox(
                width: SizeConfig.screenWidth * .9,
                child: AppElevatedButton(
                  notifier: ValueNotifier(
                      state is UserProcessing && state.isChangePassword),
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    // if (_npasswordController.text !=
                    //     _cpasswordController.text) {
                    //   context.showErrorSnackBar(l10n.passwordMismatch);
                    //   return;
                    // }
                    context.read<UserBloc>().add(
                          ChnageUserPasswrodEvent(
                              oldPassword: _passwordController.text,
                              newPassword: _cpasswordController.text),
                        );
                  },
                  child: Text(l10n.updatePassword),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
