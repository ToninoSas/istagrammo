// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:istagrammo/models/user.dart';
import 'package:istagrammo/providers/user_provider.dart';
import 'package:istagrammo/resources/firestore_methods.dart';
import 'package:istagrammo/utils/styles.dart';
import 'package:istagrammo/utils/utils.dart';
import 'package:istagrammo/widgets/comment_card.dart';
import 'package:istagrammo/widgets/twitt_card.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  CommentsScreen({super.key, required this.snap});

  final snap;

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MyUser user = Provider.of<UserProvider>(context).myUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Commenti'),
      ),
      body: Column(
        children: [
          // widget.snap['isTwitt']
          //     ?
          if (widget.snap['isTwitt'])
            TwittCard(
              snap: widget.snap,
              disableActions: true,
            ),
          // : PostCard(snap: widget.snap),
          const Divider(),
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(FirestoreMethods.postsCollection)
                .doc(widget.snap['postId'])
                .collection('comments')
                .orderBy('nLikes', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Text('${snapshot.data!.docs.length.toString()} commenti'),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return CommentCard(
                            snap: snapshot.data!.docs[index].data(),
                          );
                        },
                        itemCount: snapshot.data!.docs.length,
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ))
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration:
              BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
          // viewInsets contiene informazioni sugli spazi riservati per gli elementi sovrapposti, come la tastiera.
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onFieldSubmitted: (value) async {
                      if (_formKey.currentState!.validate()) {
                        String msg = await FirestoreMethods().addComment(
                            username: user.username,
                            profileImgUrl: user.profileImgUrl,
                            text: _commentController.text,
                            postId: widget.snap['postId'],
                            uid: user.uid);

                        if (msg != "") {
                          showSnackBar(context, msg);
                        }

                        _commentController.clear();
                      }
                    },
                    controller: _commentController,
                    // TODO APPLICARE L'UNFOCUS A TUTTI I TEXT FIELD
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    decoration:
                        textFieldDecoration(label: 'Testo del commento'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Inserire del testo';
                      }
                      return null;
                    },
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String msg = await FirestoreMethods().addComment(
                            username: user.username,
                            profileImgUrl: user.profileImgUrl,
                            text: _commentController.text,
                            postId: widget.snap['postId'],
                            uid: user.uid);

                        if (msg != "") {
                          showSnackBar(context, msg);
                        }
                        _commentController.clear();
                      }
                    },
                    icon: const Icon(Icons.send))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
