import 'package:flutter/material.dart';
import 'package:mochi/core/config/colours.dart';

import '../typography.dart';

class LightTheme {
  static ThemeData get theme {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: Colours.pink,
      colorScheme: ColorScheme.light(
        primary: Colours.pink,
        secondary: Colours.green,
        background: Colours.lightBg,
        surface: Colors.grey[200]!,
        onBackground: Colours.darkText,
        onSurface: Colours.darkText,
        error: Colours.red,
        onError: Colours.lightBg,
      ),
      textTheme: TextTheme(
        headline1: TextStyles.heading.copyWith(fontSize: 96),
        headline2: TextStyles.heading.copyWith(fontSize: 60),
        headline3: TextStyles.heading.copyWith(fontSize: 48),
        subtitle1: TextStyles.body.copyWith(fontSize: 16),
        bodyText1: TextStyles.body.copyWith(fontSize: 16),
        bodyText2: TextStyles.body.copyWith(fontSize: 14),
        button: TextStyles.heading.copyWith(fontSize: 20),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colours.pink,
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }
}
