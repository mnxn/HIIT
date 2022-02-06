import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// See https://github.com/flutter/flutter/issues/93140
String? defaultFont() {
  if (ThemeData().platform == TargetPlatform.iOS) {
    return '-apple-system, BlinkMacSystemFont';
  } else {
    return null;
  }
}

class AppTheme {
  static const workColor = Color.fromRGBO(231, 72, 86, 1);
  static const restColor = Color.fromRGBO(0, 204, 106, 1);
  static const coolDownColor = Color.fromRGBO(99, 108, 122, 1);
  static const defaultColor = Color.fromRGBO(45, 51, 59, 1);

  static ThemeData dark(BuildContext context) {
    final TextTheme defaultTheme = Typography().black;
    return ThemeData(
      fontFamily: defaultFont(),
      brightness: Brightness.dark,
      primaryColor: Colors.black,
      bottomAppBarColor: Colors.black,
      dialogBackgroundColor: Colors.black,
      iconTheme: const IconThemeData(color: CupertinoColors.extraLightBackgroundGray),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        toolbarTextStyle: TextStyle(
          color: CupertinoColors.extraLightBackgroundGray,
          fontSize: 30,
          letterSpacing: 4,
        ),
        titleTextStyle: TextStyle(
          color: CupertinoColors.extraLightBackgroundGray,
          fontSize: 30,
          letterSpacing: 4,
        ),
      ),
      textTheme: TextTheme(
        headline4: defaultTheme.headline4?.copyWith(color: CupertinoColors.inactiveGray, fontSize: 30),
        headline3: defaultTheme.headline3?.copyWith(color: CupertinoColors.inactiveGray, fontSize: 40),
        headline1: defaultTheme.headline1?.copyWith(color: CupertinoColors.extraLightBackgroundGray, fontSize: 100),
      ),
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: CupertinoColors.extraLightBackgroundGray, brightness: Brightness.dark),
    );
  }

  static ThemeData light(BuildContext context) {
    final TextTheme defaultTheme = Typography().white;
    return ThemeData(
      fontFamily: defaultFont(),
      brightness: Brightness.light,
      primaryColor: CupertinoColors.extraLightBackgroundGray,
      bottomAppBarColor: CupertinoColors.extraLightBackgroundGray,
      dialogBackgroundColor: CupertinoColors.extraLightBackgroundGray,
      iconTheme: const IconThemeData(color: Colors.black),
      appBarTheme: const AppBarTheme(
        backgroundColor: CupertinoColors.extraLightBackgroundGray,
        toolbarTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 30,
          letterSpacing: 4,
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 30,
          letterSpacing: 4,
        ),
      ),
      textTheme: TextTheme(
        headline4: defaultTheme.headline4?.copyWith(color: CupertinoColors.inactiveGray, fontSize: 30),
        headline3: defaultTheme.headline3?.copyWith(color: CupertinoColors.inactiveGray, fontSize: 40),
        headline1: defaultTheme.headline1?.copyWith(color: Colors.black, fontSize: 100),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
    );
  }
}
