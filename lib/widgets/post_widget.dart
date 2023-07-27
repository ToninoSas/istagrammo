// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:instagram_app/dialogs/insert_text_dialog.dart';
import 'package:instagram_app/models/post.dart';
import 'package:instagram_app/models/user.dart';
import 'package:instagram_app/providers/user_data_service_provider.dart';
import 'package:instagram_app/providers/user_provider.dart';
import 'package:instagram_app/widgets/circle_box_widget.dart';
import 'package:provider/provider.dart';

import 'package:instagram_app/utils/api.dart' as api;

class PostWidget extends StatefulWidget {
  //Costruttore
  const PostWidget({Key? key, required this.openedPost, required this.owner})
      : super(key: key);

  final Post openedPost;
  final User owner;

  //gestione dello stato
  @override
  _Post createState() => _Post();
}

class _Post extends State<PostWidget> {
  // int selectedIndex = 1;
  bool like = false;
  TextEditingController _commentController = TextEditingController();

  checkLike() {
    String currentUsername =
        Provider.of<UserProvider>(context, listen: false).userProfile.username;
    if (widget.openedPost.likes.contains(currentUsername)) {
      return true;
    }

    print(widget.openedPost.likes);

    return false;
  }

  addLikeApi(context) async {
    return (await api.PostApi.addLike(
        widget.owner.username,
        widget.openedPost.id.toString(),
        Provider.of<UserProvider>(context, listen: false)
            .userProfile
            .username));
  }

  removeLikeApi(context) async {
    return await api.PostApi.removeLike(
        widget.owner.username,
        widget.openedPost.id.toString(),
        Provider.of<UserProvider>(context, listen: false).userProfile.username);
  }

  addComment() async {}

  @override
  Widget build(BuildContext context) {
    AuthUser currentUser = Provider.of<UserProvider>(context).userProfile;

    like = checkLike();

    // var likePost = Icon(Icons.favorite);
    // var nonLikePost = Icon(Icons.favorite_border);

    return SingleChildScrollView(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //username
            Row(
              //textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleBox(
                  imageProvider: NetworkImage(currentUser.profileImgUrl),
                  width: 40,
                  height: 40,
                ),
                SizedBox(
                  height: 50,
                  child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        widget.openedPost.owner,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )),
                ),
                // IconButton(
                //   onPressed: () => {},
                //   icon: const Icon(Icons.settings),
                // )
              ],
            ),
            const Divider(
              thickness: 1,
              height: 0,
              color: Colors.grey,
            ),
            Container(
              color: Theme.of(context).primaryColor,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 400,
                child: Image.network(
                  widget.openedPost.url,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text('Ops.. Post not found'),
                    );
                  },
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const Divider(
              thickness: 1,
              height: 0,
              color: Colors.grey,
            ),
            //buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            splashColor: Colors.lightGreen,
                            splashRadius: 5,
                            icon: Icon(
                                like ? Icons.favorite : Icons.favorite_border),
                            color: like ? Colors.red : Colors.black,
                            onPressed: () async {
                              setState(() {
                                like = !like;

                                if (like) {
                                  widget.openedPost.likes
                                      .add(currentUser.username);
                                  widget.openedPost.likeCounter =
                                      widget.openedPost.likes.length;

                                  addLikeApi(context);
                                } else {
                                  if (widget.openedPost.likes.isNotEmpty) {
                                    widget.openedPost.likes
                                        .remove(currentUser.username);
                                    widget.openedPost.likeCounter =
                                        widget.openedPost.likes.length;

                                    removeLikeApi(context);
                                  }
                                }
                              });
                            }),
                        IconButton(
                            onPressed: () async {
                              // await textDialog(context, _commentController);

                              // widget.openedPost.comments
                              //     .add(_commentController.text);
                            },
                            icon: const Icon(Icons.add_comment)),
                        IconButton(
                            onPressed: () => {},
                            icon: const Icon(Icons.send_rounded)),
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                        onPressed: () => {}, icon: const Icon(Icons.save)),
                  ],
                )
              ],
            ),
            //comments
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(widget.openedPost.descr),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'Likes: ${widget.openedPost.likeCounter}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                              'Commenti: ${widget.openedPost.comments.length}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: 300,
                    //   child: ListView.builder(
                    //     itemBuilder: (context, index) {
                    //       return Text(widget.openedPost.comments[index]);
                    //     },
                    //     itemCount: widget.openedPost.comments.length,
                    //   ),
                    // )
                  ],
                )
              ],
            ),
            const Padding(padding: EdgeInsets.only(bottom: 12))
          ],
        ),
      ),
    );
  }
}
