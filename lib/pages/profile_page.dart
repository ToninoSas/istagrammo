// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:instagram_app/providers/user_data_service_provider.dart';
import 'package:instagram_app/models/user.dart';
import 'package:instagram_app/utils/api.dart' as api;

import 'package:instagram_app/widgets/circle_box_widget.dart';
import 'package:instagram_app/widgets/bottom_navbar_widget.dart';
import 'package:instagram_app/utils/func.dart';
import 'package:instagram_app/widgets/post_widget.dart';
import 'package:instagram_app/widgets/user_profile_post_widget.dart';

class ProfilePage extends StatefulWidget {
  // const ProfilePage({super.key, required this.username});

  static const String pageRoute = '/profile';

  const ProfilePage({super.key});

  // final String username;

  @override
  State<ProfilePage> createState() => _ProfilePage_State();
}

class _ProfilePage_State extends State<ProfilePage> {
  int selectedIndex = routes['profile']!;

  // String username = "", email = "", descr = "", apiKey = "";
  // int nPosts = 0;

  late User userProfile;

  getUserData(context) async {
    // return await LocalStorage.getUserData();

    String username = (await LocalStorage.getUserData())!.username;
    String apiKey = await LocalStorage.getApiKey();

    userProfile = User.fromJsonMap(await api.UserApi.userProfile(username));
    userProfile.apiKey = apiKey;

    final userPosts = await api.UserApi.getUserPosts(username);
    userProfile.posts = userPosts;

    // print(userProfile.toJsonString());

    // aggiorno i dati dell'user al livello MAIN
    UserDataServiceProvider.of(context).update(userProfile);
  }

  @override
  Widget build(BuildContext context) {
    // User userProfile = UserDataServiceProvider.of(context).userData;

    // final  Map<String, Object>rcvdData = Navigator.of(context).settings.arguments;
    // getUserData();

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
                  title: Text(userProfile.username),
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
                      // profile stats
                      Column(
                        children: [
                          Row(children: [
                            Expanded(
                              flex: 1,
                              child: CircleBox(
                                imageProvider:
                                    NetworkImage(userProfile.profileImgUrl),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text(userProfile.nPosts.toString()),
                                    Text('post')
                                  ],
                                )),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text(userProfile.nFollowers.toString()),
                                    Text('follower')
                                  ],
                                )),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text(userProfile.nSeguiti.toString()),
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
                                  userProfile.descr,
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
                                          modifyProfile(context);
                                        },
                                        child: Text('Modifica profilo'))),
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
                          ),
                        ],
                      ),
                      // posts
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 1,
                                    mainAxisSpacing: 1),
                            itemCount: userProfile.nPosts,
                            itemBuilder: (context, index) {
                              return UserProfilePost(
                                  postJson: userProfile.posts[index], username: userProfile.username,);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                bottomNavigationBar: BottomNavBar(
                  selectedIndex: selectedIndex,
                ),
                drawer: Drawer(
                  child: ListView(
                    children: [
                      UserAccountsDrawerHeader(
                        accountName: Text(userProfile.username),
                        accountEmail: Text(userProfile.email),
                        currentAccountPicture: CircleAvatar(
                            backgroundImage: AssetImage('images/img1.jpg')),
                        arrowColor: Colors.black,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          // border: Border(
                          //   bottom: BorderSide(color: Colors.black)
                          // ),
                        ),
                      ),
                      ListTile(
                        title: Text(userProfile.username),
                        leading: Icon(Icons.person),
                        subtitle: Text("username"),
                        onTap: () {},
                      ),
                      ListTile(
                        title: Text(userProfile.email),
                        leading: Icon(Icons.email),
                        subtitle: Text("email"),
                        onTap: () {},
                        // horizontalTitleGap: 16,
                      ),
                      ListTile(
                        title: Text('Settings'),
                        leading: Icon(Icons.settings),
                      ),
                      ListTile(
                        title: Text(userProfile.apiKey),
                        subtitle: Text("Api Key"),
                        leading: Icon(Icons.key),
                      ),
                      ListTile(
                        title: Text('Logout'),
                        leading: Icon(Icons.logout),
                        onTap: () {
                          LocalStorage.logout();

                          Navigator.pushReplacementNamed(context, '/login');

                          // TODO logout api
                        },
                      )
                    ],
                  ),
                ),
              );
          }
        });
  }
}
