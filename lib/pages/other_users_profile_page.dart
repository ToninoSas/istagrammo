// ignore_for_file: file_names, prefer_const_constructors, avoid_print
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:instagram_app/dialogs/one_button_dialog.dart';
import 'package:instagram_app/providers/user_data_service_provider.dart';

import 'package:instagram_app/utils/api.dart' as api;
import 'package:instagram_app/models/user.dart';

import 'package:instagram_app/widgets/circle_box_widget.dart';

class OtherUserProfilePage extends StatefulWidget {
  // const ProfilePage({super.key, required this.username});

  // static const String pageRoute = '/other_profiles';

  const OtherUserProfilePage({super.key, required this.username});

  final String username;
  // final User currentUser;

  @override
  State<OtherUserProfilePage> createState() => _OtherUserProfilePage_State();
}

class _OtherUserProfilePage_State extends State<OtherUserProfilePage> {
  late OtherUser otherUser;
  // late User currentUser;

  // controllare che l'utente sia gia nei seguiti
  String segui = 'Segui';
  bool hasFollow = false;

  getUserData(context) async {
    // prendo il profilo dell'utente
    otherUser = OtherUser.fromJsonMap(await api.UserApi.userProfile(widget.username));
    // profilo utente corrente
    User currentUser = UserDataServiceProvider.of(context).userData;

    // prendo i follower dell utente
    var otherUserFollowers = await api.UserApi.getUserFollowers(otherUser.username);

    // se tra i follower trovo l'utente corrente
    for (var user in otherUserFollowers) {
      if (user['username'] == currentUser.username) {
        // other user has already follow
        hasFollow = true;
      }
    }
  }

  followUser(context, usernameToFollow, User currentUser) async {
    print("api key ${currentUser.apiKey}");

    var response = await api.UserApi.followUser(usernameToFollow, currentUser);

    String error = response['error'];

    if (error == "") {
      setState(() {
        hasFollow = true;
      });

      followDialog(context, 'Ora segui ${widget.username}!');

      // UserDataServiceProvider.of(context).userData.nFollowers++;
    }
  }

  removeFollowUser(context, usernameToFollow, User currentUser) async {
    var response = await api.UserApi.removeFollowUser(usernameToFollow, currentUser);

    String error = response['error'];

    if (error == "") {
      setState(() {
        hasFollow = false;
      });

      followDialog(context, 'Ora non segui più ${widget.username}!');

      // UserDataServiceProvider.of(context).userData.nFollowers--;

    }
  }

  @override
  Widget build(BuildContext context) {
    // final user = ModalRoute.of(context)?.settings.arguments;

    User currentUser = UserDataServiceProvider.of(context).userData;

    return FutureBuilder(
        future: getUserData(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                child: Text('You are getting nothing'),
              );
            case ConnectionState.active:
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(
                  child: Text('error ${snapshot.error}'),
                );
              }

              return Scaffold(
                appBar: AppBar(
                  //remove arrow back
                  // automaticallyImplyLeading: false,
                  elevation: 0,
                  backgroundColor: Theme.of(context).primaryColor,
                  title: Text(otherUser.username),
                  actions: [
                    IconButton(
                        onPressed: () => {},
                        icon: const Icon(Icons.add_a_photo_rounded)),
                    // IconButton(onPressed: () => {}, icon: const Icon(Icons.menu))
                  ],
                ),
                body: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                          flex: 1,
                          child: CircleBox(
                            imageProvider:
                                NetworkImage(otherUser.profileImgUrl),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Text(otherUser.nPosts.toString()),
                                Text('post')
                              ],
                            )),
                        Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Text(otherUser.nFollowers.toString()),
                                Text('follower')
                              ],
                            )),
                        Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Text(otherUser.nSeguiti.toString()),
                                Text('seguiti')
                              ],
                            )),
                      ]),
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(2),
                            child: Text(
                              otherUser.descr,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      print(hasFollow);

                                      hasFollow
                                          ? removeFollowUser(context,
                                              otherUser.username, currentUser)
                                          : followUser(context,
                                              otherUser.username, currentUser);
                                    },
                                    child: Text(hasFollow
                                        ? 'Non seguire più'
                                        : 'Segui'))),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ElevatedButton(
                                    onPressed: () => {},
                                    child: Text('Condividi profilo'))),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
          }
        });
  }
}
