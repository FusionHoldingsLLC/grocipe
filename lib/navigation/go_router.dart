import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/locator/locator.dart';
import 'package:grocipe/models/order.dart';
import 'package:grocipe/models/plan.dart';
import 'package:grocipe/navigation/route_names.dart';
import 'package:grocipe/ui/provider/analytics_service.dart';
import 'package:grocipe/ui/screens/auth_screens/auth_wrapper.dart';
import 'package:grocipe/ui/screens/delete_account_Screen/delete_warning.dart';
import 'package:grocipe/ui/screens/email_checker_screen/email_checker_view.dart';
import 'package:grocipe/ui/screens/manage_subscription/manage_subscription.dart';
import 'package:grocipe/ui/screens/name_screen/name_screen.dart';
import 'package:grocipe/ui/screens/auth_state_screen/auth_state_view.dart';
import 'package:grocipe/ui/screens/onboarding_detail_screen/widget/onboarding_plan.dart';
import 'package:grocipe/ui/screens/signup_screen/signup_view.dart';
import 'package:grocipe/ui/screens/chat_screen/chat_screen.dart';
import 'package:grocipe/ui/screens/chat_screen/websocket.dart';
import 'package:grocipe/ui/screens/grocery_history/grocery_history.dart';
import 'package:grocipe/ui/screens/grocery_history/history_detail.dart';
import 'package:grocipe/ui/screens/Recipe_detail/Recipe_detail_view.dart';
import 'package:grocipe/ui/screens/Update_recipe/update_recipe.dart';
import 'package:grocipe/ui/screens/instructions_play/instruction_play.dart';
import 'package:grocipe/ui/screens/meal_screen/create_plan/create_plan.dart';
import 'package:grocipe/ui/screens/onboarding_detail_screen/welcome_onb.dart';
import 'package:grocipe/ui/screens/add_ingredient_screen/add_ingredient_view.dart';
import 'package:grocipe/ui/screens/add_recipe_screen/add_recipe_view.dart';
import 'package:grocipe/ui/screens/receipe_screen/Add_recipe_url/url_recipe_screen.dart';
import 'package:grocipe/ui/screens/delete_account_Screen/delete_account_view.dart';
import 'package:grocipe/ui/screens/edit_profile_screen/edit_profile_view.dart';
import 'package:grocipe/ui/screens/change_password/change_password_view.dart';
import 'package:grocipe/ui/screens/prefrences_screen/prefrences_view.dart';
import 'package:grocipe/ui/screens/profile_screen/profile_view.dart';
import 'package:grocipe/ui/screens/loading_screen/loading_screen.dart';
import 'package:grocipe/ui/screens/splash_screen/splash_screen.dart';
import 'package:grocipe/ui/screens/forgot_password/forgot_password_view.dart';
import 'package:grocipe/ui/screens/set_password_screen/set_password_view.dart';
import 'package:grocipe/ui/screens/verify_email/verify.dart';
import 'package:grocipe/ui/screens/verify_token_screen/veriify_token_view.dart';
import 'package:grocipe/ui/screens/login_screen/login_view.dart';
import 'package:grocipe/ui/screens/onboarding_screen/onboarding_screen.dart';
import 'package:grocipe/ui/screens/main_screen/main_screen.dart';
import 'package:grocipe/models/recipe.dart';

// Configure GoRouter with route constants'
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

GoRouter router() {
  return GoRouter(
    navigatorKey: navigatorKey,
    observers: [
      // FirebaseAnalyticsObserver(analytics: _analytics),
      NavigationObserver(
        onNavigate: (routeName) {
          // AnalyticsService.(routeName);
          locator<AnalyticsService>().sendAnalyticsEvent(
              eventName: "routeName", clickEvent: routeName);
        },
      ),
    ],
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: '/loading',
        name: Routes.loading,
        builder: (context, state) => const LoadingScreen(),
      ),

      //ONBOARDING
      GoRoute(
        path: '/onboarding',
        name: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      GoRoute(
        path: '/welcomonb',
        name: Routes.welcomonb,
        builder: (context, state) => const WelcomeOnbScreen(),
      ),

      GoRoute(
        path: '/onboarding_plan_screen',
        name: Routes.onboardingPlanScreen,
        builder: (context, state) => const OnboardingPlanScreen(),
      ),

      //AUTH SCREEN
      GoRoute(
        name: Routes.auth,
        path: '/auth',
        builder: (context, state) => const AuthWrapper(),
        routes: <RouteBase>[
          GoRoute(
            path: 'forgot',
            name: Routes.forgotPassword,
            builder: (context, state) => const ForgotPassword(),
            routes: <RouteBase>[
              GoRoute(
                path: 'verify/:email',
                name: Routes.verifyToken,
                builder: (context, state) {
                  return verifyTokenScreen(
                    email: state.pathParameters['email']!,
                  );
                },
                routes: <RouteBase>[
                  GoRoute(
                    name: Routes.setPassword,
                    path: 'set_password',
                    builder: (context, state) => SetPasswordScreen(
                      email: state.pathParameters['email']!,
                    ),
                    routes: const <RouteBase>[],
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: 'verify',
            name: Routes.verifyEmail,
            builder: (context, state) => const VerifyEmail(),
            routes: const <RouteBase>[],
          ),
          GoRoute(
            path: 'signIn',
            name: Routes.signIn,
            builder: (context, state) =>
                LoginScreen(email: state.extra as String),
            routes: const <RouteBase>[],
          ),
          GoRoute(
            path: 'nameScreen',
            name: Routes.nameScreen,
            builder: (context, state) => const NameScreen(),
            routes: const <RouteBase>[],
          ),
          GoRoute(
            path: 'signUpLogin',
            name: Routes.authState,
            builder: (context, state) => const AuthStateScreen(),
            routes: const <RouteBase>[],
          ),
          GoRoute(
            path: 'signup',
            name: Routes.signUp,
            builder: (context, state) =>
                SignUpScreen(email: state.extra as String),
            routes: <RouteBase>[
              GoRoute(
                path: 'verify',
                name: Routes.signUpVerify,
                builder: (context, state) => const VerifyEmail(),
                routes: const <RouteBase>[],
              ),
            ],
          ),
        ],
      ),
      //MAIN SCREEN
      GoRoute(
        path: '/main_screen',
        name: Routes.mainScreen,
        builder: (context, state) => const MainScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'chat',
            name: Routes.chat,
            builder: (context, state) => const ChatScreen(),
          ),
          GoRoute(
            path: 'websocket',
            name: Routes.websocket,
            builder: (context, state) => const WebSocketExample(),
          ),
          GoRoute(
            path: 'add/recipe',
            name: Routes.addRecipe,
            builder: (context, state) =>
                AddReceipe(updateRecipe: state.extra as Recipe?),
            routes: <RouteBase>[
              GoRoute(
                name: Routes.addIngredient,
                path: 'ingredient',
                builder: (context, state) =>
                    AddIngredient(updateRecipe: state.extra as Recipe?),
                routes: const <RouteBase>[],
              ),
            ],
          ),
          GoRoute(
            path: 'add/url',
            name: Routes.addRecipeUrl,
            builder: (context, state) => const UrlRecipeScreen(),
            routes: const <RouteBase>[],
          ),
          GoRoute(
            path: 'recipe/view',
            name: Routes.recipeView,
            builder: (context, state) {
              return RecipeDetailScreen(recipe: state.extra!);
            },
            routes: <RouteBase>[
              GoRoute(
                path: 'demo',
                name: Routes.instructionDemo,
                builder: (context, state) => InstructionDemo(
                  recipe: state.extra!,
                ),
                routes: const <RouteBase>[],
              ),
            ],
          ),
          GoRoute(
            path: 'create/email_checker',
            name: Routes.emailChecker,
            builder: (context, state) {
              return const EmailChecker();
            },
          ),
          GoRoute(
            path: 'create/meal_plan',
            name: Routes.createPlan,
            builder: (context, state) {
              return CreatePlan(
                plan: state.extra as PlanExtras,
              );
            },
          ),
          GoRoute(
            path: 'recipe/update',
            name: Routes.updateRecipe,
            builder: (context, state) {
              return UpdateRecipe(recipe: state.extra as Recipe);
            },
          ),
          GoRoute(
            path: 'edit/profile',
            name: Routes.editProfile,
            builder: (context, state) {
              return const EditprofileScren();
            },
          ),
          GoRoute(
            path: 'edit/password',
            name: Routes.changePassword,
            builder: (context, state) {
              return const ChnagePassword();
            },
          ),
          GoRoute(
            path: 'prefrences',
            name: Routes.prefrences,
            builder: (context, state) {
              return const PrefrencesScreen();
            },
          ),
          GoRoute(
            path: 'profile/delete',
            name: Routes.deleteProfile,
            builder: (context, state) {
              return const DeleteScreen();
            },
          ),
          GoRoute(
            path: 'profile/delete_warning',
            name: Routes.deleteWarning,
            builder: (context, state) {
              return const DeleteWarning();
            },
          ),
          GoRoute(
            path: 'profile',
            name: Routes.profile,
            builder: (context, state) {
              return const ProfileScreen();
            },
          ),
          GoRoute(
            path: 'manage_subscription',
            name: Routes.manageSubscription,
            builder: (context, state) {
              return const ManageSubscription();
            },
          ),
          GoRoute(
              path: 'grocery/history',
              name: Routes.groceryHistory,
              builder: (context, state) {
                return const GroceryHistory();
              },
              routes: [
                GoRoute(
                  path: 'detail',
                  name: Routes.groceryDetail,
                  builder: (context, state) {
                    return GroceryDetail(
                      order: state.extra as Order,
                    );
                  },
                )
              ])
        ],
      ),
    ],
  );
}

class NavigationObserver extends NavigatorObserver {
  final void Function(String routeName) onNavigate;

  NavigationObserver({required this.onNavigate});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings is Page) {
      final routeName = route.settings.name ?? 'Unknown';
      onNavigate(routeName);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is Page) {
      final routeName = previousRoute?.settings.name ?? 'Unknown';
      onNavigate(routeName);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is Page) {
      final routeName = newRoute?.settings.name ?? 'Unknown';
      onNavigate(routeName);
    }
  }
}
