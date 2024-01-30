import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app_cool/models/post.dart';
import 'package:instagram_app_cool/resources/firestore_methods.dart';
import 'package:instagram_app_cool/utils/utils.dart';
import 'package:instagram_app_cool/widgets/post_card.dart';

class PostThumb extends StatelessWidget {
  PostThumb({super.key, required this.snap, required this.isCurrentUser});

  Post snap;
  bool isCurrentUser;

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
                .collection('posts')
                // .doc(snap.postId.toString())
                .where('uid', isEqualTo: snap.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return PostCard(snap: snapshot.data!.docs[index].data());
                  },
                );
              }

              return const CircularProgressIndicator();
            }));
            
    return InkWell(
      onTap: () {
        Navigator.of(context)
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
