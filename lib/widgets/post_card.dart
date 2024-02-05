// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:istagrammo/models/user.dart';
import 'package:istagrammo/providers/user_provider.dart';
import 'package:istagrammo/resources/firestore_methods.dart';
import 'package:istagrammo/screens/comments_screen.dart';
import 'package:istagrammo/screens/edit_post_screen.dart';
import 'package:istagrammo/screens/profile_screen.dart';
import 'package:istagrammo/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  PostCard({super.key, required this.snap});

  final snap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    final MyUser user = Provider.of<UserProvider>(context).myUser;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            if (user.uid != widget.snap['uid'].toString()) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                            uid: widget.snap['uid'].toString(),
                          )));
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.snap['profileImgUrl']),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      widget.snap['username'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                if (user.uid == widget.snap['uid'].toString())
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              contentPadding: EdgeInsets.zero,
                              children: [
                                SimpleDialogOption(
                                  onPressed: () {
                                    Navigator.of(context).pop();

                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => EditPostScreen(
                                        snap: widget.snap,
                                      ),
                                    ));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    child: const Text(
                                      'Modifica post',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                SimpleDialogOption(
                                  onPressed: () async {
                                    String msg = await FirestoreMethods()
                                        .deletePost(widget.snap['postId']);

                                    Navigator.of(context).pop();

                                    if (msg != "") {
                                      showSnackBar(context, msg);
                                    } else {
                                      showSnackBar(context, 'Post eliminato');
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    child: const Text(
                                      'Elimina post',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.more_vert_outlined))
                else
                  IconButton(onPressed: null, icon: Icon(null))
              ],
            ),
          ),
        ),
        SizedBox(
          // height: MediaQuery.of(context).size.height / 2,
          height: 350,
          width: MediaQuery.of(context).size.width,
          child: InkWell(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                  uid: user.uid,
                  postId: widget.snap['postId'],
                  likes: widget.snap['likes']);
            },
            // child: PhotoView(
            //   imageProvider: NetworkImage(widget.snap['postUrl']),
            //   minScale: PhotoViewComputedScale.contained,
            
            //   errorBuilder: (context, error, stackTrace) {
            //     return const Center(
            //         child: Text('Impossibile caricare l\'immagine'));
            //   },
              
            // ),
            child: Image.network(
              widget.snap['postUrl'],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                    child: Text('Impossibile caricare l\'immagine'));
              },
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    IconButton(
                      onPressed: () async {
                        await FirestoreMethods().likePost(
                            uid: user.uid,
                            postId: widget.snap['postId'],
                            likes: widget.snap['likes']);
                      },
                      icon: widget.snap['likes'].contains(user.uid)
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.favorite_border,
                            ),
                    ),
                    Positioned(
                      bottom: 15,
                      left: 40,
                      child: Text('${widget.snap['likes'].length}'),
                    )
                  ],
                ),
                Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              CommentsScreen(snap: widget.snap),
                        ));
                      },
                      icon: const FaIcon(
                        size: 22,
                        FontAwesomeIcons.commentDots,
                      ),
                    ),
                    Positioned(
                      bottom: 15,
                      left: 40,
                      child: Text('${widget.snap['comments'].length}'),
                    )
                  ],
                ),
                const IconButton(onPressed: null, icon: Icon(Icons.share)),
              ],
            ),
            const IconButton(onPressed: null, icon: Icon(Icons.save_alt)),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        widget.snap['description'] != ""
            ? Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color:
                                    DefaultTextStyle.of(context).style.color),
                            children: [
                              TextSpan(
                                  text: widget.snap['username'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              TextSpan(text: '  ${widget.snap['description']}')
                            ]),
                      )),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              )
            : Container(),
        Container(
          padding: const EdgeInsets.only(left: 16, bottom: 12),
          child: Text(
            DateFormat.yMMMd()
                .add_Hms()
                .format(widget.snap['datePublished'].toDate()),
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        // const Divider(
        //   thickness: 1,
        //   height: 0,
        // )
      ],
    );
  }
}
