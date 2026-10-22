// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/app/app_widgets/svg_render_widget.dart';
import 'package:grocipe/helper/constants/svg_path.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/validators.dart';
import 'package:grocipe/navigation/route_names.dart';
import 'package:grocipe/services/auth_service.dart';

class EmailChecker extends ConsumerStatefulWidget {
  const EmailChecker({
    super.key,
  });
  @override
  ConsumerState<EmailChecker> createState() => _EmailCheckerState();
}

class _EmailCheckerState extends ConsumerState<EmailChecker> with Validators {
  final btnNotifier = ValueNotifier(false);
  final emailForm = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        actions: const [SvgRenderWidget(svgPath: SvgPath.star), Gap(20)],
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.8,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: emailForm,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Gap(100),
                        const Center(
                          child: SvgRenderWidget(
                            svgPath: "assets/svgs/loading1.svg",
                            width: 100,
                            height: 100,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                              'Say hello to effortless \nmeals, everyday.',
                              textAlign: TextAlign.center,
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 25,
                              )),
                        ),
                        const SizedBox(height: 80),
                        AppInputField(
                          title: l10n.email,
                          child: TextFormField(
                            controller: emailController,
                            validator: validateEmail,
                            decoration: InputDecoration(
                              hintText: l10n.hintEmail,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        AppElevatedButton(
                          notifier: btnNotifier,
                          onPressed: continueWithEmail,
                          child: const Text("Continue"),
                        ),
                        const Gap(40),
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
    );
  }

  Future continueWithEmail() async {
    if (!emailForm.currentState!.validate()) return;
    try {
      btnNotifier.value = true;
      await ref.read(authService).checkEmailExist(emailController.text);

      btnNotifier.value = false;

      context.replaceNamed(
        Routes.signIn,
        extra: emailController.text,
      );
    } catch (error) {
      // context.showErrorSnackBar(error);
      if ((error.toString()) == "Incorrect email or password.") {
        context.replaceNamed(
          Routes.signUp,
          extra: emailController.text,
        );
      }
      print(error);
    } finally {
      btnNotifier.value = false;
    }

    // context.replaceNamed(Routes.signUp);
  }
}
