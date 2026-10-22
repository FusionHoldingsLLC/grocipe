// ignore_for_file: use_build_context_synchronously, avoid_print
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/app/app_widgets/image_render_widget.dart';
import 'package:grocipe/app/app_widgets/svg_render_widget.dart';
import 'package:grocipe/blocs/user_bloc/user_bloc.dart';
import 'package:grocipe/helper/constants/svg_path.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/validators.dart';
import 'package:grocipe/navigation/route_names.dart';
import 'package:grocipe/services/auth_service.dart';
import 'package:grocipe/ui/provider/auth_provider.dart';
import 'package:grocipe/ui/provider/onbording_provider.dart';
import 'package:provider/provider.dart' as provider;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({
    super.key,
  });
  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

bool isLoading = false;

class _AuthWrapperState extends ConsumerState<AuthWrapper> with Validators {
  final btnNotifier = ValueNotifier(false);
  final googleBtnNotifier = ValueNotifier(false);
  final appleBtnNotifier = ValueNotifier(false);
  final emailForm = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final onboardingNotifier = ref.read(onboardingProvider.notifier);
    final l10n = context.l10n;
    var authProvider =
        provider.Provider.of<AuthenticationProvider>(context, listen: true);

    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        btnNotifier.value = state is UserProcessing && state.isLoginIN;
        if (state is userLoaded) {
        } else if (state is UserError) {
          print(state.message);
          context.showErrorSnackBar(state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            actions: const [SvgRenderWidget(svgPath: SvgPath.star), Gap(20)],
          ),
          body: SingleChildScrollView(
            // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: emailForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Gap(60),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Center(
                            child: SvgRenderWidget(
                              svgPath: "assets/svgs/loading1.svg",
                              width: 100,
                              height: 100,
                            ),
                          ),
                          const Gap(40),
                          Center(
                            child: Text(
                              'Say hello to effortless \nmeals, everyday.',
                              textAlign: TextAlign.center,
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          const Gap(60),
                          AppInputField(
                            title: "Email Address",
                            child: TextFormField(
                              controller: emailController,
                              validator: validateEmail,
                              decoration: InputDecoration(
                                hintText: l10n.hintEmail,
                              ),
                            ),
                          ),
                          const Gap(60),
                          AppElevatedButton(
                            notifier: btnNotifier,
                            onPressed: continueWithEmail,
                            child: const Text("Continue with Email"),
                          ),
                          const Gap(20),
                          // if (Platform.isAndroid) ...[
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: context.colors.greyDecor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: AppElevatedButton(
                                  notifier: googleBtnNotifier,
                                  color: context.primaryColor,
                                  onPressed: () async {
                                    googleBtnNotifier.value = true;
                                    try {
                                      _googleSignIn.signIn().then((result) {
                                        result!.authentication
                                            .then((googleKey) async {
                                          context
                                              .read<UserBloc>()
                                              .add(GoogleSignInEvent(
                                                id: googleKey.idToken!,
                                              ));

                                          googleBtnNotifier.value = false;

                                          context
                                              .replaceNamed(Routes.welcomonb);
                                        }).catchError((err) {
                                          googleBtnNotifier.value = false;
                                          print('inner error: $err');
                                          print(
                                              'Google Sign-In failed or was cancelled');
                                          googleBtnNotifier.value = false;
                                        });
                                      }).catchError((err) {
                                        googleBtnNotifier.value = false;
                                        print('error occured');
                                        print(
                                            'Error during Google Sign-In: $err');
                                      });
                                      print('signed in .....');
                                    } catch (error) {
                                      print(error);
                                    }
                                  },
                                  style: const ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll<Color>(
                                            Colors.white),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ImageRenderWidget.asset(
                                        imagePath:
                                            "assets/images/icons/google.png",
                                        height: 30,
                                        width: 30,
                                      ),
                                      const Gap(3),
                                      Text("Continue with Google",
                                          style: context.textTheme.titleLarge),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(20),

                          if (Platform.isIOS)
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: context.colors.greyDecor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: AppElevatedButton(
                                notifier: appleBtnNotifier,
                                color: context.primaryColor,
                                onPressed: () async {
                                  try {
                                    appleBtnNotifier.value = true;
                                    final credential = await SignInWithApple
                                        .getAppleIDCredential(
                                      scopes: [
                                        AppleIDAuthorizationScopes.email,
                                        AppleIDAuthorizationScopes.fullName,
                                      ],
                                    );

                                    if (credential.identityToken != null) {
                                      context
                                          .read<UserBloc>()
                                          .add(AppleSignInEvent(
                                            id: credential.identityToken
                                                .toString(),
                                          ));

                                      context.replaceNamed(Routes.welcomonb);
                                    }
                                  } catch (error) {
                                    appleBtnNotifier.value = false;
                                    print(error);
                                  } finally {
                                    appleBtnNotifier.value = false;
                                  }
                                },
                                style: const ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll<Color>(
                                          Colors.white),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ImageRenderWidget.asset(
                                      imagePath:
                                          "assets/images/icons/apple.png",
                                      height: 30,
                                      width: 30,
                                    ),
                                    const Gap(3),
                                    Text("Continue with Apple",
                                        style: context.textTheme.titleLarge),
                                  ],
                                ),
                              ),
                            ),

                          const Gap(40),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static String iosClientId =
      "792947408004-oe4se0fts40vf3l4hp17m6fkod2tk064.apps.googleusercontent.com";

  final GoogleSignIn _googleSignIn = Platform.isIOS
      ? GoogleSignIn(
          clientId: iosClientId,
          scopes: [
            'email',
          ],
        )
      : GoogleSignIn(
          scopes: <String>[
            'profile',
            'email',
            'https://www.googleapis.com/auth/contacts.readonly',
          ],
        );

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
      if ((error.toString()) == "Incorrect email or password.") {
        context.replaceNamed(
          Routes.signUp,
          extra: emailController.text,
        );
      } else {
        context.showErrorSnackBar(error);
      }
      print(error);
    } finally {
      btnNotifier.value = false;
    }
  }
}
