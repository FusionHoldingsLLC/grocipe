import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_back_button.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/svg_render_widget.dart';
import 'package:grocipe/blocs/user_bloc/user_bloc.dart';
import 'package:grocipe/helper/third_party/hive.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/navigation/route_names.dart';
import 'package:grocipe/ui/provider/auth_provider.dart';
import 'package:pinput/pinput.dart';

import 'package:provider/provider.dart' as provider;

class VerifyEmail extends ConsumerStatefulWidget {
  const VerifyEmail({super.key});

  @override
  ConsumerState<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends ConsumerState<VerifyEmail> {
  // bool loading = false;
  // bool enable = false;
  FocusNode focusNode = FocusNode();
  TextEditingController codeController = TextEditingController();

  final btnNotifier = ValueNotifier(false);

  final pinLength = 6;

  static const boxHeight = 48.0;

  bool verified = false;

  @override
  Widget build(BuildContext context) {
    var authProvider =
        provider.Provider.of<AuthenticationProvider>(context, listen: true);
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) async {
        btnNotifier.value =
            state is UserProcessing && (state.isVeerifying || state.isLoginIN);

        if (state is userLoaded) {
          // context.showSuccessSnackBar(state.message);
          // await onboardingNotifier.submitSurvey();

          if (!verified) {
            userFreeLogin();
          } else {
            final user = HiveFunction.getUser();

            if (user.firstName.isNotEmpty) {
              context.replaceNamed(Routes.mainScreen);
            } else {
              context.replaceNamed(Routes.nameScreen);
            }
          }

          verified = true;

          // context.replaceNamed(Routes.authState);
        } else if (state is UserError) {
          context.showErrorSnackBar(state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              leading: const AppBackButton(),
              // leadingWidth: 85,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Gap(20),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Verify email",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 33,
                                ),
                              ),
                            ],
                          ),
                          const Gap(20),
                          const SizedBox(
                            child: Text(
                              "To verify your email, we have sent a One Time Password(OTP) to ",
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const Gap(10),
                          SizedBox(
                            // width: MediaQuery.of(context).size.width * 0.55,
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: context.colors.greyDecor,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${authProvider.signUpdata['email']}",
                                        maxLines: 1,
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 3),
                                Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: context.colors.greyDecor,
                                    ),
                                    height: 40,
                                    width: 40,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgRenderWidget(
                                          svgPath: "assets/svgs/pen.svg",
                                          width: 25,
                                          height: 25,
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                          const Gap(25),
                          Center(
                            child: Pinput(
                              length: pinLength,
                              separatorBuilder: (_) =>
                                  const SizedBox(width: 10),
                              controller: codeController,
                              defaultPinTheme: PinTheme(
                                textStyle: context.textTheme.displayMedium,
                                height: boxHeight,
                                width: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: context.colors.greyOutline),
                                  color: Colors.grey[200],
                                ),
                              ),
                              focusedPinTheme: whitePinTheme,
                              submittedPinTheme: whitePinTheme,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Didn’t receive code? ',
                          style: context.textTheme.bodyMedium,
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Get a new one',
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(25),
                    AppElevatedButton(
                      notifier: btnNotifier,
                      onPressed: () {
                        verifyOtp(authProvider);
                      },
                      style: context.elevatedButtonTheme.style?.copyWith(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            context.primaryColor),
                      ),
                      child: const Text("Verify and continue"),
                    ),
                    const Gap(20),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [],
              ),
            ));
      },
    );
  }

  userFreeLogin() {
    var authProvider =
        provider.Provider.of<AuthenticationProvider>(context, listen: false);

    btnNotifier.value = true;

    context.read<UserBloc>().add(SigninEvent(
        email: authProvider.signUpdata["email"],
        password: authProvider.signUpdata["password"]));
  }

  Future verifyOtp(AuthenticationProvider authProvider) async {
    if (codeController.length < pinLength) {
      context.showErrorSnackBar("Enter valid otp");
      return;
    }

    context.read<UserBloc>().add(
          VerfiyEvent(
            email: authProvider.signUpdata['email'],
            token: codeController.text,
          ),
        );
  }

  PinTheme get whitePinTheme => PinTheme(
        height: boxHeight,
        width: 150,
        textStyle: context.textTheme.displayMedium,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: context.primaryColor),
          color: context.colors.white,
        ),
      );
}
