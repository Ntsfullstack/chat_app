import 'package:flutter/material.dart';

class ThemeClass {
  Color lightPrimaryColor = Colors.white;
  Color darkPrimaryColor = Colors.black;
  Color accentColor = Colors.greenAccent;

  static ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(color: Colors.black)),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: ThemeData.dark().scaffoldBackgroundColor,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: _themeClass.darkPrimaryColor,
    ),
  );
}

ThemeClass _themeClass = ThemeClass();
