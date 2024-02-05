import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:istagrammo/models/post.dart';
import 'package:istagrammo/resources/firestore_methods.dart';
import 'package:istagrammo/widgets/post_card.dart';

class PostThumb extends StatelessWidget {
  PostThumb(
      {super.key,
      required this.snap,
      required this.isCurrentUser,
      required this.index});

  Post snap;
  bool isCurrentUser;
  int index;

  int stimatedPostCardSize = 495;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Widget postPage = Scaffold(
        appBar: AppBar(
          title: isCurrentUser
              ? const Text('I miei posts')
              : Text('Posts di ${snap.username}'),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(FirestoreMethods.postsCollection)
                // .doc(snap.postId.toString())
                .where('uid', isEqualTo: snap.uid)
                .orderBy('datePublished', descending: true)
                .where('isTwitt', isEqualTo: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // dopo che carica tutto lo stream builder fa lo scroll
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  _scrollController
                      .jumpTo((index * stimatedPostCardSize).toDouble());
                });

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return PostCard(snap: snapshot.data!.docs[index].data());
                  },
                );
              }

              return const CircularProgressIndicator();
            }));

    return InkWell(
      onTap: () async {
        await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => postPage));
      },
      child: Image.network(
        snap.postUrl,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Text('Impossibile caricare il post'),
          );
        },
        fit: BoxFit.cover,
      ),
    );
  }
}
