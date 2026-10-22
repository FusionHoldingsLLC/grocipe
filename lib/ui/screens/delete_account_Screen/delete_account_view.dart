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
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/validators.dart';
import 'package:grocipe/models/meal_plan_menu.dart';
import 'package:grocipe/navigation/route_names.dart';
import 'package:hive_flutter/adapters.dart';

class DeleteScreen extends StatefulWidget {
  const DeleteScreen({super.key});

  @override
  State<DeleteScreen> createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> with Validators {
  final cancleTextController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();
  bool obscuretext = true;
  bool obscuretext2 = true;
  final passwordForm = GlobalKey<FormState>();
  final btnNotifier = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        btnNotifier.value = state is UserProcessing && state.isDeleting;

        if (state is userLoaded) {
          context.goNamed(Routes.auth);
        }
      },
      builder: (context, state) {
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
            child: Form(
              key: passwordForm,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                  AppElevatedButton(
                    notifier: btnNotifier,
                    onPressed: () {
                      showCancleBottomSheet(context);
                    },
                    style: context.elevatedButtonTheme.style?.copyWith(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        context.colors.red,
                      ),
                    ),
                    child: Text(
                      l10n.deleteAccount,
                      style: context.textTheme.titleLarge!
                          .copyWith(color: context.colors.white),
                    ),
                  ),
                  Gap(40)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showCancleBottomSheet(BuildContext context) {
    final cancleBtnNotifier = ValueNotifier(false);
    final noCancleBtnNotifier = ValueNotifier(false);
    showModalBottomSheet(
        context: context,
        backgroundColor: context.colors.white,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.9,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Final confrimation",
                      style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: context.colors.black),
                    ),
                    const Gap(20),
                    Text(
                        "Are you absolutely sure you want to delete your account? This will permanently remove all your data and cannot be undone.",
                        style: context.textTheme.bodyMedium),
                    const Gap(10),
                    Text(
                        "You will lose access to premium features, and your plan will include ads.",
                        style: context.textTheme.bodyMedium),
                    const Gap(20),
                    AppInputField(
                      title: "Reasons for deleting account *",
                      child: TextFormField(
                        controller: cancleTextController,
                        decoration: const InputDecoration(
                          hintText: "Enter reason here",
                        ),
                      ),
                    ),
                    const Gap(20),
                    AppElevatedButton(
                      onPressed: () async {
                        cancleBtnNotifier.value = true;
                        Navigator.pop(context);
                      },
                      notifier: cancleBtnNotifier,
                      color: context.primaryColor,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.primaryColor,
                        side: BorderSide(color: context.primaryColor, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "No, keep my Account",
                        style: context.textTheme.titleLarge!
                            .copyWith(color: context.colors.white),
                      ),
                    ),
                    const Gap(20),
                    AppElevatedButton(
                      onPressed: () async {
                        if (_passwordController.text.isNotEmpty &
                            _passwordController.text.isNotEmpty) {
                          noCancleBtnNotifier.value = true;
                          onDeletePassword();
                        } else {
                          context.showErrorSnackBar(
                              "Please provide your correct credentials");
                        }
                      },
                      notifier: noCancleBtnNotifier,
                      color: context.primaryColor,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.errorColor.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "Delete my Account",
                        style: context.textTheme.titleLarge!.copyWith(
                            decoration: TextDecoration.underline,
                            color: context.errorColor,
                            decorationColor: context.errorColor),
                      ),
                    ),
                    const Gap(20),
                  ],
                ),
              ),
            );
          });
        });
  }

  void successfulDeleteBottomSheet(BuildContext context) {
    final cancleBtnNotifier = ValueNotifier(false);
    showModalBottomSheet(
        context: context,
        backgroundColor: context.colors.white,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 2.6,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your account has been successfully deleted. ",
                      style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: context.colors.black),
                    ),
                    const Gap(20),
                    Text(
                        "We're sorry to see you go. If you change your mind, please contact our support team.",
                        style: context.textTheme.bodyMedium),
                    const Gap(20),
                    AppElevatedButton(
                      onPressed: () async {
                        cancleBtnNotifier.value = true;
                        Navigator.pop(context);
                        context.replaceNamed(Routes.authState);
                      },
                      notifier: cancleBtnNotifier,
                      color: context.primaryColor,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.primaryColor,
                        side: BorderSide(color: context.primaryColor, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "Create account",
                        style: context.textTheme.titleLarge!
                            .copyWith(color: context.colors.white),
                      ),
                    ),
                    const Gap(20),
                  ],
                ),
              ),
            );
          });
        });
  }

  onDeletePassword() async {
    if (!passwordForm.currentState!.validate()) return;

    context
        .read<UserBloc>()
        .add(DeleteAccount(password: _passwordController.text));

    final groceryorderBox = await Hive.openBox('groceryOrdersCache');
    final mealPlanBox = await Hive.openBox<MealPlanMenu>('mealPlanBox');
    mealPlanBox.clear();
    groceryorderBox.clear();
    // successfulDeleteBottomSheet(context);
  }
}
