// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_app/models/user.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  getUserDetails() async {
    User currentUser = _auth.currentUser!;

    final snap = await _db.collection('utenti').doc(currentUser.uid).get();
    MyUser user = MyUser.fromSnap(snap);

    return user;
  }

  Future<String> registraUtente(
      {required String username,
      required String email,
      required String password}) async {
    String _errorMsg = "";

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User currentUser = _auth.currentUser!;

      MyUser user = MyUser(
          username: username,
          uid: currentUser.uid,
          email: email,
          bio: "",
          followers: [],
          followed: [],
          profileImgUrl: "",
          posts: []);

      // adding user in our database
      await _db.collection("users").doc(currentUser.uid).set(user.toJson());
    } catch (e) {
      _errorMsg = e.toString();
    }

    print(_errorMsg);

    return _errorMsg;
  }

  Future<String> loginUtente(
      {required String email, required String password}) async {
    String _errorMsg = "";

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      _errorMsg = e.toString();
    }

    print(_errorMsg);

    return _errorMsg;
  }

  Future<String> googleLoginUtente() async {
    String _errorMsg = "";

    try {
      await FirebaseAuth.instance
          .signInWithProvider(GoogleAuthProvider());
    } catch (e) {
      _errorMsg = e.toString();
    }

    print(_errorMsg);

    return _errorMsg;
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
