import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_back_button.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/blocs/user_bloc/user_bloc.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/validators.dart';
import 'package:grocipe/navigation/route_names.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> with Validators {
  final TextEditingController _emailController = TextEditingController();
  final btnNotifier = ValueNotifier(false);
  final emailForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        btnNotifier.value = state is UserProcessing && state.isForgotPassword;
        if (state is userLoaded) {
          context.goNamed(
            Routes.verifyToken,
            pathParameters: {'email': _emailController.text},
          );
        } else if (state is UserError) {
          context.showErrorSnackBar(state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: const AppBackButton(),
            leadingWidth: 100,
            actions: [
              Image.asset(
                'assets/images/global/Star.png',
              ),
              const Gap(20)
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(20),
                        Text(l10n.forgotPassword,
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                            )),
                        const Gap(20),
                        Text(
                          l10n.forgotPasswordDescription,
                          style: context.textTheme.bodyLarge,
                        ),
                        const Gap(30),
                        Form(
                          key: emailForm,
                          child: AppInputField(
                            title: l10n.email,
                            child: TextFormField(
                              controller: _emailController,
                              validator: validateEmail,
                              decoration: InputDecoration(
                                hintText: l10n.hintEmail,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 150,
                    child: Center(
                      child: AppElevatedButton(
                        notifier: btnNotifier,
                        onPressed: confirm,
                        style: context.elevatedButtonTheme.style?.copyWith(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              context.primaryColor),
                        ),
                        child: Text(l10n.continueText),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future confirm() async {
    if (!emailForm.currentState!.validate()) return;

    context.read<UserBloc>().add(
          ForotPasswordEvent(
            email: _emailController.text,
          ),
        );
  }
}
