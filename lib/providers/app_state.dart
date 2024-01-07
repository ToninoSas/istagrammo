import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/methods/auth_methods.dart';
import 'package:instagram_app/models/user.dart';

class UserProvider extends ChangeNotifier {
  MyUser? _user;

  MyUser get getUser => _user!;

  final AuthMethods _auth = AuthMethods();

  UserProvider() {
    print('Inizializzato user provider');
  }

  Future<void> caricaDatiUtente() async {
    MyUser user = await _auth.getUserDetails();
  }
}

class AppState extends ChangeNotifier {
  bool _isLogged = false;
  bool get isLogged => _isLogged;

  User get currentUser => FirebaseAuth.instance.currentUser!;

  AppState() {
    print('carico app state');
    init();
  }

  init() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('non sono loggato');

        _isLogged = false;
      } else {
        _isLogged = true;
        print('sono loggato');

        // UserProvider();
      }
      notifyListeners();

    });

  }
}
