import 'package:flutter/material.dart';
import 'package:instagram_app/models/user.dart';

class UserProvider with ChangeNotifier {

  late AuthUser _userProfile;

  AuthUser get userProfile => _userProfile;

  void updateUser(AuthUser newUser) {
    _userProfile = newUser;
    notifyListeners();
  }

}
