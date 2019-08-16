import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppTheme {
  static ThemeData dark() {
    final TextTheme defaultTheme = Typography().black;
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.black,
      bottomAppBarColor: Colors.black,
      accentColor: Colors.white,
      textTheme: TextTheme(
        headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        body1: defaultTheme.body1.copyWith(fontSize: 14.0),
        display4: defaultTheme.display4.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
      ),
      appBarTheme: AppBarTheme(
        textTheme: TextTheme(
          title: TextStyle(fontFamily: "BioRhyme", letterSpacing: 5, fontSize: 30),
        ),
      ),
    );
  }
}
