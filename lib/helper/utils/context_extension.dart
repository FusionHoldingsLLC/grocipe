import 'package:flutter/material.dart';
import 'package:grocipe/app/app_theme/theme.dart';

extension BuildContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;

  ElevatedButtonThemeData get elevatedButtonTheme =>
      Theme.of(this).elevatedButtonTheme;
  TextTheme get primaryTextTheme => Theme.of(this).primaryTextTheme;

  Color get primaryColor => theme.primaryColor;
  Color get cardColor => theme.cardColor;
  Color get errorColor => theme.colorScheme.error;
  Color get secondaryColor => theme.colorScheme.secondary;
  Color get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;

  AppColorExtension get colors =>
      Theme.of(this).extension<AppColorExtension>()!;

  double get height => MediaQuery.of(this).size.height;

  EdgeInsets get screenPadding => MediaQuery.of(this).padding;

  double get width => MediaQuery.of(this).size.width;

  void showErrorSnackBar(dynamic error) =>
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.cancel, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "$error",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: errorColor,
        ),
      );

  void showMessage(dynamic message, {Duration? duration}) =>
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black54,
          content: Row(
            children: [
              const Icon(Icons.message, color: Colors.white),
              const SizedBox(width: 16),
              Text("$message", style: const TextStyle(color: Colors.white)),
            ],
          ),
          duration: duration ?? const Duration(seconds: 1),
        ),
      );

  void showSuccessSnackBar(dynamic message) =>
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text("$message",
                    style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );

  T customTheme<T>() => Theme.of(this).extension<T>()!;

  T arg<T>() => ModalRoute.of(this)!.settings.arguments as T;

  bool get canPop => Navigator.of(this).canPop();

  void openDrawer() => Scaffold.of(this).openDrawer();

  void maybePop<T>([T? result]) => Navigator.maybePop(this, result);

  void closeDrawer() => Scaffold.of(this).closeDrawer();
}
