import 'dart:async';

import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/svg_render_widget.dart';
import 'package:grocipe/blocs/user_bloc/user_bloc.dart';
import 'package:grocipe/models/user.dart';
import 'package:grocipe/helper/size_config/size_config.dart';
import 'package:grocipe/helper/third_party/stripe.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/navigation/route_names.dart';
import 'package:grocipe/services/auth_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingPlanScreen extends ConsumerStatefulWidget {
  const OnboardingPlanScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingPlanScreenState();
}

class _OnboardingPlanScreenState extends ConsumerState<OnboardingPlanScreen> {
  int _currentIndex = 0;
  final PageController pageController = PageController();
  final ScrollController scrollController = ScrollController();
  final List<String> regularFeatures = [
    'Generate meal plans based on your preferences',
    'Ad-Supported: Free with ads.',
    'Browse basic recipes, create collections, and access cooking tips',
  ];

  final List<String> premiumFeatures = [
    'Generate meal plans based on your preferences',
    'Ad-Support: with No ads.',
    'Browse All recipes, create collections, and access cooking tips',
    'Supports AI Features',
  ];

  @override
  void initState() {
    super.initState();
    _loadDataOnInit();
  }

  String? subscriptionType;
  Future _loadDataOnInit() async {
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

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _onPlanSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
    scrollController.animateTo(
      index == 0
          ? scrollController.position.minScrollExtent
          : scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  bool? isLoading = false;
  @override
  Widget build(BuildContext context) {
    Future<void> refreshUserToken(BuildContext context, WidgetRef ref) async {
      try {
        final authRefresh = ref.read(authService);
        bool isRefreshed = await authRefresh.refreshToken();
        if (!isRefreshed) {
          context.showErrorSnackBar("Token refresh failed.");
        }
      } catch (error) {
        context.showErrorSnackBar(error.toString());
      }
    }

    StripePaymentHandle paymentHandle = StripePaymentHandle(context: context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: isLoading == false
                ? IconButton(
                    onPressed: () async {
                      print(subscriptionType);
                      if (subscriptionType != null ||
                          subscriptionType!.isNotEmpty) {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          await paymentHandle
                              .createFreeSubscription()
                              .then((result) {
                            if (result == true) {
                              context.replaceNamed(Routes.mainScreen);
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              print(result);
                            }
                          });
                        } catch (err) {
                          print(err);
                          setState(() {
                            isLoading = false;
                          });
                        }
                      } else {
                        context.replaceNamed(Routes.mainScreen);
                      }
                    },
                    icon: Icon(Icons.cancel_outlined,
                        color: context.colors.greyOutline))
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoActivityIndicator(
                      color: context.colors.greyOutline,
                    ),
                  ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Say hello to a world of endless recipes",
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: context.colors.greyDecor),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 100,
                      child: TabBarButton(
                        text: "Monthly",
                        onTap: () => _onPlanSelected(0),
                        iscurrent: _currentIndex == 0,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 110,
                      child: Center(
                        child: TabBarButton(
                          text: "Semi-Annually",
                          onTap: () => _onPlanSelected(1),
                          iscurrent: _currentIndex == 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      PlanItem(
                        isChecked: _currentIndex == 0,
                        features: premiumFeatures,
                        isPremium: true,
                        product: "Grocipe_1PudB9RsPs6WvkcRi080KMDa",
                        ontap: () => _onPlanSelected(0),
                      ),
                      const SizedBox(width: 10),
                      PlanItem(
                        isChecked: _currentIndex == 1,
                        features: premiumFeatures,
                        isPremium: false,
                        product: "Grocipe_1PudB9RsPs6WvkcR49LGOE6Q",
                        ontap: () => _onPlanSelected(1),
                      ),
                    ],
                  ),
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
                          _launchURL('https://www.grocipe.app/privacy-policy');
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
    );
  }
}

class PlanItem extends ConsumerStatefulWidget {
  const PlanItem({
    super.key,
    required this.isChecked,
    required this.isPremium,
    required this.features,
    this.ontap,
    required this.product,
  });

  final bool isChecked;
  final bool isPremium;
  final List<String> features;
  final VoidCallback? ontap;
  final String product;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlanItemState();
}

class _PlanItemState extends ConsumerState<PlanItem> {
  final btnNotifier = ValueNotifier(false);
  User? user;
  @override
  void initState() {
    super.initState();
    user = context.read<UserBloc>().state.user!;
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
      // Handle errors
      context.showErrorSnackBar('Error occurred: $e');
    }
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

  @override
  Widget build(BuildContext context) {
    Timer? _timer;
    int _start = 120;
    bool setTimer = false;
    StripePaymentHandle paymentHandle = StripePaymentHandle(context: context);

    void startTimer() {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (_start == 0) {
          timer.cancel();
          bool isRefreshed = await ref.read(authService).refreshToken();
          if (!isRefreshed) {
            context.showErrorSnackBar("Token refresh failed.");
          } else {
            context.replaceNamed(Routes.mainScreen);
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

    return InkWell(
      onTap: widget.ontap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(20),
        width: widget.isChecked
            ? SizeConfig.screenWidth * 0.8
            : SizeConfig.screenWidth * 0.7,
        height: widget.isChecked
            ? SizeConfig.screenHeight * 0.55
            : SizeConfig.screenHeight * 0.4,
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
                          : context.colors.greyOutline,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Checkbox(
                    value: widget.isChecked,
                    onChanged: (value) {},
                    shape: const CircleBorder(),
                    checkColor: widget.isChecked
                        ? context.primaryColor
                        : context.colors.greyOutline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
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
                        widget.isPremium
                            ? "Monthly Plan (1 Month)"
                            : "Semi-Anually (6 Months)",
                        style: widget.isChecked
                            ? context.textTheme.titleLarge
                                ?.copyWith(color: context.colors.black)
                            : context.textTheme.displaySmall?.copyWith(
                                color: context.colors.black, fontSize: 14),
                      ),
                      if (widget.isPremium)
                        Text(
                          "Recommended",
                          style: context.textTheme.titleMedium,
                        ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${widget.isPremium ? '4.99' : '24.99'}",
                        style: context.textTheme.displayLarge?.copyWith(
                          color: context.colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       widget.isPremium ? '15%  ' : '25%  ',
                      //       style: context.textTheme.displayLarge?.copyWith(
                      //           color: context.colors.black, fontSize: 16),
                      //     ),
                      //     Text(
                      //       "\$${widget.isPremium ? '4.99' : '29.94'}",
                      //       style: context.textTheme.displayMedium?.copyWith(
                      //         color: Colors.red,
                      //         fontWeight: FontWeight.w600,
                      //         decoration: TextDecoration.lineThrough,
                      //         decorationColor: Colors.red, // Color of the slash
                      //         decorationThickness: 2,
                      //         fontSize: 18,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
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
                thickness: 2,
              ),
            ),
            const SizedBox(height: 10),
            AppElevatedButton(
              onPressed: () async {
                btnNotifier.value = true;

                User user = context.read<UserBloc>().state.user!;

                try {
                  await paymentHandle.createFreeSubscription();
                  String? userID = await getUserID(user.accessToken);
                  print(setTimer);
                  startTimer();

                  if (userID != null || userID!.isNotEmpty) {
                    print(user.email);

                    Purchases.setAttributes({"id": user.accessToken});
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

                    if (widget.product == "Grocipe_1PudB9RsPs6WvkcRi080KMDa") {
                      await Purchases.purchasePackage(
                          offerings.current!.availablePackages[0]);

                      startTimer();
                      _showCountdownDialog();
                      context.replaceNamed(Routes.mainScreen);
                    } else {
                      await Purchases.purchasePackage(
                          offerings.current!.availablePackages[1]);
                      startTimer();
                      _showCountdownDialog();
                      bool isRefreshed =
                          await ref.read(authService).refreshToken();
                      if (!isRefreshed) {
                        context.showErrorSnackBar("Token refresh failed.");
                        await ref.read(authService).refreshToken();
                        context.replaceNamed(Routes.mainScreen);
                      } else {
                        context.showSuccessSnackBar(
                            "Subscription successfully activated");
                        context.replaceNamed(Routes.mainScreen);
                      }
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
          style: context.textTheme.titleMedium?.copyWith(
            color: iscurrent ? Colors.white : context.primaryColor,
          ),
        ),
      ),
    );
  }
}
