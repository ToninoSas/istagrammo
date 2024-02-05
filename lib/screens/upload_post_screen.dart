// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:istagrammo/models/user.dart';
import 'package:istagrammo/resources/firestore_methods.dart';
import 'package:istagrammo/utils/utils.dart';

class UploadPostScreen extends StatefulWidget {
  UploadPostScreen({super.key, this.myUser, this.isTwitt = false});

  // static String pageRouteName = '/upload';
  MyUser? myUser;
  bool? isTwitt = false;

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  Uint8List? post;
  bool _hasSelectedPost = false, _isLoading = false;
  final TextEditingController _postBioController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey();

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

  caricaTwitt({required String postBio}) async {
    setState(() {
      _isLoading = true;
    });

    String msg = await FirestoreMethods().newTwitt(
      uid: widget.myUser!.uid,
      username: widget.myUser!.username,
      description: postBio,
      profileImgUrl: widget.myUser!.profileImgUrl,
    );

    setState(() {
      _isLoading = false;
    });

    if (msg != "") {
      if (context.mounted) {
        showSnackBar(context, msg);
      }
    } else {
      if (context.mounted) {
        showSnackBar(context, 'Twitt caricato');

        // torno alla pagina del profilo dopo aver caricato il post
        Navigator.of(context).pop();
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isTwitt! ? 'Upload twitt' : 'Upload post'),
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              if (!widget.isTwitt!)
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: _hasSelectedPost
                                      ? Image(image: MemoryImage(post!))
                                      : const Text('Nessun post selezionato'),
                                ),
                              if (!widget.isTwitt!)
                                ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SimpleDialog(
                                              contentPadding: EdgeInsets.only(
                                                  top: 16, bottom: 8),
                                              title: Text('Scegli la fonte'),
                                              children: [
                                                SimpleDialogOption(
                                                  onPressed: () async {
                                                    Navigator.of(context).pop();
                                                    post =
                                                        await getImageFromGallery();
                                                    if (post != null) {
                                                      setState(() {
                                                        _hasSelectedPost = true;
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(8),
                                                    child: Text(
                                                      'Galleria',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                                SimpleDialogOption(
                                                  onPressed: () async {
                                                    Navigator.of(context).pop();
                                                    post =
                                                        await getImageFromCamera();
                                                    if (post != null) {
                                                      setState(() {
                                                        _hasSelectedPost = true;
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(8),
                                                    child: Text(
                                                      'Fotocamera',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: const Text('Seleziona immagine'))
                            ],
                          ),
                          // if (widget.isTwitt!)
                          //   TextFormField(
                          //     controller: _twittTitleController,
                          //     decoration: textFieldDecoration(
                          //         label: 'Titolo del twitt'),
                          //     validator: (value) {
                          //       if (value == null || value.trim().isEmpty) {
                          //         return 'Titolo twitt obbligatorio';
                          //       }
                          //       return null;
                          //     },
                          //   ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: _postBioController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            minLines: 4,
                            decoration: InputDecoration(
                                label: Text(widget.isTwitt!
                                    ? 'Testo del twitt'
                                    : 'Bio del post'),
                                border: OutlineInputBorder()),
                            // decoration: textFieldDecoration(
                            //     label: widget.isTwitt!
                            //         ? 'Testo del twitt'
                            //         : 'Bio del post'),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          widget.isTwitt!
                              ? ElevatedButton.icon(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      caricaTwitt(
                                          postBio: _postBioController.text);
                                    }
                                  },
                                  icon: const Icon(Icons.upload),
                                  label: const Text('Carica'))
                              : ElevatedButton.icon(
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
            ),
    );
  }
}
