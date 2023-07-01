import 'package:flutter/material.dart';

ThemeData lightTeam() {
  return ThemeData(
      primaryColor: Colors.white,
      primarySwatch: Colors.grey,
      brightness: Brightness.light,
      primaryIconTheme: const IconThemeData(color: Colors.black),
      iconButtonTheme: IconButtonThemeData(
          style:
              ButtonStyle(iconColor: MaterialStateProperty.all(Colors.black))));
}
