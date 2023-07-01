// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:instagram_app/models/post.dart';
import 'package:instagram_app/pages/open_post_page.dart';

class UserProfilePost extends StatefulWidget {
  //Costruttore
  UserProfilePost({Key? key, required this.postJson, required this.username})
      : super(key: key);

  //variabili
  final postJson;
  String username;

  //gestione dello stato
  @override
  _UserProfilePost createState() => _UserProfilePost();
}

class _UserProfilePost extends State<UserProfilePost> {
  // int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    bool exist = true;

    Post currentPost =
        Post(widget.postJson['ID'], widget.postJson['url'], widget.username);

    // print('POST id ${currentPost.id} \nPOST url ${currentPost.url}');

    return GestureDetector(
      onTap: () {
        if (exist) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PostPage(currentPost: currentPost)));
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
              // setState(() {
              //   exist = false;
              // });

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
