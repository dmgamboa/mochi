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
        displayLarge: TextStyles.heading.copyWith(fontSize: 96),
        displayMedium: TextStyles.heading.copyWith(fontSize: 60),
        displaySmall: TextStyles.heading.copyWith(fontSize: 48),
        titleMedium: TextStyles.body.copyWith(fontSize: 16),
        bodyLarge: TextStyles.body.copyWith(fontSize: 16),
        bodyMedium: TextStyles.body.copyWith(fontSize: 14),
        labelLarge: TextStyles.heading.copyWith(fontSize: 20),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colours.pink,
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }
}
