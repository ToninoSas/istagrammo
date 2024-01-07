// ignore_for_file: file_names, prefer_const_constructors, camel_case_types

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_app/providers/app_state.dart';

import 'package:instagram_app/utils/api.dart' as api;
import 'package:provider/provider.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  static const String pageRoute = '/upload_post';

  @override
  State<UploadPostPage> createState() => _UploadPostPage_State();
}

class _UploadPostPage_State extends State<UploadPostPage> {
  TextEditingController _postDescrController = TextEditingController();
  late XFile imageToUpload;

  bool uploaded = false;

  saveData() async {
    //save new data
    // TODO
    // await api.PostApi.uploadPost(
    //     currentUser: Provider.of<UserProvider>(context, listen: false)
    //         .userProfile,
    //     post: imageToUpload,
    //     descr: _postDescrController.text);
  }

  _getImageFromGallery() async {
    XFile? pickedFile =
        (await ImagePicker().pickImage(source: ImageSource.gallery));

    if (pickedFile != null) {
      return pickedFile;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Carica un post'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              imageToUpload = await _getImageFromGallery();
                              setState(() {
                                uploaded = true;
                              });
                            },
                            child: Text(uploaded
                                ? 'Immagine selezionata'
                                : 'Seleziona immagine')),
                        Text(uploaded ? imageToUpload.path : ''),
                        uploaded
                            ? Image.file(
                                File(imageToUpload.path),
                                width: 200,
                                height: 200,
                              )
                            : Container()
                      ],
                    ),
                    TextField(
                      controller: _postDescrController,
                      decoration: InputDecoration(
                        labelText: 'Inserire descrizione',
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton.icon(
                        onPressed: () {
                          saveData();
                          Navigator.pushReplacementNamed(context, '/profile')
                              .then((value) => setState(() {}));
                        },
                        icon: Icon(Icons.check),
                        label: Text('Salva'))
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
