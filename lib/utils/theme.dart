import 'package:flutter/material.dart';

ThemeData lightTeam() {
  return ThemeData(
      primaryColor: Colors.white,
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
      primaryIconTheme: const IconThemeData(color: Colors.black),
      iconButtonTheme: IconButtonThemeData(
          style:
              ButtonStyle(iconColor: MaterialStateProperty.all(Colors.black))));
}

class Styles{
  static ButtonStyle btnStyle = const ButtonStyle(
    // backgroundColor: MaterialStatePropertyAll(Colors.blue),
    // textStyle: MaterialStatePropertyAll(TextStyle(
    //   color: Colors.white
    // ))
  );
}