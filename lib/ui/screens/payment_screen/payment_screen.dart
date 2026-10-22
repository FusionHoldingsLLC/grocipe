// ignore_for_file: unused_field, unused_local_variable

import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/svg_render_widget.dart';
import 'package:grocipe/blocs/user_bloc/user_bloc.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/size_config/size_config.dart';
import 'package:grocipe/helper/third_party/stripe.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/models/user.dart';
import 'package:grocipe/navigation/route_names.dart';
import 'package:grocipe/services/auth_service.dart';
import 'package:grocipe/ui/screens/onboarding_detail_screen/widget/onboarding_plan.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _currentIndex = 0;
  final pageController = PageController();
  List<String> features = [
    'Smart meal planning',
    'AI recipe search and suggestions',
    'Recipe Nutritional information',
    'Generate recipe from any url',
    'Automatic grocery generation from recipe',
    'Share meal plan',
    'Share recipe',
    'Share grocery list',
  ];

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Material(
      child: SafeArea(
        minimum: const EdgeInsets.only(top: 30),
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Plans"),
            actions: [
              IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: Icon(
                  Icons.cancel,
                  color: context.primaryColor,
                ),
              ),
              const Gap(20),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Plans",
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.primaryColor,
                  ),
                ),
                const Gap(20),
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: TabBarButton(
                          text: "Montly",
                          onTap: () {
                            pageController.animateToPage(
                              0,
                              duration: const Duration(
                                milliseconds: 500,
                              ),
                              curve: Curves.linear,
                            );
                          },
                          iscurrent: _currentIndex == 0,
                        ),
                      ),
                      const Gap(10),
                      SizedBox(
                        width: 100,
                        child: TabBarButton(
                          text: "Semi-Annually",
                          onTap: () {
                            pageController.animateToPage(
                              1,
                              duration: const Duration(
                                milliseconds: 500,
                              ),
                              curve: Curves.linear,
                            );
                          },
                          iscurrent: _currentIndex == 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: pageController,
                    onPageChanged: (value) {
                      setState(() {
                        _currentIndex = value;
                      });
                    },
                    children: [
                      PlanItem(
                        currentIndex: _currentIndex,
                        features: features,
                        isChecked: _currentIndex == 0,
                        isAnnual: false,
                        option: PaymentOption.montly,
                      ),
                      PlanItem(
                        currentIndex: _currentIndex,
                        features: features,
                        isChecked: _currentIndex == 1,
                        isAnnual: true,
                        option: PaymentOption.annually,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black), // Default text style
                    children: [
                      TextSpan(
                        text: 'By subscribing, you agree to our ',
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: context.colors.black,
                        ),
                      ),
                      TextSpan(
                        text: 'Terms of Use',
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: context.primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _launchURL(
                                'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/');
                          },
                      ),
                      TextSpan(
                        text: ' and ',
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: context.colors.black,
                        ),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: context.primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _launchURL(
                                'https://www.grocipe.app/privacy-policy');
                          },
                      ),
                      TextSpan(
                        text:
                            '. Please review the following links for more information:',
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: context.colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlanItem extends ConsumerStatefulWidget {
  const PlanItem(
      {super.key,
      required int currentIndex,
      required this.isChecked,
      required this.features,
      required this.option,
      required this.isAnnual})
      : _currentIndex = currentIndex;

  final int _currentIndex;
  final List<String> features;
  final bool isChecked;
  final bool isAnnual;
  final PaymentOption option;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlanItemState();
}

class _PlanItemState extends ConsumerState<PlanItem> {
  final btnNotifier = ValueNotifier(false);
  User? user;
  @override
  void initState() {
    super.initState();

    User user = context.read<UserBloc>().state.user!;
    getUserID(user.accessToken);
  }

  String? userID;
  Future<String?> getUserID(dynamic token) async {
    var dio = Dio();
    try {
      Response response = await dio.get(
        'https://dev.grocipe.app/api/v1/auth/me/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      var data = response.data;

      if (data['id'] != null) {
        return data['id'].toString();
      } else {
        context.showErrorSnackBar('ID not found in the response.');
        return null;
      }
    } catch (e) {
      context.showErrorSnackBar('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      padding: const EdgeInsets.all(20),
      width: SizeConfig.screenWidth * .5,
      // height: SizeConfig.screenHeight * .,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: widget.isChecked
                ? context.primaryColor
                : context.colors.greyOutline,
            width: 3),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SvgRenderWidget(
                svgPath: 'assets/svgs/plan.svg',
                width: 24,
                height: 24,
              ),
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: widget.isChecked
                            ? context.primaryColor
                            : context.colors.greyOutline),
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(2),
                child: Checkbox(
                    value: widget.isChecked,
                    onChanged: (value) {},
                    shape: const CircleBorder(),
                    checkColor: widget.isChecked
                        ? context.primaryColor
                        : context.colors.greyOutline),
              )
            ],
          ),
          const Gap(10),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "monthly",
                      style: context.textTheme.displayLarge
                          ?.copyWith(color: context.colors.black),
                    ),
                    if (widget.isAnnual)
                      Text(
                        "Recommended",
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.primaryColor,
                        ),
                      ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${StripePaymentHandle.choosePrice(widget.option)}",
                      style: context.textTheme.displayLarge
                          ?.copyWith(color: context.colors.black),
                    ),
                    Text(
                      widget.isAnnual ? "Semi-Annually" : "Per Month",
                      style: context.textTheme.bodySmall?.copyWith(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(10),
          Expanded(
            child: ListView.builder(
              itemCount: widget.features.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 40,
                  leading: Icon(
                    Icons.check,
                    color: context.primaryColor,
                  ),
                  horizontalTitleGap: 0,
                  title: Text(widget.features[index]),
                );
              },
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Divider(
              color: context.primaryColor,
              thickness: 10,
            ),
          ),
          const Gap(10),
          AppElevatedButton(
            onPressed: () async {
              btnNotifier.value = true;

              User user = context.read<UserBloc>().state.user!;
              try {
                if (userID != null || userID!.isNotEmpty) {
                  Purchases.setAttributes({"id": userID.toString()});
                  Purchases.setEmail(user.email);

                  Offerings? offerings = await Purchases.getOfferings();

                  if (offerings == null || offerings.current == null) {
                    print("Offerings or current offering is null");
                    return;
                  }

                  if (offerings.current!.availablePackages.length < 2) {
                    print("Not enough packages available");
                    return;
                  }

                  if (widget.isAnnual == false) {
                    await Purchases.purchasePackage(
                        offerings.current!.availablePackages[0]);
                    context.replaceNamed(Routes.chat);
                  } else {
                    await Purchases.purchasePackage(
                        offerings.current!.availablePackages[1]);
                    context.replaceNamed(Routes.chat);
                  }
                } else {
                  context.showErrorSnackBar("Error geting user ID");
                }
              } catch (e) {
                print("Error setting attributes or purchasing product: $e");
              } finally {
                btnNotifier.value = false;
              }
            },
            notifier: btnNotifier,
            color: context.primaryColor,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(color: context.primaryColor, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Subscribe",
              style: context.textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }
}
