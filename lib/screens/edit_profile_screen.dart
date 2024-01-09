// ignore_for_file: file_names, prefer_const_constructors, camel_case_types

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_app_cool/models/user.dart';

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

  Future saveData() async {
    String newName = _nameController.text;
    String newBio = _bioController.text;

    if (changedProfilePic) {
      // TODO change user profile pic
      // await api.UserApi.setProfilePic(
      //     currentUser: currentUser, profilePic: newProfilePicFile);
    }

    // TODO aggiornare profilo utente in generale

    // return await api.UserApi.modifyUserProfile(
    //     currentUser: currentUser, newUsername: newName, newBio: newBio);

    //return to profile page
  }

  // late ImageProvider finalImg;
  // late XFile newProfilePicFile;

  Uint8List? file;

  bool changedProfilePic = false;

  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<Uint8List?> _getImageFromGallery() async {
    XFile? pickedFile =
        (await ImagePicker().pickImage(source: ImageSource.gallery));

    if (pickedFile != null) {
      return pickedFile.readAsBytes();
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO
    _nameController.text = widget.myUser.username;
    _bioController.text = widget.myUser.bio;

    // if (!changedProfilePic) {
    //   finalImg = NetworkImage(currentUser.profileImgUrl);
    // }

    return Scaffold(
      appBar: AppBar(
        //remove arrow back
        // automaticallyImplyLeading: false,
        elevation: 1,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Modifica profilo'),
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
                    Form(
                      key: _formKey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          changedProfilePic
                              ? CircleAvatar(
                                  radius: 40,
                                  backgroundImage: MemoryImage(file!),
                                )
                              : CircleAvatar(
                                  radius: 40,
                                  backgroundImage:
                                      NetworkImage(widget.myUser.profileImgUrl),
                                ),
                          ElevatedButton(
                              onPressed: () async {
                                file = await _getImageFromGallery();
                                if (file != null) {
                                  setState(() {
                                    changedProfilePic = true;
                                    // print('ktm');
                                  });
                                }
                              },
                              child: Text('Modifica'))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserire username';
                        }
                        return null;
                      },
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      // maxLines: 4,
                      controller: _bioController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Bio',
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton.icon(
                        onPressed: () async {

                          if(_formKey.currentState!.validate()){

                          }

                          // mostrare il dialog

                          // var confirm = await twoButtonDialog(
                          //     context, 'La modifica comporterà il logout');

                          // if (confirm) {
                          //   // logout
                          //   if (await saveData() == 200) {
                          //     await logout(context);
                          //   }
                          // } else {
                          //   Navigator.pushReplacementNamed(context, '/profile');
                          // }
                        },
                        icon: Icon(Icons.check),
                        label: Text('Salva')),
                    SizedBox(
                      height: 60,
                    ),
                    Text('La modifica dei dati richiederà il logout*')
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
