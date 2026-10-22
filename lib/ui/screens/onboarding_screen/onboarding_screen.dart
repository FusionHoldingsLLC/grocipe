// ignore_for_file: avoid_print, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/image_render_widget.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/settings/palette.dart';
import 'package:grocipe/helper/size_config/size_config.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/navigation/route_names.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController(initialPage: 0);
  bool lastpage = false;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: context.colors.black,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView(
                  onPageChanged: (value) {
                    print(value);
                    if (value == 2) {
                      setState(() {
                        lastpage = true;
                      });
                    } else {
                      setState(() {
                        lastpage = false;
                      });
                    }
                  },
                  controller: _pageController,
                  children: [
                    buildOnboardingPage(
                      context,
                      'assets/images/onboarding/ob1_girl.png',
                      "Smart Recipe Suggestions",
                      "Discover New Culinary Delights",
                      "Enter the ingredients you have, and let our AI"
                          " suggest a variety of delicious recipes. Never run out of meal ideas and always find something exciting to cook with what’s already in your kitchen.",
                    ),
                    buildOnboardingPage(
                      context,
                      'assets/images/onboarding/ob2_people.png',
                      "Meal Planning",
                      "Simplify Your Meal Planning",
                      l10n.onboardingBody2,
                    ),
                    // buildOnboardingPage(
                    //   context,
                    //   'assets/images/onboarding/girl.png',
                    //   l10n.onboardingTitle3,
                    //   l10n.onboardingBody3,
                    // ),
                    buildOnboardingPage(
                        context,
                        'assets/images/onboarding/ob3_shop.png',
                        "Shopping List",
                        "Streamline Your Grocery Shopping",
                        "Generate a shopping list based on your chosen recipes and meal plans. Ensure you never forget an ingredient and make your grocery trips more efficient and organized."),
                  ],
                ),
              ),
              if (lastpage) ...[
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 120,
                  color: Colors.black,
                  child: Center(
                    child: SizedBox(
                      width: SizeConfig.screenWidth * .9,
                      child: ElevatedButton(
                        // notifier: btnNotifier,
                        onPressed: () {
                          context.replaceNamed(Routes.auth);
                        },
                        style: context.elevatedButtonTheme.style?.copyWith(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              context.primaryColor),
                        ),
                        child: Text(
                          l10n.next,
                          style: context.textTheme.titleMedium
                              ?.copyWith(color: context.colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 120,
                  width: MediaQuery.sizeOf(context).width,
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: 3,
                        effect: WormEffect(
                          activeDotColor:
                              Theme.of(context).colorScheme.secondary,
                          dotColor: Palette.grey,
                          dotHeight: 5,
                          dotWidth: 28,
                          spacing: 10,
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          // notifier: btnNotifier,
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn,
                            );
                          },
                          style: context.elevatedButtonTheme.style?.copyWith(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                context.primaryColor),
                          ),
                          child: Text(l10n.next),
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            ],
          ),
          if (!lastpage)
            Positioned(
              top: 60,
              right: 40,
              child: GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    3,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: Text(l10n.skip,
                    style: context.textTheme.titleMedium
                        ?.copyWith(color: context.colors.white)),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildOnboardingPage(
    BuildContext context,
    String imagePath,
    String head,
    String title,
    String body,
  ) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  context.primaryColor.withOpacity(.1),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.3, 1],
              ),
            ),
            padding: const EdgeInsets.all(20),
            height: SizeConfig.heightOf(70),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: SizeConfig.heightOf(34),
                  child: ImageRenderWidget.asset(
                    imagePath: imagePath,
                    height: 400,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: Text(
                    head,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w300,
                      color: context.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width/1.5,
                  child: Text(
                    title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Palette.white,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                // SizedBox(
                //   width: MediaQuery.sizeOf(context).width,
                //   child: Padding(
                //     padding: const EdgeInsets.only(right: 40),
                //     child: Text(
                //       body,
                //       textAlign: TextAlign.left,
                //       style: TextStyle(
                //         fontSize: 14,
                //         height: 1.5,
                //         fontWeight: FontWeight.w400,
                //         color: Palette.white,
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
