import 'package:flutter/material.dart';
import 'package:mochi/core/config/colours.dart';

class LightTheme {
  static ThemeData get theme {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
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
      textTheme: const TextTheme(
        headline6: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyText2: TextStyle(
          fontSize: 14,
          color: Colours.darkText,
        ),
      ),
    );
  }
}
