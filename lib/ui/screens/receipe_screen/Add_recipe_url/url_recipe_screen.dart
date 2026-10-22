// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocipe/app/app_widgets/app_back_button.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/validators.dart';
import 'package:grocipe/models/recipe.dart';
import 'package:grocipe/models/states/app_state.dart';
import 'package:grocipe/ui/provider/grocery_provider/recipe_provider.dart';

class UrlRecipeScreen extends ConsumerStatefulWidget {
  const UrlRecipeScreen({super.key});

  @override
  ConsumerState<UrlRecipeScreen> createState() => _UrlRecipeScreenState();
}

class _UrlRecipeScreenState extends ConsumerState<UrlRecipeScreen>
    with Validators {
  TextEditingController _url = TextEditingController();
  final signupForm = GlobalKey<FormState>();
  final btnNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    ref.listen<AppState<Recipe>>(recipeProvider, (previous, state) {
      btnNotifier.value = state is LoadingAppState;
      if (state is ListAppState<Recipe>) {
        context.showSuccessSnackBar('Recipe added successfully!');
        context.go(
          '/main_screen/recipe/view',
          extra: state.data.last,
        );
        context.pop();
      } else if (state is FailureAppState) {
        context.showErrorSnackBar("failed");
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        leadingWidth: 100,
        title: Text(l10n.addRecipeTitle),
      ),
      body: Form(
        key: signupForm,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppInputField(
                title: l10n.enterUrl,
                child: TextFormField(
                  controller: _url,
                  validator: validateName,
                  decoration: InputDecoration(
                    hintText: l10n.enterUrlHint,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: AppElevatedButton(
            notifier: btnNotifier,
            onPressed: signup,
            child: Text(l10n.next),
          ),
        ),
      ),
    );
  }

  Future signup() async {
    if (!signupForm.currentState!.validate()) return;

    await ref.read(recipeProvider.notifier).addRecipeUrl(_url.text);
  }
}
