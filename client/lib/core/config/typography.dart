import 'package:flutter/material.dart';

class Fonts {
  static const String heading = 'Baloo';
  static const String body = 'Poppins';
}

class TextStyles {
  static const TextStyle heading = TextStyle(
    fontFamily: Fonts.heading,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle body = TextStyle(
    fontFamily: Fonts.body,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
}
