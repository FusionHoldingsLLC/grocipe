import 'dart:async';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocipe/app/app.dart';
import 'package:grocipe/app/locator/locator.dart';
import 'package:grocipe/firebase_options.dart';
import 'package:grocipe/helper/third_party/hive.dart';
import 'package:grocipe/helper/utils/provider_observer.dart';
import 'package:grocipe/ui/provider/observer.dart';
import 'package:grocipe/ui/provider/providers.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

void main() {
  run();
}

void run() async {
  runZonedGuarded(() async {
    debugRepaintRainbowEnabled = false;
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack);
      return true;
    };

    PurchasesConfiguration? configuration;

    if (Platform.isAndroid) {
// configure for Google play store
    } else if (Platform.isIOS) {
      configuration =
          PurchasesConfiguration('appl_UXvfXITtyQaksckYutzAnoQWafk');
    }
    if (configuration != null) {
      await Purchases.configure(configuration);
    }

    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    await dotenv.load(fileName: 'assets/.env');
    Bloc.observer = SimpleBlocObserver();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await HiveFunction.init();
    });
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    HttpOverrides.global = MyHttpOverrides();
    await setUpLocator();
    runApp(
      ProviderScope(
        observers: [
          AppProviderObserver(),
        ],
        child: MultiProvider(
          providers: AppProviders.providers,
          child: App(),
        ),
      ),
    );
  }, (error, stack) {});
}

Future<void> _configureSDK() async {}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
