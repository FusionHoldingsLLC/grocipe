// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_back_button.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/blocs/user_bloc/user_bloc.dart';
import 'package:grocipe/helper/settings/palette.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:pinput/pinput.dart';

class verifyTokenScreen extends StatefulWidget {
  const verifyTokenScreen({super.key, required this.email});
  final String email;
  @override
  State<verifyTokenScreen> createState() => _verifyTokenScreenState();
}

class _verifyTokenScreenState extends State<verifyTokenScreen> {
  bool loading = false;
  bool enable = false;
  FocusNode focusNode = FocusNode();
  TextEditingController codeController = TextEditingController();

  final btnNotifier = ValueNotifier(false);

  final pinLength = 6;

  static const boxHeight = 48.0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        btnNotifier.value = state is UserProcessing && state.isVeerifyingToken;

        if (state is userLoaded) {
          // context.showSuccessSnackBar(state.message);
          context.go(
            '/auth/forgot/verify/${widget.email}/set_password',
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
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Verification",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                        ),
                      ),
                      const Gap(10),
                      Text(
                        "Enter your email for the verification process, we will send 6 digits code to your email.",
                        style: TextStyle(
                          color: Palette.grey,
                          fontSize: 16,
                        ),
                      ),
                      const Gap(20),
                      Center(
                        child: Pinput(
                          length: pinLength,
                          separatorBuilder: (_) => const SizedBox(width: 10),
                          controller: codeController,
                          defaultPinTheme: PinTheme(
                            textStyle: context.textTheme.displayMedium,
                            height: boxHeight,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: context.colors.greyOutline),
                              color: Colors.grey[200],
                            ),
                          ),
                          focusedPinTheme: whitePinTheme,
                          submittedPinTheme: whitePinTheme,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: Opacity(
                          opacity: 0,
                          child: TextField(
                            focusNode: focusNode,
                            controller: codeController,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            onChanged: (valu) {
                              if (valu.length == 6) {
                                setState(() {
                                  enable = true;
                                });
                              } else {
                                setState(() {
                                  enable = false;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const Gap(20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomSheet: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 150,
            child: Center(
              child: AppElevatedButton(
                notifier: btnNotifier,
                onPressed: verifyOtp,
                style: context.elevatedButtonTheme.style?.copyWith(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      codeController.length == pinLength
                          ? context.primaryColor
                          : context.colors.captionGrey),
                ),
                child: const Text("Verify"),
              ),
            ),
          ),
        );
      },
    );
  }

  Future verifyOtp() async {
    if (codeController.length < pinLength) {
      context.showErrorSnackBar("Enter valid otp");
      return;
    }

    context.read<UserBloc>().add(
          VerifyResetPassword(
            email: widget.email,
            token: codeController.text,
          ),
        );
  }

  PinTheme get whitePinTheme => PinTheme(
        height: boxHeight,
        width: 180,
        textStyle: context.textTheme.displayMedium,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: context.primaryColor),
          color: context.colors.white,
        ),
      );
}
