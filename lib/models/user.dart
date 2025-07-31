import 'package:istagrammo/models/pick.dart';

class MyUser {
  final String username, bio, email, profileImgUrl, nomecognome;
  final String id;

  // TODO late
  List<Post> posts = [];
  List followers = [], followed = [];
  List twitts = [];

  MyUser({
    required this.username,
    required this.id,
    required this.profileImgUrl,
    required this.email,
    required this.bio,
    required this.nomecognome
    // required this.posts,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'bio': bio,
      'email': email,
      'nomecognome':nomecognome,
      // 'followers': followers,
      // 'followed': followed,
      'profileImgUrl': profileImgUrl,
    };
  }

  static MyUser fromSnap(Map<String, dynamic> snapshot) {
    // var snapshot = snap.data() as Map<String, dynamic>;

    return MyUser(
      username: snapshot["username"],
      id: snapshot["id"],
      email: snapshot["email"],
      profileImgUrl: snapshot["profileImgUrl"],
      bio: snapshot["bio"],
      nomecognome: snapshot["nomecognome"],
      // followers: snapshot["followers"],
      // followed: snapshot["followed"],
      // posts: snapshot["posts"],
    );
  }
}
