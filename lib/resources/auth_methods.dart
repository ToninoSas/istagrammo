import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_app_cool/models/user.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future login({required String email, required String password}) async {
    String msg = "";

    _auth.signInWithEmailAndPassword(email: email, password: password).then(
        (value) {
      print('login effettuato');
    }, onError: (e) => msg = e.toString());

    return msg;
  }

  Future<String> logout() async {
    String msg = "";

    _auth.signOut().then((value) {
      print('logout effettuato');
    }, onError: (e) => msg = e.toString());

    return msg;
  }

  Future<MyUser?> getUserData({String? uid}) async {
    if (_auth.currentUser != null) {
      DocumentSnapshot snap;
      if (uid != null) {
        snap = await _db.collection('utenti').doc(uid).get();
      } else {
        snap = await _db.collection('utenti').doc(_auth.currentUser!.uid).get();
      }

      return MyUser.fromSnap(snap);
    } else {
      return null;
    }
  }
}
