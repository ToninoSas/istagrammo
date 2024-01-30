import 'package:flutter/material.dart';

InputDecoration textFieldDecoration({Icon? icon, String? label}) =>
    InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        // contentPadding: const EdgeInsets.all(8),

        labelText: label,
        prefixIcon: icon,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))));

const Color backgroundColorLight = Colors.white;
const Color backgroundColorDark = Color.fromRGBO(0, 0, 0, 1);

const Color primaryColorLight = Colors.blue;
const Color primaryColorDark = Color.fromRGBO(38, 38, 38, 1);

ThemeData darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: backgroundColorDark,
  appBarTheme: const AppBarTheme(backgroundColor: backgroundColorDark),
  primaryColor: Colors.white,
  secondaryHeaderColor: Colors.grey,
  cardColor: backgroundColorDark,
  drawerTheme: const DrawerThemeData(
    backgroundColor: backgroundColorDark,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(primaryColorDark),
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))))),
);

ThemeData lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: backgroundColorLight,
  // disabledColor: Colors.grey,
  appBarTheme: const AppBarTheme(
      backgroundColor: primaryColorLight,
      elevation: 0,
      // titleTextStyle: TextStyle(color: Colors.black, fontSize: 20)
      ),
  primaryColor: primaryColorLight,
  secondaryHeaderColor: Colors.grey,
  cardColor: backgroundColorLight,
  drawerTheme: const DrawerThemeData(
    backgroundColor: backgroundColorLight,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(primaryColorLight),
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))))),
);
