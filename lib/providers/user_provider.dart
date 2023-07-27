import 'package:flutter/material.dart';
import 'package:instagram_app/models/user.dart';

class UserProvider with ChangeNotifier {
  // late String _email;
  // late String _username;
  // late String _profileImage;

  late AuthUser _userProfile;

  AuthUser get userProfile => _userProfile;

  void updateUser(AuthUser newUser) {
    _userProfile = newUser;
    notifyListeners();
  }

  // String get email => _email;
  // String get username => _username;
  // String get profileImage => _profileImage;

  // void updateEmail(String newEmail) {
  //   _email = newEmail;
  //   notifyListeners();
  // }

  // void updateUsername(String newUsername) {
  //   _username = newUsername;
  //   notifyListeners();
  // }

  // void updateProfileImage(String newProfileImage) {
  //   _profileImage = newProfileImage;
  //   notifyListeners();
  // }
}
