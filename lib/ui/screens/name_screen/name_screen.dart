// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_back_button.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/validators.dart';
import 'package:grocipe/navigation/route_names.dart';
import 'package:grocipe/services/auth_service.dart';
import 'package:grocipe/ui/provider/auth_provider.dart';
import 'package:provider/provider.dart' as provider;

class NameScreen extends ConsumerStatefulWidget {
  const NameScreen({super.key});

  @override
  ConsumerState<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends ConsumerState<NameScreen> with Validators {
  final btnNotifier = ValueNotifier(false);

  final nameForm = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  late String email;

  @override
  void initState() {
    var authProvider =
        provider.Provider.of<AuthenticationProvider>(context, listen: false);
    email = "${authProvider.signUpdata['email']}";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(
          onTap: () => context.replaceNamed(Routes.signIn),
        ),
      ),
      body: Form(
        key: nameForm,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(30),
                      const Text(
                        "Let us know you",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 33,
                        ),
                      ),
                      const Gap(25),
                      const Text(
                        "Please enter your full name. ",
                        textAlign: TextAlign.left,
                      ),
                      const Gap(10),
                      AppInputField(
                        title: "First Name",
                        child: TextFormField(
                          controller: firstName,
                          validator: validateName,
                          decoration: const InputDecoration(
                            hintText: "eg. Ryan",
                          ),
                        ),
                      ),
                      const Gap(10),
                      AppInputField(
                        title: "Last Name",
                        child: TextFormField(
                          controller: lastName,
                          validator: validateName,
                          decoration: const InputDecoration(
                            hintText: "eg. Giggs",
                          ),
                        ),
                      ),
                      const Gap(25),
                    ],
                  ),
                ),
                const Gap(20),
                AppElevatedButton(
                  notifier: btnNotifier,
                  onPressed: update,
                  child: const Text("Continue"),
                ),
                const Gap(40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future update() async {
    if (!nameForm.currentState!.validate()) return;
    try {
      btnNotifier.value = true;
      await ref.read(authService).updateUserData(
            context,
            firstName: firstName.text,
            lastName: lastName.text,
            email: email,
          );
      btnNotifier.value = false;
      // context.showSuccessSnackBar("");
      context.replaceNamed(Routes.welcomonb);
    } catch (error) {
      context.showErrorSnackBar(error);
    } finally {
      btnNotifier.value = false;
    }
  }
}
