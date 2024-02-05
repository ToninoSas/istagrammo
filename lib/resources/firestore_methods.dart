// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:istagrammo/models/comment.dart';
import 'package:istagrammo/models/post.dart';
import 'package:istagrammo/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  static const bool _isDebug = false;

  static const utentiCollection = 'utenti';
  static const postsCollection = _isDebug ? _postsDebugCollection : 'posts';
  static const _postsDebugCollection = 'postsDebug';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> editProfile(
      {String? username, String? bio, String? profileImgUrl}) async {
    String msg = "";
    try {
      if (username != null) {
        username = username.trim();
        await _db
            .collection(FirestoreMethods.utentiCollection)
            .doc(_auth.currentUser!.uid)
            .update({'username': username});
      }

      if (bio != null) {
        bio = bio.trim();
        await _db
            .collection(FirestoreMethods.utentiCollection)
            .doc(_auth.currentUser!.uid)
            .update({'bio': bio});
      }

      if (profileImgUrl != null) {
        await _db
            .collection(FirestoreMethods.utentiCollection)
            .doc(_auth.currentUser!.uid)
            .update({'profileImgUrl': profileImgUrl});
      }
    } catch (err) {
      msg = err.toString();
    }

    return msg;
  }

  Future<String> editPost({required String postId, String? bio}) async {
    String msg = "";
    try {
      if (bio != null) {
        bio = bio.trim();

        await _db
            .collection(FirestoreMethods.postsCollection)
            .doc(postId)
            .update({'description': bio});
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

    description = description.trim();

    try {
      String postUrl = await StorageMethods().uploadPost(file);
      String postId = Uuid().v1();

      Post post = Post(
        postId: postId,
        description: description,
        uid: uid,
        username: username,
        likes: [],
        comments: [],
        datePublished: DateTime.now(),
        postUrl: postUrl,
        profileImgUrl: profileImgUrl,
        isTwitt: false,
      );

      await _db
          .collection(FirestoreMethods.postsCollection)
          .doc(postId)
          .set(post.toJson());
    } catch (err) {
      msg = err.toString();
    }

    return msg;
  }

  Future<String> newTwitt({
    required String uid,
    required String username,
    required String description,
    required String profileImgUrl,
  }) async {
    String msg = "";

    description = description.trim();

    try {
      // String postUrl = await StorageMethods().uploadPost(file);
      String postId = Uuid().v1();

      Post post = Post(
          postId: postId,
          description: description,
          uid: uid,
          username: username,
          likes: [],
          comments: [],
          datePublished: DateTime.now(),
          postUrl: '',
          profileImgUrl: profileImgUrl,
          isTwitt: true);

      await _db
          .collection(FirestoreMethods.postsCollection)
          .doc(postId)
          .set(post.toJson());
    } catch (err) {
      msg = err.toString();
    }

    return msg;
  }

  Future<void> likePost(
      {required String postId,
      required String uid,
      required List likes}) async {
    try {
      if (likes.contains(uid)) {
        await _db
            .collection(FirestoreMethods.postsCollection)
            .doc(postId)
            .update({
          'likes': FieldValue.arrayRemove([uid]),
          'nLikes': FieldValue.increment(-1)
        });
      } else {
        await _db
            .collection(FirestoreMethods.postsCollection)
            .doc(postId)
            .update({
          'likes': FieldValue.arrayUnion([uid]),
          'nLikes': FieldValue.increment(1)
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> deletePost(String postId) async {
    String msg = "";
    try {
      await _db
          .collection(FirestoreMethods.postsCollection)
          .doc(postId)
          .delete();
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
        await _db
            .collection(FirestoreMethods.utentiCollection)
            .doc(receiveUid)
            .update({
          'followers': FieldValue.arrayRemove([currentUid])
        });

        // tolgo il suo id dalla mia lista dei seguiti
        await _db
            .collection(FirestoreMethods.utentiCollection)
            .doc(currentUid)
            .update({
          'followed': FieldValue.arrayRemove([receiveUid])
        });
      } else {
        await _db
            .collection(FirestoreMethods.utentiCollection)
            .doc(receiveUid)
            .update({
          'followers': FieldValue.arrayUnion([currentUid])
        });

        await _db
            .collection(FirestoreMethods.utentiCollection)
            .doc(currentUid)
            .update({
          'followed': FieldValue.arrayUnion([receiveUid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> addComment(
      {required String username,
      required String profileImgUrl,
      required String text,
      required String postId,
      required String uid}) async {
    String msg = "";

    String commentId = Uuid().v1();
    text = text.trim();

    try {
      Comment comment = Comment(
          uid: uid,
          username: username,
          profileImgUrl: profileImgUrl,
          postId: postId,
          text: text,
          commentId: commentId,
          datePublished: DateTime.now(),
          likes: []);

      await _db
          .collection(FirestoreMethods.postsCollection)
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .set(comment.toJson());

      await _db
          .collection(FirestoreMethods.postsCollection)
          .doc(postId)
          .update({
        'comments': FieldValue.arrayUnion([commentId])
      });
    } catch (e) {
      msg = e.toString();
      print(msg);
    }

    return msg;
  }

  Future<void> likeComment(
      {required String postId,
      required String commentId,
      required String uid,
      required List likes}) async {
    try {
      if (likes.contains(uid)) {
        await _db
            .collection(FirestoreMethods.postsCollection)
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid]),
          'nLikes': FieldValue.increment(-1)
        });
      } else {
        await _db
            .collection(FirestoreMethods.postsCollection)
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid]),
          'nLikes': FieldValue.increment(1)
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> deleteComment(
      {required String postId, required String commentId}) async {
    String msg = "";

    try {
      await _db
          .collection(FirestoreMethods.postsCollection)
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();

      await _db
          .collection(FirestoreMethods.postsCollection)
          .doc(postId)
          .update({
        'comments': FieldValue.arrayRemove([commentId])
      });
    } catch (e) {
      msg = e.toString();
      print(msg);
    }

    return msg;
  }
}
