import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppTheme {
  static final intermediateColor = Color.fromRGBO(231, 72, 86, 1);
  static final restColor = Color.fromRGBO(0, 204, 106, 1);
  static final coolDownColor = Color.fromRGBO(99, 108, 122, 1);
  static final defaultColor = Color.fromRGBO(45, 51, 59, 1);

  static ThemeData dark() {
    final TextTheme defaultTheme = Typography().black;
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.black,
      bottomAppBarColor: Colors.black,
      accentColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
      appBarTheme: AppBarTheme(
        textTheme: TextTheme(
          title: TextStyle(
            letterSpacing: 4,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      textTheme: TextTheme(
        display2: defaultTheme.display4.copyWith(color: CupertinoColors.inactiveGray),
        display4: defaultTheme.display4.copyWith(color: Colors.white),
      ),
    );
  }

  static ThemeData light() {
    final TextTheme defaultTheme = Typography().black;
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: CupertinoColors.extraLightBackgroundGray,
      bottomAppBarColor: CupertinoColors.extraLightBackgroundGray,
      accentColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.black),
      appBarTheme: AppBarTheme(
        textTheme: TextTheme(
          title: TextStyle(
            fontSize: 30,
            letterSpacing: 4,
            color: Colors.black,
          ),
        ),
      ),
      textTheme: TextTheme(
        display2: defaultTheme.display4.copyWith(color: CupertinoColors.inactiveGray),
        display4: defaultTheme.display4.copyWith(color: Colors.black),
      ),
    );
  }
}
