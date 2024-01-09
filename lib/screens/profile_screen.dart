// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:instagram_app_cool/models/user.dart';
import 'package:instagram_app_cool/resources/auth_methods.dart';
import 'package:instagram_app_cool/screens/edit_profile_screen.dart';
import 'package:instagram_app_cool/widgets/bottom_navbar.dart';
import 'package:instagram_app_cool/widgets/user_profile_drawer.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  static const pageRouteName = '/profile';
  int selectedIndex = 2;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  MyUser? myUser;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  getData() {
    setState(() {
      isLoading = true;
    });

    AuthMethods().getUserData().then((value) {
      setState(() {
        myUser = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              title: Text(myUser!.username),
            ),
            body: Padding(
              padding: EdgeInsets.all(24),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      // image user
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(myUser!.profileImgUrl),
                      ),
                    ),
                    Column(
                      children: [
                        Text(myUser!.posts.length.toString()),
                        Text('post')
                      ],
                      // posts
                    ),
                    Column(children: [
                      Text(myUser!.followers.length.toString()),
                      Text('follower')
                    ]),
                    Column(
                      children: [
                        Text(myUser!.followed.length.toString()),
                        Text('seguiti')
                      ],
                      // seguiti
                    )
                  ],
                ),
                Container(
                  child: Text(myUser!.bio),
                  // bio
                ),
                Row(
                  // direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    EditProfileScreen(myUser: myUser!),
                              ));
                            },
                            child: Text('Modifica profilo'))),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {}, child: Text('Condividi profilo')),
                    )
                  ],
                )
              ]),
            ),
            drawer: UserProfileDrower(user: myUser!),
            bottomNavigationBar:
                BottomNavBar(selectedIndex: widget.selectedIndex),
          );
  }
}
