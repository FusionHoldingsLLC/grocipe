import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_back_button.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/validators.dart';

class DeleteWarning extends StatefulWidget {
  const DeleteWarning({super.key});

  @override
  State<DeleteWarning> createState() => _DeleteWarningState();
}

class _DeleteWarningState extends State<DeleteWarning> with Validators {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        leadingWidth: 100,
        title: Text(
          l10n.deleteAccount,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(20),
              Text(
                "Are you sure you want to delete your account? ",
                style: context.textTheme.displayLarge
                    ?.copyWith(color: context.colors.black),
              ),
              const Gap(20),
              RichText(
                text: TextSpan(
                  text: 'This action will permanently remove:\n',
                  style: context.textTheme.bodyLarge,
                  children: [
                    TextSpan(
                      text: ' • Your profile and Recipes\n',
                      style: context.textTheme.bodyLarge,
                    ),
                    TextSpan(
                      text: ' • All your saved recipes and meal plans\n',
                      style: context.textTheme.bodyLarge,
                    ),
                    TextSpan(
                      text: '  • Your shopping lists and recipe history\n',
                      style: context.textTheme.bodyLarge,
                    ),
                    TextSpan(
                      text: ' • Your access to Grocipe AI',
                      style: context.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const Gap(20),
              Text(
                "This action cannot be undone.",
                style: context.textTheme.displayLarge
                    ?.copyWith(color: context.colors.black),
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 150,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.transparent,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.go("/main_screen/profile/delete");
                },
                style: context.elevatedButtonTheme.style?.copyWith(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    context.colors.red,
                  ),
                ),
                child: Text(
                  l10n.deleteAccount.toUpperCase(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
