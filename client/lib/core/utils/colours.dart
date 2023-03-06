import 'package:flutter/material.dart';

// Adapted from https://stackoverflow.com/questions/58360989/programmatically-lighten-or-darken-a-hex-color-in-dart
class ColorUtils {
  /// Darken a color by [amount] (1.0 = black)
  // ........................................................
  static Color darken(Color c, [double amount = 0.10]) {
    assert(0.0 <= amount && amount <= 1.0);
    return Color.fromARGB(c.alpha, (c.red * amount).round(),
        (c.green * amount).round(), (c.blue * amount).round());
  }

  /// Lighten a color by [amount] (1.0 = white)
  // ........................................................
  static Color lighten(Color c, [double amount = 0.10]) {
    assert(0.0 <= amount && amount <= 1.0);
    return Color.fromARGB(
        c.alpha,
        c.red + ((255 - c.red) * amount).round(),
        c.green + ((255 - c.green) * amount).round(),
        c.blue + ((255 - c.blue) * amount).round());
  }
}
