import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const workColor = Color.fromRGBO(231, 72, 86, 1);
const restColor = Color.fromRGBO(0, 204, 106, 1);
const coolDownColor = Color.fromRGBO(99, 108, 122, 1);
const defaultColor = Color.fromRGBO(45, 51, 59, 1);

ThemeData dark() {
  final TextTheme defaultTheme = Typography().black;
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    bottomAppBarTheme: const BottomAppBarTheme(color: Colors.black),
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
      headlineMedium: defaultTheme.headlineMedium?.copyWith(color: CupertinoColors.inactiveGray, fontSize: 30),
      displaySmall: defaultTheme.displaySmall?.copyWith(color: CupertinoColors.inactiveGray, fontSize: 40),
      displayLarge: defaultTheme.displayLarge?.copyWith(color: CupertinoColors.extraLightBackgroundGray, fontSize: 100),
    ),
    colorScheme: ColorScheme.fromSwatch()
        .copyWith(secondary: CupertinoColors.extraLightBackgroundGray, brightness: Brightness.dark),
  );
}

ThemeData light() {
  final TextTheme defaultTheme = Typography().white;
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: CupertinoColors.extraLightBackgroundGray,
    bottomAppBarTheme: const BottomAppBarTheme(color: CupertinoColors.extraLightBackgroundGray),
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
      headlineMedium: defaultTheme.headlineMedium?.copyWith(color: CupertinoColors.inactiveGray, fontSize: 30),
      displaySmall: defaultTheme.displaySmall?.copyWith(color: CupertinoColors.inactiveGray, fontSize: 40),
      displayLarge: defaultTheme.displayLarge?.copyWith(color: Colors.black, fontSize: 100),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
  );
}
