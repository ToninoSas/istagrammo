// ignore_for_file: file_names, prefer_const_constructors, camel_case_types

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_app/dialogs/one_button_dialog.dart';
import 'package:instagram_app/models/user.dart';
import 'package:instagram_app/providers/user_provider.dart';

import 'package:instagram_app/utils/api.dart' as api;
import 'package:instagram_app/utils/func.dart';
import 'package:instagram_app/widgets/circle_box_widget.dart';
import 'package:provider/provider.dart';

class ModifyProfilePage extends StatefulWidget {
  const ModifyProfilePage({super.key});

  static const String pageRoute = '/modify_profile';

  @override
  State<ModifyProfilePage> createState() => _ModifyProfilePage_State();
}

class _ModifyProfilePage_State extends State<ModifyProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  Future<int> saveData(AuthUser currentUser) async {
    String newName = _nameController.text;
    String newBio = _bioController.text;

    if (changedProfilePic) {
      await api.UserApi.setProfilePic(
          currentUser: currentUser, profilePic: newProfilePicFile);
    }

    return await api.UserApi.modifyUserProfile(
        currentUser: currentUser, newUsername: newName, newBio: newBio);

    //return to profile page
  }

  logout(context) async {
    AuthUser userProfile =
        Provider.of<UserProvider>(context, listen: false).userProfile;
    await LocalStorage.logout();
    await api.Auth.logout(userProfile.apiKey);

    Navigator.pushReplacementNamed(context, '/login');
  }

  late ImageProvider finalImg;
  late XFile newProfilePicFile;
  bool changedProfilePic = false;

  _getImageFromGallery() async {
    XFile? pickedFile =
        (await ImagePicker().pickImage(source: ImageSource.gallery));

    if (pickedFile != null) {
      return pickedFile;
    }
  }

  @override
  Widget build(BuildContext context) {

    AuthUser currentUser = Provider.of<UserProvider>(context).userProfile;
    _nameController.text = currentUser.username;
    _bioController.text = currentUser.bio;

    if (!changedProfilePic) {
      finalImg = NetworkImage(currentUser.profileImgUrl);
    }

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleBox(
                          imageProvider: finalImg,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              newProfilePicFile = await _getImageFromGallery();
                              Image newProfilePicImage =
                                  Image.file(File(newProfilePicFile.path));

                              setState(() {
                                finalImg = newProfilePicImage.image;
                                changedProfilePic = true;
                                // print('ktm');
                              });

                              print(finalImg.toString());
                            },
                            child: Text('Modifica'))
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Inserire nome',
                      ),
                    ),
                    TextField(
                      // maxLines: 4,
                      controller: _bioController,
                      decoration: InputDecoration(
                        labelText: 'Inserire descrizione',
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton.icon(
                        onPressed: () async {
                          // mostrare il dialog

                          var confirm = await twoButtonDialog(
                              context, 'La modifica comporterà il logout');

                          if (confirm) {
                            // logout
                            if(await saveData(currentUser) == 200) {
                              await logout(context);
                            }
                          } else {
                            Navigator.pushReplacementNamed(context, '/profile');
                          }
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
