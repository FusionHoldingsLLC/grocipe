// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/app_back_button.dart';
import 'package:grocipe/app/app_widgets/app_elevated_button.dart';
import 'package:grocipe/app/app_widgets/app_input_field.dart';
import 'package:grocipe/helper/size_config/size_config.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/navigation/route_names.dart';
import 'package:grocipe/ui/provider/onbording_provider.dart';
import 'package:grocipe/ui/screens/onboarding_detail_screen/widget/app_progress_indicator.dart';
import 'package:grocipe/ui/screens/onboarding_detail_screen/widget/rounded_wrap_items.dart';

class WelcomeOnbScreen extends ConsumerStatefulWidget {
  const WelcomeOnbScreen({super.key});

  @override
  ConsumerState<WelcomeOnbScreen> createState() => _WelcomeOnbScreenState();
}

class _WelcomeOnbScreenState extends ConsumerState<WelcomeOnbScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final btnNotifier = ValueNotifier(false);

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_isOptionSelected()) {
      if (_currentPage < 4) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      } else {
        final onboardingData = ref.read(onboardingProvider).toJson();
        print(onboardingData);
      }
    } else {
      _showSelectionAlert();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.pop(context);
    }
  }

  bool _isOptionSelected() {
    final onboardingState = ref.read(onboardingProvider);
    switch (_currentPage) {
      case 0:
        return onboardingState.cookingFrequency.isNotEmpty &&
            onboardingState.cookingFrequency != "Other";
      case 1:
        return onboardingState.cookingFor.isNotEmpty &&
            onboardingState.cookingFor != "Other";
      case 2:
        return onboardingState.recipeSource.isNotEmpty &&
            onboardingState.recipeSource != "Other";
      case 3:
        return true;
      // return onboardingState.features.isNotEmpty;
      case 4:
        return onboardingState.heardFrom.isNotEmpty &&
            onboardingState.heardFrom != "Other";
      // return true;
      case 5:
        return true;
      default:
        return false;
    }
  }

  void _showSelectionAlert() {
    context.showMessage("Please select at least one option to continue.");
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(onboardingProvider.notifier);
    final onboardingState = ref.watch(onboardingProvider);
    btnNotifier.value = notifier.isLoading;

    return Scaffold(
      appBar: AppBar(
        leading: _currentPage > 0
            ? AppBackButton(
                onTap: () {
                  if (_currentPage > 0) {
                    _previousPage();
                  } else {
                    // Navigator.pop(context);
                  }
                },
              )
            : const SizedBox.shrink(),
        actions: [
          _currentPage == 5
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.cancel_outlined,
                        color: context.colors.black),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (_) {},
        child: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildPage(
              context,
              "How often \ndo you cook per week?",
              "",
              RoundedWrapItems(
                options: const [
                  "Not at all",
                  "Occasionally",
                  "Frequently",
                  "Every meal",
                  "Other"
                ],
                allowMultiple: false,
                onSelected: (selectedOptions) {
                  if (selectedOptions.isNotEmpty) {
                    ref
                        .read(onboardingProvider.notifier)
                        .updateCookingFrequency(selectedOptions.first);
                  }
                },
              ),
              extraField: (onboardingState.cookingFrequency) == "Other"
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        AppInputField(
                          title: "",
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Please Specify",
                            ),
                            onFieldSubmitted: (value) {
                              ref
                                  .read(onboardingProvider.notifier)
                                  .updateCookingFrequency(value);
                              _nextPage();
                            },
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
            _buildPage(
              context,
              "How many \npeople do you cook for?",
              "",
              RoundedWrapItems(
                options: const [
                  "Just me",
                  "Me and a partner",
                  "Family of 3+",
                  "Other",
                ],
                allowMultiple: false,
                onSelected: (selectedOptions) {
                  if (selectedOptions.isNotEmpty) {
                    ref
                        .read(onboardingProvider.notifier)
                        .updateCookingFor(selectedOptions.first);
                  }
                },
              ),
              extraField: (onboardingState.cookingFor) == "Other"
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        AppInputField(
                          title: "",
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Please Specify",
                            ),
                            onFieldSubmitted: (value) {
                              ref
                                  .read(onboardingProvider.notifier)
                                  .updateCookingFor(value);
                              _nextPage();
                            },
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
            _buildPage(
              context,
              "Where do \nyou currently find recipes?",
              "",
              RoundedWrapItems(
                options: const [
                  "Pinterest",
                  "Facebook",
                  "Google",
                  "Recipe books",
                  "Other"
                ],
                allowMultiple: false,
                onSelected: (selectedOptions) {
                  if (selectedOptions.isNotEmpty) {
                    ref
                        .read(onboardingProvider.notifier)
                        .updateRecipeSource(selectedOptions.first);
                  }
                },
              ),
              extraField: (onboardingState.recipeSource) == "Other"
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        AppInputField(
                          title: "",
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Please Specify",
                            ),
                            onFieldSubmitted: (value) {
                              ref
                                  .read(onboardingProvider.notifier)
                                  .updateRecipeSource(value);
                              _nextPage();
                            },
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
            _buildPage(
              context,
              "How did you hear about us?",
              "",
              RoundedWrapItems(
                options: const [
                  "Google",
                  "LinkedIn",
                  "Youtube",
                  "Instagram",
                  "Facebook",
                  "Reddit",
                  "TikTok",
                  "X",
                  "Word of mouth",
                  "Other"
                ],
                allowMultiple: false,
                onSelected: (selectedOptions) {
                  if (selectedOptions.isNotEmpty) {
                    ref
                        .read(onboardingProvider.notifier)
                        .updateHeardFrom(selectedOptions.first);
                  }
                },
              ),
              extraField: (onboardingState.heardFrom) == "Other"
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        AppInputField(
                          title: "",
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Please Specify",
                            ),
                            onFieldSubmitted: (value) {
                              ref
                                  .read(onboardingProvider.notifier)
                                  .updateHeardFrom(value);
                              _nextPage();
                            },
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
            _buildPageRow(
              context,
              "How we make cooking easier for you?",
              "",
              [
                "Recipes saved in one place",
                "Suggested healthy ingredient swaps",
                "Created for you grocery list",
                "Suggested weekly meal plans",
              ],
            ),
            // OnboardingPlanScreen(
            //   onContinue: () {},
            //   onSubscribe: () {},
            // ),
          ],
        ),
      ),
      bottomNavigationBar: _currentPage < 4
          ? SizedBox(
              height: 120,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.widthOf(5), vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppElevatedButton(
                        notifier: btnNotifier,
                        onPressed: _nextPage,
                        child: const Text("Continue"),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : SizedBox(
              height: 120,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.widthOf(5), vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppElevatedButton(
                        notifier: btnNotifier,
                        onPressed: () async {
                          if (_isOptionSelected()) {
                            await notifier.submitSurvey();
                            context.replaceNamed(Routes.loading);
                          } else {
                            _showSelectionAlert();
                          }
                        },
                        child: const Text("Finish"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildPageRow(BuildContext context, String title, String subtitle,
      List<String> optionsList) {
    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.widthOf(5), vertical: 15),
      child: ListView(
        children: [
          const SizedBox(height: 16),
          AppProgressIndicator(length: 5, completed: _currentPage + 1),
          const SizedBox(height: 25),
          Text(
            title,
            style: context.textTheme.displayLarge
                ?.copyWith(fontWeight: FontWeight.bold, fontSize: 35),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: context.textTheme.titleMedium,
          ),
          const SizedBox(height: 30),
          RoundedWrapItems(
            options: optionsList,
            showIcon: true,
            allowMultiple: true, // Enable multiple selections
            onSelected: (selectedOptions) {
              onboardingNotifier.updateExpectations(selectedOptions);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPage(
      BuildContext context, String title, String subtitle, Widget options,
      {Widget? extraField}) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.widthOf(5), vertical: 15),
      child: ListView(
        children: [
          const SizedBox(height: 16),
          AppProgressIndicator(length: 5, completed: _currentPage + 1),
          const SizedBox(height: 25),
          Text(
            title,
            style: context.textTheme.displayLarge
                ?.copyWith(fontWeight: FontWeight.bold, fontSize: 35),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: context.textTheme.titleMedium,
          ),
          const SizedBox(height: 30),
          options,
          if (extraField != null) ...[
            const SizedBox(height: 20),
            extraField,
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class CustomRow extends StatelessWidget {
  final String text;

  const CustomRow({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.check_circle, color: context.primaryColor, size: 24),
        const SizedBox(width: 15),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.primaryColor.withOpacity(.1),
              border: Border.all(color: context.primaryColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Expanded(
              child: Text(
                text,
                style: context.textTheme.titleMedium
                    ?.copyWith(color: context.primaryColor, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
