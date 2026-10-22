import 'dart:async';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/app/app_widgets/custom_text_button.dart';
import 'package:grocipe/app/app_widgets/image_render_widget.dart';
import 'package:grocipe/app/app_widgets/password_field.dart';
import 'package:grocipe/app/app_widgets/svg_render_widget.dart';
import 'package:grocipe/blocs/user_bloc/user_bloc.dart';
import 'package:grocipe/helper/constants/svg_path.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/third_party/google.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/image_utils.dart';
import 'package:grocipe/helper/utils/url_launcher_service.dart';
import 'package:grocipe/helper/utils/validators.dart';
import 'package:grocipe/navigation/route_names.dart';
import 'package:grocipe/ui/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class SignUpScreen2 extends StatefulWidget {
  const SignUpScreen2({key});
  static String id = "/sign_up";
  @override
  State<SignUpScreen2> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen2> with Validators {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();

  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool loading = false;

  bool agreedTerms = false;
  late TapGestureRecognizer _tapGestureRecognizer;
  late TapGestureRecognizer _tapGestureRecognizerTerms;
  //////
  final signupForm = GlobalKey<FormState>();
  final btnNotifier = ValueNotifier(false);

  File? imageFile;

  @override
  void initState() {
    super.initState();

    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () async {
        var url = "github.com/mik3yyy/study_stat_policy";

        AppInterfaceService.launchLink(url);
      };
    _tapGestureRecognizerTerms = TapGestureRecognizer()
      ..onTap = () async {
        showAboutDialog(
            context: context,
            applicationName: "Study Stats",
            applicationVersion: "1.0.0",
            children: [
              const Text(
                // ignore: prefer_interpolation_to_compose_strings
                '1. Acceptance of Terms: By downloading, accessing, or using the Study Stats mobile application Study Stats, you agree to be bound by these Terms and Conditions. If you do not agree with any part of these terms, you may not use the App.' +
                    "\n2. Use of the App: Study Stats is intended solely for personal, non-commercial use. You may use the App to track your academic performance and set goals related to your GPA." +
                    "\n3. User Accounts: You may be required to create a user account to access certain features of the App. You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account." +
                    "\n4. Data Privacy: We are committed to protecting your privacy. We will not share your personal information with third parties without your consent. Please review our Privacy Policy for more information."
                        "\n5. Accuracy of Information:While we strive to provide accurate GPA calculations and analysis, we cannot guarantee the accuracy or completeness of the information provided by the App. You are responsible for verifying the accuracy of your academic data."
                        "\n6. Intellectual Property:The App and its content, including but not limited to text, graphics, logos, and images, are the property of Study Stats and are protected by copyright and other intellectual property laws. You may not reproduce, modify, or distribute any part of the App without our prior written consent."
                        "\n7. Updates and Changes:We may update or change the App, including its features and functionality, at any time without notice. By continuing to use the App after such updates or changes, you agree to be bound by the revised Terms and Conditions."
                        "\n8. Limitation of Liability: In no event shall Study Stats be liable for any indirect, incidental, special, consequential, or punitive damages arising out of or related to your use of the App."
                        "\n9. Governing Law: These Terms and Conditions shall be governed by and construed in accordance with the laws of [Jurisdiction], without regard to its conflict of law principles."
                        "\n10. Contact Us: If you have any questions or concerns about these Terms and Conditions, please contact us at [contact email].",
              )
            ]);
      };
  }

  void pickImageFromGallery() async {
    imageFile = await ImageUtils.pickImage(95);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    var authProvider =
        Provider.of<AuthenticationProvider>(context, listen: true);
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        btnNotifier.value = state is UserProcessing && state.isSignup;

        if (state is userLoaded) {
          if (state.isExternal) {
            context.replaceNamed(Routes.mainScreen);
            // context.showSuccessSnackBar(state.message);
          } else {
            // context.showSuccessSnackBar(state.message);
            authProvider.update({"email": _emailController.text});

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
                          Text(
                            l10n.signUp,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Gap(10),
                          AppInputField(
                            title: "First Name",
                            child: TextFormField(
                              controller: _nameController,
                              validator: validateName,
                              decoration: const InputDecoration(
                                hintText: "Enter First Name",
                              ),
                            ),
                          ),
                          const Gap(20),
                          AppInputField(
                            title: "Last Name",
                            child: TextFormField(
                              controller: _lnameController,
                              validator: validateName,
                              decoration: const InputDecoration(
                                hintText: "Enter Last Name",
                              ),
                            ),
                          ),
                          const Gap(20),
                          AppInputField(
                            title: l10n.email,
                            child: TextFormField(
                              controller: _emailController,
                              validator: validateEmail,
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
                          const Gap(20),
                          if (imageFile == null) ...[
                            GestureDetector(
                              onTap: () async {
                                imageFile = await ImageUtils.pickImage();
                                setState(() {});
                              },
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                dashPattern:
                                    imageFile == null ? [2, 10] : [1, 1],
                                radius: const Radius.circular(12),
                                padding: const EdgeInsets.all(6),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  child: Container(
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const CircleAvatar(
                                          radius: 15,
                                          backgroundColor: Color(0xFFB3BFCB),
                                          child: Center(
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "  ${l10n.addImage}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ] else ...[
                            GestureDetector(
                              onTap: () async {
                                imageFile = await ImageUtils.pickImage();
                                setState(() {});
                              },
                              child: ClipRRect(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              child: SizedBox(
                                                  width: 70,
                                                  child: ImageRenderWidget.file(
                                                      file: imageFile!)),
                                            ),
                                            const Gap(40),
                                            Expanded(
                                              child: Text(
                                                "${_nameController.text}.png",
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            imageFile = null;
                                          });
                                        },
                                        icon: const Icon(Icons.delete),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                          const Gap(20),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Checkbox(
                                    value: agreedTerms,
                                    activeColor: Theme.of(context)
                                        .colorScheme
                                        .onTertiary,
                                    checkColor: Colors.white,
                                    side: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onTertiary,
                                    ),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    onChanged: (value) {
                                      setState(() {
                                        agreedTerms = !agreedTerms;
                                      });
                                    },
                                  ),
                                ),
                                const Gap(10),
                                Expanded(
                                  child: RichText(
                                    // maxLines: 5,
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      style: context.textTheme.titleLarge,
                                      children: [
                                        TextSpan(
                                          text: '${l10n.agree}  ',
                                        ),
                                        TextSpan(
                                          text: l10n.tAndC,
                                          recognizer:
                                              _tapGestureRecognizerTerms,
                                          style:
                                              context.textTheme.displayMedium,
                                        ),
                                        TextSpan(
                                          text: " ${l10n.agree2} ",
                                        ),
                                        TextSpan(
                                          text: l10n.privacyPolicy,
                                          recognizer: _tapGestureRecognizer,
                                          style:
                                              context.textTheme.displayMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                      style: context.elevatedButtonTheme.style?.copyWith(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              agreedTerms
                                  ? context.primaryColor
                                  : context.colors.captionGrey)),
                      child: Text(l10n.signUp),
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

    if (imageFile == null) {
      context.showMessage("Please select a profile image");
      return;
    }

    if (!agreedTerms) {
      context.showMessage("You must Agree to terms and Conditions");
      return;
    }

    context.read<UserBloc>().add(
          SignUpEvent(
            f_name: _nameController.text,
            l_name: _lnameController.text,
            email: _emailController.text,
            password: _passwordController.text,
            image: imageFile?.path ?? "",
          ),
        );
  }
}
