import 'package:flutter/cupertino.dart';
import 'package:instagram_app_cool/models/user.dart';
import 'package:instagram_app_cool/resources/auth_methods.dart';

class UserProvider extends ChangeNotifier {
  MyUser? _myUser;
  MyUser? get myUser => _myUser;

  init() {
    AuthMethods().getUserData().then((value) {
      _myUser = value;
      print(_myUser!.email);

      notifyListeners();
    });
  }
}
