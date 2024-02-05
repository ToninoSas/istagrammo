// ignore_for_file: file_names, prefer_const_constructors, camel_case_types

import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:istagrammo/models/user.dart';
import 'package:istagrammo/resources/firestore_methods.dart';
import 'package:istagrammo/resources/storage_methods.dart';
import 'package:istagrammo/utils/styles.dart';
import 'package:istagrammo/utils/utils.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key, required this.myUser});

  MyUser myUser;
  static const String pageRoute = '/edit_profile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreen_State();
}

class _EditProfileScreen_State extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  Uint8List? file;

  bool changedProfilePic = false, resettedProfilePic = false;

  final GlobalKey<FormState> _formKey = GlobalKey();

  Future saveData() async {
    String newName = _nameController.text.trim();
    String newBio = _bioController.text.trim();
    String? profileImgUrl;

    if (changedProfilePic) {
      profileImgUrl = await StorageMethods().uploadProfilePic(file!);
    }

    if (resettedProfilePic) {
      profileImgUrl = defaultProfileImg;
    }

    String err = await FirestoreMethods().editProfile(
        username: newName, bio: newBio, profileImgUrl: profileImgUrl);

    return err;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.myUser.profileImgUrl == defaultProfileImg
        ? resettedProfilePic = true
        : resettedProfilePic = false;
  }

  @override
  Widget build(BuildContext context) {
    //TODO
    _nameController.text = widget.myUser.username;
    _bioController.text = widget.myUser.bio;

    return Scaffold(
      appBar: AppBar(
        //remove arrow back
        // automaticallyImplyLeading: false,
        elevation: 1,
        // backgroundColor: Theme.of(context).primaryColor,
        title: Text('Modifica profilo'),
      ),
      body: SingleChildScrollView(
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
                        Stack(
                          children: [
                            if (resettedProfilePic)
                              CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    NetworkImage(defaultProfileImg),
                              )
                            else
                              changedProfilePic
                                  ? CircleAvatar(
                                      radius: 40,
                                      backgroundImage: MemoryImage(file!),
                                    )
                                  : CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(
                                          widget.myUser.profileImgUrl),
                                    ),
                            if (resettedProfilePic == false)
                              Positioned(
                                bottom: -10,
                                left: -10,
                                child: IconButton(
                                  tooltip: 'Rimuovi immagine',
                                  onPressed: () {
                                    setState(() {
                                      resettedProfilePic = true;
                                      changedProfilePic = false;
                                      file = null;
                                    });
                                  },
                                  icon: const Icon(Icons.cancel),
                                ),
                              )
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              file = await getImageFromGallery();
                              if (file != null) {
                                setState(() {
                                  changedProfilePic = true;
                                  resettedProfilePic = false;
                                });
                              }
                            },
                            child: Text('Modifica'))
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      enabled: false,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Inserire username';
                        }
                        return null;
                      },
                      controller: _nameController,
                      decoration: textFieldDecoration(label: 'Username'),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      // maxLines: 4,
                      controller: _bioController,
                      decoration: textFieldDecoration(label: 'Bio'),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton.icon(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            saveData().then((err) {
                              if (err != "") {
                                showSnackBar(context, err);
                              } else {
                                showSnackBar(context, 'modifica effettuata');

                                // torno alla pagina del profilo dopo aver caricato il post
                                Navigator.of(context).pop();
                              }
                            });
                          }
                        },
                        icon: Icon(Icons.check),
                        label: Text('Salva')),
                    SizedBox(
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
