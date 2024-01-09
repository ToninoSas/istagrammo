import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String username, bio, email, profileImgUrl;
  final String uid;
  final List posts, followers, followed;

  const MyUser({
    required this.username,
    required this.uid,
    required this.profileImgUrl,
    required this.email,
    required this.bio,
    required this.followers,
    required this.followed,
    required this.posts,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'bio': bio,
      'email': email,
      'posts': posts,
      'followers': followers,
      'followed': followed,
      'profile_img_url': profileImgUrl,
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
      posts: snapshot["posts"],
    );
  }
}
