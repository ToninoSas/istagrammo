import 'package:flutter/services.dart';
import 'package:instagram_app/models/user.dart';

class Post {
  late int id;
  late String url, owner;

  late User postOwner;

  late var comments = [], likes = [], descr = "";

  late var likeCounter = likes.length;

  Post(this.id, this.url, this.owner, this.comments, this.descr, this.likes);

  Post.fromJson(json) {
    this.id = json['ID'];
    url = json['url'];
    comments = json['comments'];
    descr = json['descr'];
    // likes = json['likes'];
    owner = json['username'];
  }

  Post.fromJsonDetailed(json) {
    this.id = json['ID'];
    url = json['url'];
    comments = json['comments'];
    descr = json['descr'];
    likes = json['likes'];
    owner = json['username'];
  }
}
