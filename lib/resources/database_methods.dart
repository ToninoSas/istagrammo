// ignore_for_file: prefer_const_constructors
import 'dart:typed_data';

import 'package:istagrammo/models/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:istagrammo/models/comment.dart';
import 'package:istagrammo/models/pick.dart';
import 'package:istagrammo/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class DatabaseMethods {
  static const bool _isDebug = false;

  static const users = 'users';
  static const posts = _isDebug ? _postsDebugCollection : 'posts';
  static const _postsDebugCollection = 'postsDebug';

  final _auth = Supabase.instance.client.auth;
  final _db = Supabase.instance.client;

  Future<List<MyUser>> getUsers({String? filter}) async {
    if (_auth.currentUser != null) {

      List<MyUser> users = [];

      final data = await _db
          .from('users')
          .select('*')
          .gte('username', filter ?? '');

      for (var user in data) {
        users.add(MyUser.fromSnap(user));
      }
      return users;
    }else {
      return [];
    }
  }

  Future<List<Post>> getUserPosts({required String userId}) async {
    if (_auth.currentUser != null) {
      // DocumentSnapshot snap;

      List<Post> posts = [];

      final postsData = await _db
          .from('posts')
          .select("*")
          .eq('codUtente', userId);
      for (var post in postsData) {
        posts.add(Post.fromSnap(post));
      }

      return posts;
    }else {
      return [];
    }
  }

  Future<List<MyUser>> getUserFollowers({required String userId, String? filter}) async {
    if (_auth.currentUser != null) {

      List<MyUser> followers = [];

      final data = await _db
          .from('seguiti')
          .select('users!seguiti_codUtente_fkey(id, username, email, nomecognome, bio, profileImgUrl)')
          .eq('codSeguito', userId).gte('users.username', filter ?? '');

      for (var user in data) {
        MyUser userObj = MyUser.fromSnap(user['users']);
        followers.add(userObj);
      }

      return followers;
    }else {
      return [];
    }
  }

  Future<List<MyUser>> getUserSeguiti({required String userId, String? filter}) async {
    if (_auth.currentUser != null) {

      List<MyUser> seguiti = [];

      final data = await _db
          .from('seguiti')
          .select('users!seguiti_codSeguito_fkey(id, username, email, nomecognome, bio, profileImgUrl)')
          .eq('codUtente', userId).gte('users.username', filter ?? '');

      for (var user in data) {
        seguiti.add(MyUser.fromSnap(user['users']));
      }
      print(seguiti);
      return seguiti;
    }else {
      return [];
    }
  }

  Future<String> editProfile(
      {String? username, String? bio, String? profileImgUrl}) async {
    String msg = "";
    try {
      if (username != null) {
        username = username.trim();
        await _db
            .from(users)
            // .doc(_auth.currentUser!.uid)
            .update({'username': username}).eq('id', _auth.currentUser!.id);
      }

      if (bio != null) {
        bio = bio.trim();
        print("bio modificata ${bio}");
        await _db
            .from(users)
            // .doc(_auth.currentUser!.uid)
            .update({'bio': bio}).eq('id', _auth.currentUser!.id);
      }

      if (profileImgUrl != null) {
        await _db
            .from(users)
            // .doc(_auth.currentUser!.uid)
            .update({'profileImgUrl': profileImgUrl}).eq(
                'id', _auth.currentUser!.id);
      }
    } catch (err) {
      msg = err.toString();
    }

    return msg;
  }

  // Future<String> editPost({required String postId, String? bio}) async {
  //   String msg = "";
  //   try {
  //     if (bio != null) {
  //       bio = bio.trim();

  //       await _db
  //           .collection(FirestoreMethods.postsCollection)
  //           .doc(postId)
  //           .update({'description': bio});
  //     }
  //   } catch (err) {
  //     msg = err.toString();
  //   }

  //   return msg;
  // }

  Future<String> newPost({
    required String codUtente,
    required String description,
    required Uint8List file,
  }) async {
    String msg = "";

    description = description.trim();

    try {
      String imgUrl = await StorageMethods().uploadPost(file);
      String postId = Uuid().v1();

      Post pick = Post(
        postId: postId,
        description: description,
        codUtente: codUtente,
        createdAt: DateTime.now().toString(),
        imgUrl: imgUrl,
      );

      await _db.from(posts).insert(pick.toJson());

      // await _db
      //     .collection(FirestoreMethods.postsCollection)
      //     .doc(postId)
      //     .set(post.toJson());
    } catch (err) {
      msg = err.toString();
    }

    return msg;
  }

  // Future<String> newTwitt({
  //   required String uid,
  //   required String username,
  //   required String description,
  //   required String profileImgUrl,
  // }) async {
  //   String msg = "";

  //   description = description.trim();

  //   try {
  //     // String postUrl = await StorageMethods().uploadPost(file);
  //     String postId = Uuid().v1();

  //     Post post = Post(
  //         postId: postId,
  //         description: description,
  //         uid: uid,
  //         username: username,
  //         likes: [],
  //         comments: [],
  //         datePublished: DateTime.now(),
  //         postUrl: '',
  //         profileImgUrl: profileImgUrl,
  //         isTwitt: true);

  //     await _db
  //         .collection(FirestoreMethods.postsCollection)
  //         .doc(postId)
  //         .set(post.toJson());
  //   } catch (err) {
  //     msg = err.toString();
  //   }

  //   return msg;
  // }

  // TODO controllare meglio
  // Future<void> interact(
  //     {required String pickId,
  //     required String uid,
  //     required String optionId}) async {
  //   try {
  //     final interaction = await _db
  //         .from('interazioni')
  //         .select("*")
  //         .eq('codUtente', uid)
  //         .eq('codPick', pickId)
  //         .eq('codOpzione', optionId)
  //         .limit(1);
  //
  //     // ha interagito -> togliamo l'interazione
  //     if (interaction.isNotEmpty) {
  //       await _db
  //           .from('interazioni')
  //           .delete()
  //           .eq('codUtente', uid)
  //           .eq('codPick', pickId)
  //           .eq('codOpzione', optionId);
  //     } else {
  //       // non ha interagito -> aggiungiamo l'interazione
  //       await _db.from('interazioni').insert(
  //           {"codUtente": uid, "codPick": pickId, "codOpzione": optionId});
  //     }
  //
  //     // if (likes.contains(uid)) {
  //     //   await _db
  //     //       .collection(FirestoreMethods.postsCollection)
  //     //       .doc(postId)
  //     //       .update({
  //     //     'likes': FieldValue.arrayRemove([uid]),
  //     //     'nLikes': FieldValue.increment(-1)
  //     //   });
  //     // } else {
  //     //   await _db
  //     //       .collection(FirestoreMethods.postsCollection)
  //     //       .doc(postId)
  //     //       .update({
  //     //     'likes': FieldValue.arrayUnion([uid]),
  //     //     'nLikes': FieldValue.increment(1)
  //     //   });
  //     // }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  Future<String> deletePost(String postId) async {
    String msg = "";
    try {
      // await _db
      //     .collection(FirestoreMethods.postsCollection)
      //     .doc(postId)
      //     .delete();

      await _db.from(posts).delete().eq('id', postId);
    } catch (err) {
      msg = err.toString();
    }
    return msg;
  }

  Future<void> followUser({
    required String codUtente,
    required String codSeguito,
  }) async {
    try {
      // devo aggiungere un nuovo record
      // se lo segue -> tolgo il follow
      // se non lo segue -> aggiungo il follow

      final result = await _db
          .from('seguiti')
          .select("*")
          .eq('codUtente', codUtente)
          .eq('codSeguito', codSeguito);

      // lo segue -> tolgo il follow
      if (result.isNotEmpty) {
        await _db
            .from('seguiti')
            .delete()
            .eq('codUtente', codUtente)
            .eq('codSeguito', codSeguito);
      } else {
        // non lo segue -> aggiungo il follow
        await _db
            .from('seguiti')
            .insert({"codUtente": codUtente, "codSeguito": codSeguito});
      }

      // if (followers.contains(currentUid)) {
      //   // tolgo il mio uid dalla lista dei suoi followers
      //   await _db
      //       .collection(DatabaseMethods.utentiCollection)
      //       .doc(receiveUid)
      //       .update({
      //     'followers': FieldValue.arrayRemove([currentUid])
      //   });

      //   // tolgo il suo id dalla mia lista dei seguiti
      //   await _db
      //       .collection(DatabaseMethods.utentiCollection)
      //       .doc(currentUid)
      //       .update({
      //     'followed': FieldValue.arrayRemove([receiveUid])
      //   });
      // } else {
      //   await _db
      //       .collection(DatabaseMethods.utentiCollection)
      //       .doc(receiveUid)
      //       .update({
      //     'followers': FieldValue.arrayUnion([currentUid])
      //   });

      //   await _db
      //       .collection(DatabaseMethods.utentiCollection)
      //       .doc(currentUid)
      //       .update({
      //     'followed': FieldValue.arrayUnion([receiveUid])
      //   });
      // }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> addComment(
      {required String codUtente,
      required String codPost,
      required String text,
      required String id}) async {
    String msg = "";

    String commentId = Uuid().v1();
    text = text.trim();

    try {
      Comment comment = Comment(
          codPost: codPost,
          text: text,
          commentId: commentId,
          codUtente: codUtente
          // datePublished: DateTime.now(),
          // likes: []
          );

      await _db.from('commenti').insert(comment.toJson());
      // await _db
      //     .collection(DatabaseMethods.postsCollection)
      //     .doc(postId)
      //     .collection('comments')
      //     .doc(commentId)
      //     .set(comment.toJson());

      // await _db.collection(DatabaseMethods.postsCollection).doc(postId).update({
      //   'comments': FieldValue.arrayUnion([commentId])
      // });
    } catch (e) {
      msg = e.toString();
      print(msg);
    }

    return msg;
  }

  // Future<void> likeComment(
  //     {required String postId,
  //     required String commentId,
  //     required String uid,
  //     required List likes}) async {
  //   try {
  //     if (likes.contains(uid)) {
  //       await _db
  //           .collection(FirestoreMethods.postsCollection)
  //           .doc(postId)
  //           .collection('comments')
  //           .doc(commentId)
  //           .update({
  //         'likes': FieldValue.arrayRemove([uid]),
  //         'nLikes': FieldValue.increment(-1)
  //       });
  //     } else {
  //       await _db
  //           .collection(FirestoreMethods.postsCollection)
  //           .doc(postId)
  //           .collection('comments')
  //           .doc(commentId)
  //           .update({
  //         'likes': FieldValue.arrayUnion([uid]),
  //         'nLikes': FieldValue.increment(1)
  //       });
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // Future<String> deleteComment(
  //     {required String postId, required String commentId}) async {
  //   String msg = "";

  //   try {
  //     await _db
  //         .collection(FirestoreMethods.postsCollection)
  //         .doc(postId)
  //         .collection('comments')
  //         .doc(commentId)
  //         .delete();

  //     await _db
  //         .collection(FirestoreMethods.postsCollection)
  //         .doc(postId)
  //         .update({
  //       'comments': FieldValue.arrayRemove([commentId])
  //     });
  //   } catch (e) {
  //     msg = e.toString();
  //     print(msg);
  //   }

  //   return msg;
  // }
}
