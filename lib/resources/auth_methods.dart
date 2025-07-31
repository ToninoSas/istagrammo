// ignore_for_file: avoid_print

import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:istagrammo/models/user.dart';
import 'package:istagrammo/resources/database_methods.dart';
import 'package:istagrammo/resources/storage_methods.dart';
import 'package:istagrammo/utils/utils.dart';

class AuthMethods {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _db = FirebaseFirestore.instance;

  // final supabase = Supabase.instance.client;
  final _auth = Supabase.instance.client.auth;
  final _db = Supabase.instance.client;

  Future<String> login(
      {required String email, required String password}) async {
    String msg = "";

    email = email.trim();
    password = password.trim();

    try {
      // await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _auth.signInWithPassword(email: email, password: password);
    } catch (err) {
      msg = err.toString();
    }

    return msg;
  }

  Future<String> register(
      {required String email,
      required String password,
      required String username,
      required String nomeCognome,
      String? bio,
      Uint8List? profileImg}) async {
    String msg = "";

    email = email.trim();
    password = password.trim();
    username = username.trim();

    try {
      AuthResponse cred = await _auth.signUp(email: email, password: password);

      String? profileImgUrl;

      if (profileImg != null) {
        profileImgUrl = await StorageMethods().uploadProfilePic(profileImg);
      }

      MyUser user = MyUser(
          username: username,
          id: cred.user!.id,
          nomecognome: nomeCognome,
          email: email,
          bio: bio ?? "",
          profileImgUrl: profileImgUrl ?? defaultProfileImg);

      await _db.from('users').insert(user.toJson());
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
      // DocumentSnapshot snap;

      final response = await _db.from('users').select("*").eq('id', uid);

      return MyUser.fromSnap(response.first);
    } else {
      return null;
    }
  }

  Future<bool> deleteUser({required String uid}) async {
    try {
      // await _auth.currentUser!.delete();

      // todo cancellare i dati dell'utente
      // todo cancellare i post dell'utente
    } catch (e) {
      print(e.toString());
      return false;
    }

    return true;
  }
}
