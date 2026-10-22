// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/app/locator/locator.dart';
import 'package:grocipe/helper/l10n/l1on.dart';
import 'package:grocipe/app/app_theme/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocipe/navigation/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:grocipe/helper/language_config/lang_extension.dart';
import 'package:grocipe/repository/recipe_repo/recipe_implementation.dart';
import 'package:grocipe/repository/user_repo/user_implementation.dart';
import 'package:grocipe/ui/provider/bloc_providers.dart';
import 'package:one_context/one_context.dart';

class App extends StatelessWidget {
  App({super.key});

  final _router = locator<GoRouter>();

  

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<RecipeRepoImp>(create: (context) => RecipeRepoImp()),
        RepositoryProvider<userRepoImp>(create: (context) => userRepoImp()),
      ],
      child: MultiBlocProvider(
        providers: BlocProviders.providers,
        child: MaterialApp.router(
          supportedLocales: L1on.all,
          localizationsDelegates: const [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            AppLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          title: 'Grocipe',
          theme: appTheme,
          routerConfig: _router,
          builder: OneContext().builder,
          
        ),
      ),
    );
  }
}
