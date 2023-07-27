// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:instagram_app/models/post.dart';
import 'package:instagram_app/models/user.dart';
import 'package:instagram_app/pages/open_post_page.dart';
import 'package:instagram_app/widgets/post_widget.dart';
import 'package:instagram_app/utils/api.dart' as api;

class UserProfilePost extends StatefulWidget {
  //Costruttore
  UserProfilePost({Key? key, required this.postJson, required this.owner})
      : super(key: key);

  //variabili
  final postJson;
  // String username;

  User owner;

  //gestione dello stato
  @override
  _UserProfilePost createState() => _UserProfilePost();
}

class _UserProfilePost extends State<UserProfilePost> {
  // int selectedIndex = 1;
  late Post currentDetailedPost;

  getPostData(postId) async {
    var postJsonInfo =
        await api.PostApi.getPost(widget.owner.username, postId);
    currentDetailedPost = Post.fromJsonDetailed(postJsonInfo);
  }

  @override
  Widget build(BuildContext context) {
    bool exist = true;

    Post currentPost = Post.fromJson(widget.postJson);

    Widget postPage = Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Post'),
        ),
        body: FutureBuilder(
          future: getPostData(currentPost.id),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(
                  child: Text('You are getting nothing'),
                );
              case ConnectionState.active:
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Center(
                    child: Text('error ${snapshot.error}'),
                  );
                }
                return PostWidget(openedPost: currentDetailedPost, owner: widget.owner);
            }
          },
        ));

    return GestureDetector(
      onTap: () {
        if (exist) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => postPage));
        }
      },
      child: Container(
        color: Theme.of(context).primaryColor,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Image.network(
            currentPost.url,
            errorBuilder: (context, error, stackTrace) {
              exist = false;

              return const Center(
                child: Text('Ops.. Post not found'),
              );
            },
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
