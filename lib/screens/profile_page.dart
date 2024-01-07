// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:instagram_app/methods/auth_methods.dart';
import 'package:instagram_app/models/user.dart';
import 'package:instagram_app/providers/app_state.dart';

import 'package:instagram_app/widgets/circle_box_widget.dart';
import 'package:instagram_app/widgets/bottom_navbar_widget.dart';
import 'package:instagram_app/utils/func.dart';
import 'package:instagram_app/widgets/user_profile_drower_widget.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        MyUser user = userProvider.getUser;

        return Scaffold(
            appBar: AppBar(
              elevation: 0,
              // backgroundColor: Theme.of(context).primaryColor,
              title: Text(user.username),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/upload_post');
                    },
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
                            imageProvider: NetworkImage(user.profileImgUrl),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Text(user.posts.length.toString()),
                                Text('post')
                              ],
                            )),
                        Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //   builder: (context) =>
                                //       FollowersPage(user: appState.currentUser),
                                // ));
                              },
                              child: Column(
                                children: [
                                  Text(user.followers.length.toString()),
                                  Text('follower')
                                ],
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //   builder: (context) =>
                                //       FollowedPage(user: appState.currentUser),
                                // ));
                              },
                              child: Column(
                                children: [
                                  Text(user.followed.length.toString()),
                                  Text('seguiti')
                                ],
                              ),
                            )),
                      ]),
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.all(2),
                            child: Text(
                              user.bio,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          SizedBox(
                            height: 10,
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
                  // Flexible(
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(top: 16),
                  //     child: GridView.builder(
                  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //           crossAxisCount: 3,
                  //           crossAxisSpacing: 1,
                  //           mainAxisSpacing: 1),
                  //       itemCount: appState.currentUser.nPosts,
                  //       itemBuilder: (context, index) {
                  //         return UserProfilePostThumb(
                  //           postInfo: appState.currentUser.posts[index],
                  //           owner: appState.currentUser,
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            bottomNavigationBar: BottomNavBar(
              selectedIndex: selectedIndex,
            ),
            drawer: UserProfileDrower());
      },
    );
  }
}
