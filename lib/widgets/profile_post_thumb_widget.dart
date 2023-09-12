// ignore_for_file: library_private_types_in_public_api, must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:instagram_app/models/post.dart';
import 'package:instagram_app/models/user.dart';
// import 'package:instagram_app/pages/open_post_page.dart';
import 'package:instagram_app/widgets/post_widget.dart';
import 'package:instagram_app/utils/api.dart' as api;

class UserProfilePostThumb extends StatefulWidget {
  //Costruttore
  UserProfilePostThumb({Key? key, required this.postInfo, required this.owner})
      : super(key: key);

  //variabili
  final postInfo;
  // String username;

  User owner;

  //gestione dello stato
  @override
  _UserProfilePost createState() => _UserProfilePost();
}

class _UserProfilePost extends State<UserProfilePostThumb> {
  // int selectedIndex = 1;
  late Post postToOpen;

  getPostData({postId}) async {
    Map<String, dynamic> postJsonInfo =
        (await api.PostApi.getPost(widget.owner.username, postId));
    postToOpen = Post.loadPost(json: postJsonInfo);
    postToOpen.ownerUser = widget.owner;

    print('muori');
  }

  @override
  Widget build(BuildContext context) {
    bool exist = true;

    // carico la thumb
    PostThumb currentPostThumb = PostThumb.loadThumb(json: widget.postInfo);

    // sarebbe la page che mostra il post con i suoi dettagli
    Widget postPage = Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Post'),
        ),
        body: FutureBuilder(
          future: getPostData(postId: currentPostThumb.id),
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
                return PostWidget(openedPost: postToOpen);
            }
          },
        ));

    // rappresenta il thumb dell'immagine
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
            currentPostThumb.url,
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
