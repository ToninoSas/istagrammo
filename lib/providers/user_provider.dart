import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_app_cool/models/post.dart';
import 'package:instagram_app_cool/models/user.dart';
import 'package:instagram_app_cool/resources/auth_methods.dart';

class UserProvider extends ChangeNotifier {
  MyUser? _myUser;
  MyUser get myUser => _myUser!;

  bool hasLoaded = false;

  User? currentUser = FirebaseAuth.instance.currentUser;

  UserProvider() {
    init();
  }

  init() {
    FirebaseFirestore.instance
        .collection('utenti')
        .where('uid', isEqualTo: currentUser!.uid)
        .snapshots()
        .listen(
      (event) async {
        hasLoaded = false;

        _myUser = MyUser.fromSnap(event.docs[0]);
        final snap = await FirebaseFirestore.instance
            .collection('posts')
            .where('uid', isEqualTo: currentUser!.uid)
            .get();

        _myUser!.posts = [];

        for (var doc in snap.docs) {
          _myUser!.posts.add(Post.fromSnap(doc));
        }

        hasLoaded = true;
        notifyListeners();
        print('Aggiorno i dati dell utente');
      },
    );

    FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: currentUser!.uid)
        .snapshots()
        .listen(
      (snap) {
        if (_myUser == null) return;

        hasLoaded = false;
        _myUser!.posts = [];

        for (var doc in snap.docs) {
          _myUser!.posts.add(Post.fromSnap(doc));
        }
        hasLoaded = true;

        notifyListeners();

        print('Aggiorno i dati dei posts');
      },
    );
  }

  Future loadUserData() async {
    String msg = "";
    try {
      _myUser = await AuthMethods().getUserData(uid: currentUser!.uid);
      notifyListeners();
    } catch (err) {
      msg = err.toString();
      print(msg);
    }

    return msg;
  }
}
