import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

teleport(BuildContext context, int selectedIndex) {
  switch (selectedIndex) {
    case 0:
      Navigator.pushReplacementNamed(context, '/home');
      break;
    case 1:
      Navigator.pushReplacementNamed(context, '/search');
      break;
    case 2:
      Navigator.pushReplacementNamed(context, '/profile');
  }
}
