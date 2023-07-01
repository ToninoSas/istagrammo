// ignore_for_file: annotate_overrides, overridden_fields

import 'package:instagram_app/models/user.dart';
import 'package:flutter/material.dart';

class UserDataServiceProvider extends InheritedWidget {
  UserDataServiceProvider(
      {super.key, required this.child, required this.userData})
      : super(child: child);
  final Widget child;
  // final DataService dataService = DataService();

  User userData;

  static UserDataServiceProvider of(BuildContext context) {
    return (context
            .dependOnInheritedWidgetOfExactType<UserDataServiceProvider>()
        as UserDataServiceProvider);
  }

  void update(User newUser) {
    userData = newUser;
  }

  @override
  bool updateShouldNotify(UserDataServiceProvider oldWidget) {
    return userData != oldWidget;
  }
}
