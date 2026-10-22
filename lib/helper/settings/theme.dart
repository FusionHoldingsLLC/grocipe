import 'package:flutter/material.dart';
import 'package:grocipe/helper/settings/palette.dart';

final ThemeData appThemeData = ThemeData(
  // Define the default brightness and colors.
  brightness: Brightness.light,
//
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Palette.green // Text color
        ),
  ),
  // Define the default font family.
  fontFamily: 'Montserrat',
  buttonTheme: const ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
  ),
  primaryColor: Palette.green,
  primarySwatch: Colors.blue,
  buttonBarTheme: const ButtonBarThemeData(
    buttonTextTheme: ButtonTextTheme.primary,

    // Other properties as needed
  ),
  // Define the default TextTheme. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  listTileTheme: ListTileThemeData(
    textColor: Palette.black,
    selectedColor: Palette.grey,
    titleTextStyle: TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Palette.black,
    ),
  ),

  textTheme: TextTheme(
    // labelLarge: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
    // labelMedium: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),

    // labelSmall: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
    // displayLarge: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
    // displaySmall: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
    // displayMedium: TextStyle(
    //     fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
    // bodyMedium: TextStyle(fontSize: 16, color: Colors.red),

    titleLarge: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16.0,
        fontWeight: FontWeight.w700,
        color: Palette.black),
    titleMedium: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Palette.black),
    titleSmall: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 18.0,
        fontWeight: FontWeight.normal,
        color: Palette.black),
    bodyLarge: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: Palette.black),
    // bodyMedium: TextStyle(
    //     fontFamily: 'Montserrat',
    //     fontSize: 14.0,
    //     fontWeight: FontWeight.w500,
    //     color: Palette.black),
    bodySmall: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 10.0,
        fontWeight: FontWeight.w400,
        color: Palette.black),
  ),
  // Define the default button theme
  // buttonTheme: ButtonThemeData(
  //   buttonColor:
  //       Color(0xFFFFA000), // Replace with the primary color in your palette
  //   textTheme: ButtonTextTheme.accent,
  // ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Palette.black,
  ),
  appBarTheme: AppBarTheme(foregroundColor: Palette.black),
  // Define the default color scheme.
  colorScheme: ColorScheme(
    primary: Palette.white,
    // Replace with the primary color in your palette

    // primaryVariant: Color(0xFFD17F00), // Replace with darker shade of primary
    secondary: Palette.green, // Replace with your secondary color
    tertiary: Palette.black,
    // secondaryVariant: Color(0xFFFFD54F), // Replace with a lighter shade of secondary
    surface: Colors.white,
    background: Colors.white,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  ),

  // You can add other theme attributes as needed, such as appBarTheme, iconTheme, etc.
);
