import 'package:instagram_app/models/user.dart';

class Post {
  late int id;
  late String url, ownerName;

  late User ownerUser;

  late var comments = [], likes = [], descr = "";

  Post.loadPost({required json}) {
    this.id = json['ID'];
    url = json['url'];
    comments = json['comments'];
    descr = json['descr'];
    likes = json['likes'];
    ownerName = json['username'];
  }
}

class PostThumb {
  late int id;
  late String url;

  PostThumb.loadThumb({required json}) {
    this.id = json['ID'];
    url = json['url'];
  }
}
