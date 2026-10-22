library theme;

import 'dart:math';

import 'package:flutter/material.dart';

part 'colors.dart';
part 'fonts.dart';
part 'text_styles.dart';
part 'app_colors.dart';

ThemeData get appTheme => _buildLightTheme();

ThemeData _buildLightTheme() {
  const Color primaryColor = _Colors.primaryColor;
  const Color secondaryColor = _Colors.secondaryColor;

  final ColorScheme colorScheme = const ColorScheme.light().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
    error: _Colors.red,
  );

  final themeData = ThemeData(
    useMaterial3: false,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: _Colors.scaffoldColor,
    cardColor: _Colors.white,
    colorScheme: colorScheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: _Colors.scaffoldColor,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 18,
        color: _Colors.black,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      behavior: SnackBarBehavior.floating,
      contentTextStyle: _AppTextStyles.bodyMedium,
      insetPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
        minimumSize: const Size(double.infinity, 55),
        backgroundColor: _Colors.primaryColor,
        textStyle: _AppTextStyles.displayMedium.copyWith(color: _Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: _AppTextStyles.displayMedium.copyWith(
          color: _Colors.primaryColor,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
        minimumSize: const Size(double.infinity, 55),
        backgroundColor: _Colors.white,
        foregroundColor: _Colors.primaryColor,
        side: BorderSide.none,
        textStyle: _AppTextStyles.displayMedium.copyWith(
          color: _Colors.primaryColor,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _Colors.greyOutline),
      ),
      isDense: true,
      filled: true,
      fillColor: _Colors.white,
    ),
    fontFamily: AppFont.montserrat,
    textTheme: const TextTheme(
      bodyLarge: _AppTextStyles.bodyLarge,
      bodyMedium: _AppTextStyles.bodyMedium, // default text styling
      bodySmall: _AppTextStyles.bodySmall,
      displayLarge: _AppTextStyles.displayLarge,
      displayMedium: _AppTextStyles.displayMedium,
      titleLarge: _AppTextStyles.titleLarge,
      titleMedium: _AppTextStyles.titleMedium,
      titleSmall: _AppTextStyles.titleSmall,

      ///for captions
      // labelMedium: _AppTextStyles.bodyCaption,
      labelSmall: _AppTextStyles.labelSmall,
    ),
    extensions: [
      AppColorExtension(
        green: _Colors.green,
        white: _Colors.white,
        red: _Colors.red,
        orange: _Colors.orange,
        captionGrey: _Colors.captionColor,
        black: _Colors.black,
        borderGrey: _Colors.greyLight,
        blueDecor: _Colors.blueDecor,
        greenDecor: _Colors.greenDecor,
        greyDecor: _Colors.greyDecor,
        orangeDecor: _Colors.orangeDecor,
        pinkDecor: _Colors.pinkDecor,
        purpleDecor: _Colors.purpleDecor,
        blueDecorDark: _Colors.blueDecorDark,
        greenDecorDark: _Colors.greenDecorDark,
        greyDecorDark: _Colors.greyDecorDark,
        orangeDecorDark: _Colors.orangeDecorDark,
        pinkDecorDark: _Colors.pinkDecorDark,
        purpleDecorDark: _Colors.purpleDecorDark,
        greyOutline: _Colors.greyOutline,
      ),
    ],
  );
  return themeData;
}

// Color healthRatingColor() {
//   final random = Random();
//   return Color.fromARGB(
//       255, random.nextInt(256), random.nextInt(256), random.nextInt(256));
// }

Color healthRatingColor(String mealName, String mealType, String dayOfWeek) {
  String key = "${mealName[0]}$mealType$dayOfWeek";

  int hash = key.hashCode;

  int red = (hash & 0xFF0000) >> 16;
  int green = (hash & 0x00FF00) >> 8;
  int blue = (hash & 0x0000FF);

  red = (red + 128) % 256;
  green = (green + 128) % 256;
  blue = (blue + 128) % 256;

  return Color.fromRGBO(red, green, blue, 1.0);
}

// Color healthRatingColor() {
//   final random = Random();
//   const int offset = 127;
//   return Color.fromARGB(255, offset + random.nextInt(128),
//       offset + random.nextInt(128), offset + random.nextInt(128));
// }

Color healthRatingColor2(double healthRating) {
  // Ensure the healthRating is within the range [0, 1]
  final random = Random();

  double healthRating = random.nextInt(2).toDouble();
  // healthRating = healthRating.clamp(0.0, 1.0);

  // Define color ranges
  const Color green = Color(0xFF00FF00); // Green
  const Color lime = Color(0xFFBFFF00); // Lime
  const Color yellow = Color(0xFFFFFF00); // Yellow
  const Color orange = Color(0xFFFFA500); // Orange
  const Color red = Color(0xFFFF0000); // Red

  Color interpolate(Color startColor, Color endColor, double fraction) {
    int r =
        (startColor.red + (endColor.red - startColor.red) * fraction).toInt();
    int g = (startColor.green + (endColor.green - startColor.green) * fraction)
        .toInt();
    int b = (startColor.blue + (endColor.blue - startColor.blue) * fraction)
        .toInt();
    return Color.fromARGB(255, r, g, b);
  }

  if (healthRating <= 0.25) {
    return interpolate(red, orange, healthRating / 0.25);
  } else if (healthRating <= 0.5) {
    return interpolate(orange, yellow, (healthRating - 0.25) / 0.25);
  } else if (healthRating <= 0.75) {
    return interpolate(yellow, lime, (healthRating - 0.5) / 0.25);
  } else {
    return interpolate(lime, green, (healthRating - 0.75) / 0.25);
  }
}
