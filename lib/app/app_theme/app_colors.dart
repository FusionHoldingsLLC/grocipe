part of 'theme.dart';

class AppColorExtension extends ThemeExtension<AppColorExtension> {
  final Color red;
  final Color green;
  final Color orange;
  final Color white;
  final Color captionGrey;
  final Color black;
  final Color borderGrey;

  // decor colors
  final Color greenDecor;
  final Color blueDecor;
  final Color orangeDecor;
  final Color purpleDecor;
  final Color pinkDecor;
  final Color greyDecor;
  final Color greyOutline;

  // decor colors Dark
  final Color greenDecorDark;
  final Color blueDecorDark;
  final Color orangeDecorDark;
  final Color purpleDecorDark;
  final Color pinkDecorDark;
  final Color greyDecorDark;

  AppColorExtension({
    required this.green,
    required this.white,
    required this.orange,
    required this.red,
    required this.captionGrey,
    required this.black,
    required this.borderGrey,
    required this.greenDecor,
    required this.blueDecor,
    required this.orangeDecor,
    required this.purpleDecor,
    required this.pinkDecor,
    required this.greyDecor,
     required this.greenDecorDark,
    required this.blueDecorDark,
    required this.orangeDecorDark,
    required this.purpleDecorDark,
    required this.pinkDecorDark,
    required this.greyDecorDark,
    required this.greyOutline,
  });

  @override
  ThemeExtension<AppColorExtension> copyWith({
    Color? green,
    Color? red,
    Color? white,
    Color? orange,
    Color? captionGrey,
    Color? black,
    Color? borderGrey,
    Color? greenDecor,
    Color? blueDecor,
    Color? orangeDecor,
    Color? purpleDecor,
    Color? pinkDecor,
    Color? greyDecor,
    Color? greenDecorDark,
    Color? blueDecorDark,
    Color? orangeDecorDark,
    Color? purpleDecorDark,
    Color? pinkDecorDark,
    Color? greyDecorDark,
    Color? greyOutline,
  }) {
    return AppColorExtension(
      green: green ?? this.green,
      white: white ?? this.white,
      red: red ?? this.red,
      orange: orange ?? this.orange,
      captionGrey: captionGrey ?? this.captionGrey,
      black: black ?? this.black,
      borderGrey: borderGrey ?? this.borderGrey,
      greenDecor: greenDecor ?? this.greenDecor,
      blueDecor: blueDecor ?? this.blueDecor,
      orangeDecor: orangeDecor ?? this.orangeDecor,
      purpleDecor: purpleDecor ?? this.purpleDecor,
      pinkDecor: pinkDecor ?? this.pinkDecor,
      greyDecor: greyDecor ?? this.greyDecor,
        greenDecorDark: greenDecorDark ?? this.greenDecorDark,
      blueDecorDark: blueDecorDark ?? this.blueDecorDark,
      orangeDecorDark: orangeDecorDark ?? this.orangeDecorDark,
      purpleDecorDark: purpleDecorDark ?? this.purpleDecorDark,
      pinkDecorDark: pinkDecorDark ?? this.pinkDecorDark,
      greyDecorDark: greyDecorDark ?? this.greyDecorDark,
      greyOutline: greyOutline ?? this.greyOutline,
    );
  }

  @override
  ThemeExtension<AppColorExtension> lerp(
          covariant ThemeExtension<AppColorExtension>? other, double t) =>
      this;
}
