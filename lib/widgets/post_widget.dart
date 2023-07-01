// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:instagram_app/models/post.dart';
import 'package:instagram_app/models/user.dart';
import 'package:instagram_app/providers/user_data_service_provider.dart';
import 'package:instagram_app/widgets/circle_box_widget.dart';

class PostWidget extends StatefulWidget {
  //Costruttore
  const PostWidget({Key? key, required this.openedPost}) : super(key: key);

  final Post openedPost;

  //gestione dello stato
  @override
  _Post createState() => _Post();
}

class _Post extends State<PostWidget> {
  // int selectedIndex = 1;
  bool like = false;

  @override
  Widget build(BuildContext context) {
    User currentUser = UserDataServiceProvider.of(context).userData;

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
                            onPressed: () {
                              setState(() {
                                like = !like;
                                if (like) {
                                  widget.openedPost.likes++;
                                } else {
                                  widget.openedPost.likes--;
                                }
                              });
                            }),
                        IconButton(
                            onPressed: () => {},
                            icon: const Icon(Icons.comment)),
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
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'Likes: ${widget.openedPost.likes}',
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
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(widget.openedPost.descr),
                    ),
                  ],
                )
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Column(
            //       children: [
            //         Row(
            //           children: [
            //             IconButton(
            //                 onPressed: () => {},
            //                 icon: const Icon(Icons.account_circle_rounded)),
            //             const Text('Aggiungi un commento...')
            //           ],
            //         )
            //       ],
            //     ),
            //     Column(
            //       //mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Row(
            //           children: [
            //             IconButton(
            //               onPressed: () => {},
            //               icon: const Icon(Icons.favorite),
            //               iconSize: 16,
            //               padding: const EdgeInsets.all(2),
            //               //alignment: Alignment.centerLeft,
            //             ),
            //             IconButton(
            //               onPressed: () => {},
            //               icon: const Icon(Icons.comment),
            //               iconSize: 16,
            //               padding: const EdgeInsets.all(2),
            //             ),
            //             IconButton(
            //               onPressed: () => {},
            //               icon: const Icon(Icons.send_rounded),
            //               iconSize: 16,
            //               padding: const EdgeInsets.all(2),
            //             ),
            //           ],
            //         )
            //       ],
            //     )
            //   ],
            // ),
            const Padding(padding: EdgeInsets.only(bottom: 12))
          ],
        ),
      ),
    );
  }
}
