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
            color: Colors.white,
            fontSize: 30,
            letterSpacing: 4,
          ),
        ),
      ),
      textTheme: TextTheme(
        display1: defaultTheme.display1.copyWith(color: CupertinoColors.inactiveGray, fontSize: 34),
        display2: defaultTheme.display2.copyWith(color: CupertinoColors.inactiveGray, fontSize: 45),
        display4: defaultTheme.display4.copyWith(color: Colors.white, fontSize: 112),
      ),
    );
  }

  static ThemeData light() {
    final TextTheme defaultTheme = Typography().white;
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: CupertinoColors.extraLightBackgroundGray,
      bottomAppBarColor: CupertinoColors.extraLightBackgroundGray,
      accentColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.black),
      appBarTheme: AppBarTheme(
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.black,
            fontSize: 30,
            letterSpacing: 4,
          ),
        ),
      ),
      textTheme: TextTheme(
        display1: defaultTheme.display1.copyWith(color: CupertinoColors.inactiveGray, fontSize: 34),
        display2: defaultTheme.display2.copyWith(color: CupertinoColors.inactiveGray, fontSize: 45),
        display4: defaultTheme.display4.copyWith(color: Colors.black, fontSize: 112),
      ),
    );
  }
}
