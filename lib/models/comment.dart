import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String username;
  final String uid;
  final String postId;
  final String commentId;
  final String profileImgUrl;
  final String text;
  List likes = [];
  final DateTime datePublished;

  Comment(
      {required this.username,
      required this.profileImgUrl,
      required this.uid,
      required this.postId,
      required this.commentId,
      required this.text,
      required this.likes,
      required this.datePublished});

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Comment(
        text: snapshot['text'],
        commentId: snapshot["commentId"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        postId: snapshot["postId"],
        username: snapshot["username"],
        profileImgUrl: snapshot['profileImgUrl'],
        datePublished: snapshot['datePublished'].toDate());
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "text": text,
        "commentId": commentId,
        "likes": likes,
        "username": username,
        "postId": postId,
        "profileImgUrl": profileImgUrl,
        "nLikes": likes.length,
        "datePublished": datePublished
      };
}
