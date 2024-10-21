import 'package:flutter/material.dart';

class CustomThemeMode {
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
