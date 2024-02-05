import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:istagrammo/models/post.dart';
import 'package:istagrammo/models/user.dart';
import 'package:istagrammo/resources/firestore_methods.dart';

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
        .collection(FirestoreMethods.utentiCollection)
        .where('uid', isEqualTo: currentUser!.uid)
        .snapshots()
        .listen(
      (event) async {
        hasLoaded = false;

        _myUser = MyUser.fromSnap(event.docs[0]);
        final snap = await FirebaseFirestore.instance
            .collection(FirestoreMethods.postsCollection)
            .where('uid', isEqualTo: currentUser!.uid)
            .orderBy('datePublished', descending: true)
            .get();

        _myUser!.posts = [];
        _myUser!.twitts = [];

        for (var doc in snap.docs) {
          if (doc.data()['isTwitt']) {
            _myUser!.twitts.add(doc);
          } else {
            Post post = Post.fromSnap(doc);
            _myUser!.posts.add(post);
          }
        }

        hasLoaded = true;
        notifyListeners();
        print('Aggiorno i dati dell utente');
      },
    );

    FirebaseFirestore.instance
        .collection(FirestoreMethods.postsCollection)
        .where('uid', isEqualTo: currentUser!.uid)
        .orderBy('datePublished', descending: true)
        .snapshots()
        .listen(
      (snap) {
        if (_myUser == null) return;

        hasLoaded = false;

        _myUser!.posts = [];
        _myUser!.twitts = [];

        for (var doc in snap.docs) {
          // Post post = Post.fromSnap(doc);
          if (doc.data()['isTwitt']) {
            _myUser!.twitts.add(doc);
          } else {
            Post post = Post.fromSnap(doc);
            _myUser!.posts.add(post);
          }
        }

        hasLoaded = true;

        notifyListeners();

        print('Aggiorno i dati dei posts');
      },
    );
  }
}
