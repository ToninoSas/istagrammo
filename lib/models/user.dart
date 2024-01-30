import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String username, bio, email, profileImgUrl;
  final String uid;
  List posts=[], followers, followed;

  MyUser({
    required this.username,
    required this.uid,
    required this.profileImgUrl,
    required this.email,
    required this.bio,
    required this.followers,
    required this.followed,
    // required this.posts,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'bio': bio,
      'email': email,
      'followers': followers,
      'followed': followed,
      'profileImgUrl': profileImgUrl,
    };
  }

  static MyUser fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return MyUser(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      profileImgUrl: snapshot["profileImgUrl"],
      bio: snapshot["bio"],
      followers: snapshot["followers"],
      followed: snapshot["followed"],
      // posts: snapshot["posts"],
    );
  }
}
