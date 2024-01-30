import 'package:flutter/material.dart';
import 'package:instagram_app_cool/models/user.dart';
import 'package:instagram_app_cool/providers/user_provider.dart';
import 'package:instagram_app_cool/resources/firestore_methods.dart';
import 'package:instagram_app_cool/utils/utils.dart';
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
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(widget.snap['profileImgUrl']),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    widget.snap['username'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
              if (user.uid == widget.snap['uid'].toString())
                IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                              child: InkWell(
                            onTap: () async {
                              String msg = await FirestoreMethods()
                                  .deletePost(widget.snap['postId']);
                              if (context.mounted) {
                                Navigator.of(context).pop();

                                if (msg != "") {
                                  showSnackBar(context, msg);
                                } else {
                                  showSnackBar(context, 'Post eliminato');
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: const Text(
                                'Elimina post',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ));
                        },
                      );
                    },
                    icon: const Icon(Icons.more_vert_outlined))
            ],
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
            child: Image.network(
              widget.snap['postUrl'],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text('Impossibile caricare l\'immagine'));
              },
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
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
                        Text('${widget.snap['likes'].length}')
                      ],
                    ),
                    const IconButton(
                        onPressed: null, icon: Icon(Icons.comment)),
                    const IconButton(onPressed: null, icon: Icon(Icons.share)),
                  ],
                ),
                const IconButton(onPressed: null, icon: Icon(Icons.save_alt)),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.snap['description'] != ""
                ? [
                    const Text(
                      'Descrizione: ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Text(
                        '${widget.snap['description']}',
                        // 'sono sono sono sono sono sono osno sono ksk ks jsjsoso jsjsj sono sono sono sono sono sono osno sono ksk ks jsjsoso jsjsjsono sono sono sono sono sono osno sono ksk ks jsjsoso jsjsj',
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 15),
                      ),
                    )
                  ]
                : [Container()],
          ),
        )
      ],
    );
  }
}
