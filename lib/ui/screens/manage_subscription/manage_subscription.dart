// ignore_for_file: avoid_print
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_back_button.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/app/app_widgets/svg_render_widget.dart';
import 'package:grocipe/blocs/user_bloc/user_bloc.dart';
import 'package:grocipe/helper/constants/image_paths.dart';
import 'package:grocipe/helper/size_config/size_config.dart';
import 'package:grocipe/helper/third_party/stripe.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/helper/utils/ui_helper.dart';
import 'package:grocipe/models/user.dart';
import 'package:grocipe/navigation/route_names.dart';
import 'package:grocipe/services/auth_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ManageSubscription extends ConsumerStatefulWidget {
  const ManageSubscription({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManageSubscriptionState();
}

class _ManageSubscriptionState extends ConsumerState<ManageSubscription> {
  int _currentIndex = 0;
  final PageController pageController = PageController();
  final ScrollController scrollController = ScrollController();

  final cancleTextController = TextEditingController();
  final List<String> regularFeatures = [
    'Smart meal planning',
    'AI recipe search and suggestions',
    'Recipe Nutritional information',
    'Generate recipe from any url',
    'Automatic grocery generation from recipe',
    'Share meal plan',
    'Share recipe',
    'Share grocery list',
  ];

  final List<String> premiumFeatures = [
    'Smart meal planning',
    'AI recipe search and suggestions',
    'Recipe Nutritional information',
    'Generate recipe from any url',
    'Automatic grocery generation from recipe',
    'Share meal plan',
    'Share recipe',
    'Share grocery list',
  ];
  String? plan = "Grocipe_1PudB9RsPs6WvkcRi080KMDa";

  void _onPlanSelected(int index) {
    setState(() {
      _currentIndex = index;
      plan = _currentIndex == 0
          ? "Grocipe_1PudB9RsPs6WvkcRi080KMDa"
          : "Grocipe_1PudB9RsPs6WvkcR49LGOE6Q";
    });

    scrollController.animateTo(
      index == 0
          ? scrollController.position.minScrollExtent
          : scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  String subscriptionType = '';
  String? userID;

  @override
  void initState() {
    super.initState();
    _loadDataOnInit();
  }

  List<String> planListings = [
    "Generate meal plans based on your preferences ",
    "Ad-Supported: Free with ads.",
    "Browse basic recipes, create collections, and access cooking tips",
    "Supports AI Features.",
  ];

  Future<void> _loadDataOnInit() async {
    try {
      StripePaymentHandle paymentHandle = StripePaymentHandle(context: context);
      String result = await paymentHandle.checkSubscriptionType();
      setState(() {
        subscriptionType = result;
      });
    } catch (e) {
      print("Error loading subscription type: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final btnNotifier = ValueNotifier(false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage subscription',
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: const AppBackButton(),
      ),
      body: subscriptionType.isEmpty
          ? const Center(child: CupertinoActivityIndicator(color: Colors.grey))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SafeArea(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current plan",
                        style: context.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: context.colors.black),
                      ),
                      const Gap(10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: context.primaryColor.withOpacity(.15),
                          border: Border.all(
                            color: context.primaryColor,
                            width: 2,
                          ),
                        ),
                        height: 108,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgRenderWidget(
                                  svgPath: 'assets/svgs/plan.svg',
                                  width: 24,
                                  height: 24,
                                ),
                              ],
                            ),
                            const Gap(1),
                            SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        subscriptionType,
                                        style: context.textTheme.displayLarge
                                            ?.copyWith(
                                                color: context.colors.black),
                                      ),
                                      Text(
                                        subscriptionType != "Free"
                                            ? "Recommended"
                                            : "Upgrade Plan",
                                        style: context.textTheme.titleMedium!
                                            .copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: context.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "\$0.00",
                                        style: context.textTheme.displayLarge
                                            ?.copyWith(
                                                color: context.colors.black),
                                      ),
                                      const Gap(2),
                                      Text(
                                        subscriptionType != "Free"
                                            ? subscriptionType == "Premium"
                                                ? "Per Month"
                                                : "Six Months"
                                            : "Per Month",
                                        style: context.textTheme.titleMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: context.colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(30),
                      Text(
                        "Includes:",
                        style: context.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: context.colors.black),
                      ),
                      const Gap(10),
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          itemCount: planListings.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: index == planListings.length - 1 ||
                                          index == 1
                                      ? Image.asset(
                                          subscriptionType == "Free"
                                              ? ImagePath.subscriptionCancle
                                              : ImagePath.subscriptionGood,
                                        )
                                      : Image.asset(
                                          ImagePath.subscriptionGood,
                                        )),
                              minLeadingWidth: 10,
                              minTileHeight: 50,
                              title: Text(
                                planListings[index],
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            );
                          },
                        ),
                      ),
                      if (subscriptionType == "Free")
                        AppElevatedButton(
                          onPressed: () async {
                            showUpgradeBottomSheet(context);
                          },
                          notifier: btnNotifier,
                          color: context.primaryColor,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.primaryColor,
                            side: BorderSide(
                                color: context.primaryColor, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Upgrade subscription",
                            style: context.textTheme.titleLarge!
                                .copyWith(color: context.colors.white),
                          ),
                        ),
                      const Gap(30),
                      if (subscriptionType != "Free") ...[
                        AppElevatedButton(
                          onPressed: () async {
                            showDowngradeBottomSheet(context);
                          },
                          notifier: btnNotifier,
                          color: context.primaryColor,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                context.primaryColor.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Downgrade for free",
                            style: context.textTheme.titleLarge!.copyWith(
                                decoration: TextDecoration.underline,
                                color: context.primaryColor,
                                decorationColor: context.primaryColor),
                          ),
                        ),
                        const Gap(30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showCancleBottomSheet(context);
                              },
                              child: Text("Cancel subscription",
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.titleLarge!.copyWith(
                                      color: context.errorColor,
                                      decorationColor: context.errorColor,
                                      decoration: TextDecoration.underline)),
                            ),
                          ],
                        ),
                      ],
                    ]),
              ),
            ),
    );
  }

  void showDowngradeBottomSheet(BuildContext context) {
    final upgradeBtnNotifier = ValueNotifier(false);
    final downgradeBtnNotifier = ValueNotifier(false);
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
              height: MediaQuery.of(context).size.height * 0.8,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Downgrade to Free Plan",
                      style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: context.colors.black),
                    ),
                    PlanItem(
                      isChecked: true,
                      features: premiumFeatures,
                      product: "",
                      isPremium: false,
                      isAnnually: false,
                      ontap: () {},
                    ),
                    const Gap(5),
                    Text(
                        "You will lose access to premium features, and your plan will include ads.",
                        style: context.textTheme.bodyMedium),
                    const Gap(15),
                    Text(
                      "Are you sure you want to downgrade?",
                      style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: context.colors.black),
                    ),
                    const Gap(20),
                    AppElevatedButton(
                      onPressed: () async {
                        upgradeBtnNotifier.value = true;
                        Navigator.pop(context);
                      },
                      notifier: upgradeBtnNotifier,
                      color: context.primaryColor,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.primaryColor,
                        side: BorderSide(color: context.primaryColor, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "No, keep current plan",
                        style: context.textTheme.titleLarge!
                            .copyWith(color: context.colors.white),
                      ),
                    ),
                    const Gap(20),
                    AppElevatedButton(
                      onPressed: () async {
                        downgradeBtnNotifier.value = true;
                      },
                      notifier: downgradeBtnNotifier,
                      color: context.primaryColor,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.primaryColor.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "Downgrade for free",
                        style: context.textTheme.titleLarge!.copyWith(
                            decoration: TextDecoration.underline,
                            color: context.primaryColor,
                            decorationColor: context.primaryColor),
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

  void showUpgradeBottomSheet(BuildContext context) {
    final upgradePremiumBtnNotifier = ValueNotifier(false);
    final downgradePremiumBtnNotifier = ValueNotifier(false);

    Timer? _timer;
    int _start = 120;
    bool setTimer = false;

    void startTimer(void Function(void Function()) setState) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (_start == 0) {
          timer.cancel();
          bool isRefreshed = await ref.read(authService).refreshToken();
          if (!isRefreshed) {
            context.showErrorSnackBar("Token refresh failed.");
          } else {
            context.showSuccessSnackBar("Subscription successfully activated");
          }

          Navigator.of(context).pop();
          setTimer = false;
          setState(() {
            _start = 120;
          });
        } else {
          setState(() {
            setTimer = true;
            _start--;
          });
        }
      });
    }

    void _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    showModalBottomSheet(
        context: context,
        backgroundColor: context.colors.white,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.85,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    children: [
                      Text(
                        "Upgrade to Premium",
                        style: context.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: context.colors.black),
                      ),
                      const Gap(15),
                      Container(
                        height: 48,
                        width: screenWidth(context, 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: context.colors.white),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: screenWidth(context, 4),
                              child: TabBarButton(
                                text: "Monthly",
                                onTap: () {
                                  setState(() {
                                    _onPlanSelected(0);
                                    _currentIndex = 0;
                                  });
                                },
                                iscurrent: _currentIndex == 0,
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 100,
                              child: TabBarButton(
                                text: "Semi-Anually",
                                onTap: () {
                                  setState(() {
                                    _onPlanSelected(1);
                                    _currentIndex = 1;
                                  });
                                },
                                iscurrent: _currentIndex == 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 340,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 40,
                                child: PlanItem(
                                  isChecked: _currentIndex == 0,
                                  features: premiumFeatures,
                                  product: "Grocipe_1PudB9RsPs6WvkcRi080KMDa",
                                  isPremium: true,
                                  isAnnually: false,
                                  ontap: () {
                                    setState(() {
                                      _currentIndex = 0;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 40,
                                child: PlanItem(
                                  isChecked: _currentIndex == 1,
                                  features: premiumFeatures,
                                  product: "Grocipe_1PudB9RsPs6WvkcR49LGOE6Q",
                                  isPremium: true,
                                  isAnnually: true,
                                  ontap: () {
                                    setState(() {
                                      _currentIndex = 1;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(10),
                      AppElevatedButton(
                        onPressed: () async {
                          print(setTimer);

                          if (plan != null) {
                            upgradePremiumBtnNotifier.value;

                            User user = context.read<UserBloc>().state.user!;
                            String? userID = await getUserID(user.accessToken);
                            try {
                              print(userID);
                              if (setTimer == false) {
                                if (userID != null || userID!.isNotEmpty) {
                                  print(user.accessToken);
                                  print(user.email);

                                  Purchases.setAttributes(
                                      {"id": userID.toString()});
                                  Purchases.setEmail(user.email);

                                  Offerings? offerings =
                                      await Purchases.getOfferings();

                                  if (offerings == null ||
                                      offerings.current == null) {
                                    print(
                                        "Offerings or current offering is null");
                                    return;
                                  }

                                  if (offerings
                                          .current!.availablePackages.length <
                                      2) {
                                    print("Not enough packages available");
                                    return;
                                  }

                                  if (plan.toString() ==
                                      "Grocipe_1PudB9RsPs6WvkcRi080KMDa") {
                                    await Purchases.purchasePackage(offerings
                                        .current!.availablePackages[0]);
                                    startTimer(setState);
                                    _showCountdownDialog();
                                  } else {
                                    await Purchases.purchasePackage(offerings
                                        .current!.availablePackages[1]);
                                    startTimer(setState);
                                    _showCountdownDialog();
                                  }
                                } else {
                                  context.showErrorSnackBar(
                                      "Error geting user ID");
                                }
                              }
                            } catch (e) {
                              context.showErrorSnackBar(e);
                              setState(() {
                                setTimer = false;
                              });
                            } finally {
                              context.replaceNamed(Routes.manageSubscription);
                              upgradePremiumBtnNotifier.value = false;
                            }
                          }
                        },
                        notifier: upgradePremiumBtnNotifier,
                        color: context.primaryColor,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.primaryColor,
                          side:
                              BorderSide(color: context.primaryColor, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          "Yes, upgrade to premium",
                          // : "$_start seconds remaining",
                          style: context.textTheme.titleLarge!
                              .copyWith(color: context.colors.white),
                        ),
                      ),
                      const Gap(20),
                      AppElevatedButton(
                        onPressed: () async {
                          if (setTimer == false) {
                            downgradePremiumBtnNotifier.value = true;
                            Navigator.pop(context);
                          }
                        },
                        notifier: downgradePremiumBtnNotifier,
                        color: context.primaryColor,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              context.primaryColor.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          "No, keep basic",
                          style: context.textTheme.titleLarge!.copyWith(
                              decoration: TextDecoration.underline,
                              color: context.primaryColor,
                              decorationColor: context.primaryColor),
                        ),
                      ),
                      const Gap(10),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                              color: Colors.black), // Default text style
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
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  void _showCountdownDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final cancleBTN = ValueNotifier(false);
        Timer(Duration(seconds: 10), () {
          Navigator.of(context).pop();
        });
        return AlertDialog(
          alignment: Alignment.center,
          title: SizedBox(
            height: 80,
            child: Column(
              children: [
                Text(
                  "Verifying Subscription Status",
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleLarge!.copyWith(
                    color: context.primaryColor,
                  ),
                ),
                const Text(""),
                Text(
                  "Please wait for a while we verify your subscription status. This may take a moment.",
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: context.colors.black,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
              child: AppElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                notifier: cancleBTN,
                color: context.primaryColor,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "I'll wait a moment",
                  style: context.textTheme.titleLarge!.copyWith(
                      decoration: TextDecoration.underline,
                      color: context.colors.white,
                      decorationColor: context.colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

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
              height: MediaQuery.of(context).size.height / 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cancel Subscription",
                      style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: context.colors.black),
                    ),
                    const Gap(20),
                    Text(
                        "You will lose access to premium features, and your plan will include ads.",
                        style: context.textTheme.bodyMedium),
                    const Gap(20),
                    AppInputField(
                      title: "Reasons for cancelling subscription*",
                      child: TextFormField(
                        controller: cancleTextController,
                        decoration: const InputDecoration(
                          hintText: "Enter reason here",
                        ),
                      ),
                    ),
                    const Gap(20),
                    Text(
                      "Are you sure you want to cancel?",
                      style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: context.colors.black),
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
                        "No, keep premium",
                        style: context.textTheme.titleLarge!
                            .copyWith(color: context.colors.white),
                      ),
                    ),
                    const Gap(20),
                    AppElevatedButton(
                      onPressed: () async {
                        noCancleBtnNotifier.value = true;
                      },
                      notifier: noCancleBtnNotifier,
                      color: context.primaryColor,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.primaryColor.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "Yes, cancel subscription",
                        style: context.textTheme.titleLarge!.copyWith(
                            decoration: TextDecoration.underline,
                            color: context.primaryColor,
                            decorationColor: context.primaryColor),
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
}

class PlanItem extends ConsumerStatefulWidget {
  const PlanItem({
    super.key,
    required this.isChecked,
    required this.isPremium,
    required this.isAnnually,
    required this.features,
    this.ontap,
    required this.product,
  });

  final bool isChecked;
  final bool isPremium;
  final bool isAnnually;
  final List<String> features;
  final VoidCallback? ontap;
  final String product;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlanItemState();
}

class _PlanItemState extends ConsumerState<PlanItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.ontap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(20),
        width: SizeConfig.screenWidth,
        height: 290,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: widget.isChecked
              ? context.primaryColor.withOpacity(.2)
              : context.colors.white,
          border: Border.all(
            color: widget.isChecked
                ? context.primaryColor
                : context.colors.greyOutline,
            width: 3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Image.asset(
                    ImagePath.fire,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!widget.isPremium) ...[
                        Text(
                          "Free",
                          style: context.textTheme.displayLarge
                              ?.copyWith(color: context.colors.black),
                        ),
                        Text(
                          "Regular Plan",
                          style: context.textTheme.titleMedium!.copyWith(
                              color: context.primaryColor,
                              fontWeight: FontWeight.w600,
                              decorationColor: context.primaryColor),
                        ),
                      ],
                      if (widget.isPremium && !widget.isAnnually) ...[
                        Text(
                          "Monthly",
                          style: context.textTheme.displayLarge
                              ?.copyWith(color: context.colors.black),
                        ),
                        Text(
                          "Most popular",
                          style: context.textTheme.titleMedium!.copyWith(
                              color: context.primaryColor,
                              fontWeight: FontWeight.w600,
                              decorationColor: context.primaryColor),
                        ),
                      ],
                      if (widget.isPremium && widget.isAnnually) ...[
                        Text(
                          "Semi-Annually",
                          style: context.textTheme.displayLarge
                              ?.copyWith(color: context.colors.black),
                        ),
                        Text(
                          "Recommended",
                          style: context.textTheme.titleMedium!.copyWith(
                              color: context.primaryColor,
                              fontWeight: FontWeight.w600,
                              decorationColor: context.primaryColor),
                        ),
                      ],
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!widget.isPremium && !widget.isAnnually) ...[
                        Text(
                          "\$0.00",
                          style: context.textTheme.displayLarge
                              ?.copyWith(color: context.colors.black),
                        ),
                        Text(
                          "Per Month",
                          style: context.textTheme.titleMedium,
                        ),
                      ],
                      if (widget.isPremium && !widget.isAnnually) ...[
                        Text(
                          "\$4.99",
                          style: context.textTheme.displayLarge
                              ?.copyWith(color: context.colors.black),
                        ),
                        Text(
                          "Per Month",
                          style: context.textTheme.titleMedium,
                        ),
                      ],
                      if (widget.isPremium && widget.isAnnually) ...[
                        Text(
                          "\$29.99",
                          style: context.textTheme.displayLarge
                              ?.copyWith(color: context.colors.black),
                        ),
                        Text(
                          "6 Months",
                          style: context.textTheme.titleMedium,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const Gap(10),
            SizedBox(
              height: 160,
              child: ListView.builder(
                itemCount: widget.features.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    minLeadingWidth: 40,
                    leading: SizedBox(
                        height: 24,
                        width: 24,
                        child: !widget.isPremium && !widget.isAnnually
                            ? index == widget.features.length - 1 || index == 1
                                ? Image.asset(ImagePath.subscriptionCancle)
                                : Image.asset(
                                    ImagePath.subscriptionGood,
                                  )
                            : Image.asset(
                                ImagePath.subscriptionGood,
                              )),
                    minTileHeight: 40,
                    horizontalTitleGap: 0,
                    title: Text(widget.features[index],
                        style: context.textTheme.bodyMedium),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabBarButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool iscurrent;

  const TabBarButton({
    Key? key,
    required this.text,
    required this.onTap,
    required this.iscurrent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: iscurrent ? context.colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: context.textTheme.titleSmall?.copyWith(
            color: iscurrent ? Colors.white : context.primaryColor,
          ),
        ),
      ),
    );
  }
}
