// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:instagram_app_cool/models/user.dart';
import 'package:instagram_app_cool/resources/firestore_methods.dart';
import 'package:instagram_app_cool/utils/styles.dart';
import 'package:instagram_app_cool/utils/utils.dart';

class UploadPostScreen extends StatefulWidget {
  UploadPostScreen({super.key, this.myUser});

  // static String pageRouteName = '/upload';
  MyUser? myUser;

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  Uint8List? post;
  bool _hasSelectedPost = false, _isLoading = false;
  final TextEditingController _postBioController = TextEditingController();

  caricaPost({required Uint8List file, String? postBio}) async {
    setState(() {
      _isLoading = true;
    });

    String msg = await FirestoreMethods().newPost(
        uid: widget.myUser!.uid,
        username: widget.myUser!.username,
        description: postBio ?? "",
        profileImgUrl: widget.myUser!.profileImgUrl,
        file: file);

    setState(() {
      _isLoading = false;
    });

    if (msg != "") {
      if (context.mounted) {
        showSnackBar(context, msg);
      }
    } else {
      if (context.mounted) {
        showSnackBar(context, 'Post caricato');

        // torno alla pagina del profilo dopo aver caricato il post
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload post'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Theme.of(context).cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(36.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: _hasSelectedPost
                                  ? Image(image: MemoryImage(post!))
                                  : const Text('Nessun post selezionato'),
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  post = await getImageFromGallery();
                                  if (post != null) {
                                    setState(() {
                                      _hasSelectedPost = true;
                                    });
                                  }
                                },
                                child: const Text('Seleziona immagine'))
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: _postBioController,
                          decoration:
                              textFieldDecoration(label: 'Bio del post'),
                        ),
                        const SizedBox(
                          height: 30,
                        ),

                        ElevatedButton.icon(
                            onPressed: _hasSelectedPost
                                ? () async {
                                    caricaPost(
                                        file: post!,
                                        postBio: _postBioController.text);
                                  }
                                : null,
                            icon: const Icon(Icons.upload),
                            label: const Text('Carica')),
                        const SizedBox(
                          height: 60,
                        ),
                        // Text('La modifica dei dati richiederà il logout*')
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
