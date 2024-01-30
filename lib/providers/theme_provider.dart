import 'package:flutter/cupertino.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  toogleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }
}
