// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_app_cool/models/post.dart';
import 'package:instagram_app_cool/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> editProfile(
      {String? username, String? bio, String? profileImgUrl}) async {
    String msg = "";
    try {
      if (username != null) {
        await _db
            .collection('utenti')
            .doc(_auth.currentUser!.uid)
            .update({'username': username});
      }

      if (bio != null) {
        await _db
            .collection('utenti')
            .doc(_auth.currentUser!.uid)
            .update({'bio': bio});
      }

      if (profileImgUrl != null) {
        await _db
            .collection('utenti')
            .doc(_auth.currentUser!.uid)
            .update({'profileImgUrl': profileImgUrl});
      }
    } catch (err) {
      msg = err.toString();
    }

    return msg;
  }

  Future<String> newPost({
    required String uid,
    required String username,
    required String description,
    required String profileImgUrl,
    required Uint8List file,
  }) async {
    String msg = "";

    try {
      String postUrl = await StorageMethods().uploadPost(file);
      String postId = Uuid().v1();

      Post post = Post(
          postId: postId,
          description: description,
          uid: uid,
          username: username,
          likes: [],
          datePublished: DateTime.now(),
          postUrl: postUrl,
          profileImgUrl: profileImgUrl);

      await _db.collection('posts').doc(postId).set(post.toJson());
    } catch (err) {
      msg = err.toString();
    }

    return msg;
  }

  Future<List<Post>> getPosts({required String uid}) async {
    String msg = "";

    List<Post> myPosts = [];

    try {
      final data = await _db
          .collection('posts')
          .where('uid', isEqualTo: uid)
          // .orderBy({'datePublished'}, descending: true)
          .get();

      for (var doc in data.docs) {
        Post post = Post.fromSnap(doc);
        myPosts.add(post);
      }
    } catch (err) {
      msg = err.toString();
      rethrow;
    }

    return myPosts;
  }

  Future<void> likePost(
      {required String postId,
      required String uid,
      required List likes}) async {
    try {
      if (likes.contains(uid)) {
        await _db.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _db.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> deletePost(String postId) async {
    String msg = "";
    try {
      await _db.collection('posts').doc(postId).delete();
    } catch (err) {
      msg = err.toString();
    }
    return msg;
  }

  Future<void> followUser(
      {required String currentUid,
      required String receiveUid,
      required List followers}) async {
    try {
      if (followers.contains(currentUid)) {
        // tolgo il mio uid dalla lista dei suoi followers
        await _db.collection('utenti').doc(receiveUid).update({
          'followers': FieldValue.arrayRemove([currentUid])
        });

        // tolgo il suo id dalla mia lista dei seguiti
        await _db.collection('utenti').doc(currentUid).update({
          'followed': FieldValue.arrayRemove([receiveUid])
        });
      } else {
        await _db.collection('utenti').doc(receiveUid).update({
          'followers': FieldValue.arrayUnion([currentUid])
        });

        await _db.collection('utenti').doc(currentUid).update({
          'followed': FieldValue.arrayUnion([receiveUid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
