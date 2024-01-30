// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_app_cool/models/user.dart';
import 'package:instagram_app_cool/resources/firestore_methods.dart';
import 'package:instagram_app_cool/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> login(
      {required String email, required String password}) async {
    String msg = "";

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (err) {
      msg = err.toString();
    }

    return msg;
  }

  Future<String> register(
      {required String email,
      required String password,
      required String username,
      String? bio,
      Uint8List? profileImg}) async {
    String msg = "";

    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      String? profileImgUrl;

      if (profileImg != null) {
        profileImgUrl = await StorageMethods().uploadProfilePic(profileImg);
      }

      MyUser user = MyUser(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio ?? "",
          followers: [],
          followed: [],
          profileImgUrl: profileImgUrl ??
              "https://static.vecteezy.com/system/resources/previews/020/911/740/original/user-profile-icon-profile-avatar-user-icon-male-icon-face-icon-profile-icon-free-png.png");

      await _db.collection('utenti').doc(cred.user!.uid).set(user.toJson());
    } catch (err) {
      msg = err.toString();
    }

    return msg;
  }

  Future<String> logout() async {
    String msg = "";

    _auth.signOut().then((value) {
      print('logout effettuato');
    }, onError: (e) => msg = e.toString());

    return msg;
  }

  Future<MyUser?> getUserData({required String uid}) async {
    if (_auth.currentUser != null) {
      DocumentSnapshot snap;
      
      snap = await _db.collection('utenti').doc(uid).get();
      
      return MyUser.fromSnap(snap);
    } else {
      return null;
    }
  }

  Future<bool> deleteUser({required String uid}) async {
    try {
      await _auth.currentUser!.delete();

      // todo cancellare i dati dell'utente
      // todo cancellare i post dell'utente
    } catch (e) {
      print(e.toString());
      return false;
    }

    return true;
  }
}
