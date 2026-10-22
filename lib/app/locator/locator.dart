// ignore_for_file: unused_import

import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:grocipe/helper/third_party/hive.dart';
import 'package:grocipe/navigation/go_router.dart';
import 'package:grocipe/services/app_state_service.dart';
import 'package:grocipe/services/localization_service.dart';
import 'package:grocipe/services/user_service.dart';
import 'package:grocipe/ui/provider/analytics_service.dart';

GetIt locator = GetIt.instance;
Future setUpLocator() async {
  // var instance = await LocalStorageService.getInstance();
  // locator.registerSingleton<LocalStorageService>(instance);
  locator.registerSingleton<GoRouter>(router());
  locator.registerLazySingleton(() => HiveFunction());
  locator.registerLazySingleton(() => UserService());
  locator.registerSingleton(AppStateService());
  locator.registerSingleton(LocalizationService());
  locator.registerLazySingleton(() => AnalyticsService());
}
