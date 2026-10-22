import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_back_button.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/app/app_widgets/password_field.dart';
import 'package:grocipe/blocs/user_bloc/user_bloc.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/settings/palette.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/validators.dart';
import 'package:grocipe/navigation/route_names.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key, required this.email});
  final String email;
  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> with Validators {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();
  bool obscuretext = true;
  bool obscuretext2 = true;

  void popUntilPath(String routePath) {
    final router = GoRouter.of(context);
    while (router.canPop()) {
      context.pop();
    }
  }

  final passwordForm = GlobalKey<FormState>();
  final btnNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        btnNotifier.value = state is UserProcessing && state.isSetPassword;

        if (state is userLoaded) {
          // context.showSuccessSnackBar(state.message);
          context.goNamed(Routes.auth);
        } else if (state is UserError) {
          context.showErrorSnackBar(state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: AppBackButton(),
            leadingWidth: 100,
            actions: [
              Image.asset(
                'assets/images/global/Star.png',
              ),
              const Gap(20)
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Expanded(
                  child: Form(
                    key: passwordForm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.newPassword,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          l10n.setPasswordDescription,
                          style: TextStyle(
                            color: Palette.grey,
                            fontSize: 16,
                          ),
                        ),
                        const Gap(20),
                        AppInputField(
                          title: l10n.password,
                          child: PasswordField(
                            validator: validatePassword,
                            controller: _passwordController,
                          ),
                        ),
                        const Gap(20),
                        AppInputField(
                          title: l10n.password,
                          child: PasswordField(
                            validator: (value) => validateConfirmPassword(
                                passowrd: _passwordController.text,
                                confirmPassword: value),
                            controller: _cpasswordController,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 150,
                  color: Colors.transparent,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppElevatedButton(
                          notifier: btnNotifier,
                          onPressed: onSetPassword,
                          style: context.elevatedButtonTheme.style?.copyWith(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              context.primaryColor,
                            ),
                          ),
                          child: Text(l10n.updatePassword),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  onSetPassword() {
    if (!passwordForm.currentState!.validate()) return;

    context.read<UserBloc>().add(SetPasswordEvent(
        email: widget.email, password: _cpasswordController.text));
  }
}
