import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/app_widgets/svg_render_widget.dart';
import 'package:grocipe/blocs/user_bloc/user_bloc.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/helper/settings/palette.dart';
import 'package:grocipe/helper/utils/context_extension.dart';
import 'package:grocipe/navigation/route_names.dart';
import 'package:grocipe/ui/screens/chat_screen/chat_screen.dart';
import 'package:grocipe/ui/screens/grocery_list/grocery_screen.dart';
import 'package:grocipe/ui/screens/home_screen/home_view.dart';
import 'package:grocipe/ui/screens/meal_screen/meal_screen.dart';
import 'package:grocipe/ui/provider/onbording_provider.dart';
import 'package:grocipe/ui/screens/payment_screen/payment_screen.dart';
import 'package:grocipe/ui/screens/profile_screen/profile_view.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _bottomNavIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const MealPlanScreen(),
    const ChatScreen(),
    const GroceryScreen(),
    const ProfileScreen(
      isFromBtNav: true,
    ),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(onboardingProvider.notifier).submitSurveyToApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              body: _screens[_bottomNavIndex],
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: BottomNavigationBar(
                elevation: 0,
                currentIndex: _bottomNavIndex,
                selectedItemColor: context.primaryColor,
                unselectedItemColor: context.colors.greenDecorDark,
                onTap: (value) {
                  if (value == 2) {
                    context.pushNamed(Routes.chat);
                    return;
                  }
                  setState(() {
                    _bottomNavIndex = value;
                  });
                },
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: SizedBox(
                      width: 26,
                      height: 26,
                      child: _bottomNavIndex == 0
                          ? const SvgRenderWidget(
                              svgPath: 'assets/svgs/nav_bar/home1.svg')
                          : const SvgRenderWidget(
                              svgPath: 'assets/svgs/nav_bar/home2.svg'),
                    ),
                    label: "Recipe",
                  ),
                  BottomNavigationBarItem(
                    icon: SizedBox(
                      width: 26,
                      height: 26,
                      child: _bottomNavIndex == 1
                          ? const SvgRenderWidget(
                              svgPath: 'assets/svgs/nav_bar/planner1.svg')
                          : const SvgRenderWidget(
                              svgPath: 'assets/svgs/nav_bar/planner2.svg'),
                    ),
                    label: l10n.planner,
                  ),
                  BottomNavigationBarItem(
                    icon: SizedBox(
                      width: 55,
                      height: 55,
                      child: FloatingActionButton(
                        heroTag: "set",
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: const CircleBorder(),
                        elevation: 0,
                        child: SvgRenderWidget(
                          svgPath: 'assets/svgs/nav_bar/chat1.svg',
                          color: Palette.white,
                        ),
                        onPressed: () {
                          debugPrint(state.user!.toJson().toString());
                          if (state.user?.subscriptionType != "Trial") {
                            context.pushNamed(Routes.chat);
                          } else {
                            showFlexibleBottomSheet(
                              bottomSheetColor: Colors.transparent,
                              initHeight: 1,
                              context: context,
                              builder: (context, scrollController,
                                  bottomSheetOffset) {
                                return const PaymentScreen();
                              },
                              anchors: [0, 0.5, 1],
                            );
                          }
                        },
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: SizedBox(
                      width: 26,
                      height: 26,
                      child: _bottomNavIndex == 3
                          ? const SvgRenderWidget(
                              svgPath: 'assets/svgs/nav_bar/grocery1.svg')
                          : const SvgRenderWidget(
                              svgPath: 'assets/svgs/nav_bar/grocery2.svg'),
                    ),
                    label: l10n.grocery,
                  ),
                  BottomNavigationBarItem(
                    icon: SizedBox(
                      width: 26,
                      height: 26,
                      child: _bottomNavIndex == 4
                          ? const SvgRenderWidget(
                              svgPath: 'assets/svgs/nav_bar/profile1.svg')
                          : const SvgRenderWidget(
                              svgPath: 'assets/svgs/nav_bar/profile2.svg'),
                    ),
                    label: l10n.profile,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
