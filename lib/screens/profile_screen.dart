// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instagram_app_cool/models/post.dart';
import 'package:instagram_app_cool/models/user.dart';
import 'package:instagram_app_cool/providers/user_provider.dart';
import 'package:instagram_app_cool/resources/auth_methods.dart';
import 'package:instagram_app_cool/resources/firestore_methods.dart';
import 'package:instagram_app_cool/screens/edit_profile_screen.dart';
import 'package:instagram_app_cool/screens/search_screen.dart';
import 'package:instagram_app_cool/screens/upload_post_screen.dart';
import 'package:instagram_app_cool/widgets/post_thumb.dart';
import 'package:instagram_app_cool/widgets/user_profile_drawer.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key, required this.uid});

  String uid;
  static const pageRouteName = '/profile';
  int selectedIndex = 2;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  MyUser? myUser;

  bool isLoading = false, _isCurrentUser = true;

  int nPosts = 0, nFollowers = 0, nFollowed = 0;
  bool isFollowing = false;

  getData() async {
    setState(() {
      isLoading = true;
    });

    if (widget.uid != FirebaseAuth.instance.currentUser!.uid) {
      _isCurrentUser = false;

      final snap = await FirebaseFirestore.instance
          .collection('utenti')
          .doc(widget.uid)
          .get();

      myUser = MyUser.fromSnap(snap);

      final postsSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();

      for (var post in postsSnap.docs) {
        myUser!.posts.add(Post.fromSnap(post));
      }
    } else {
      // è l'user corrente
      myUser = Provider.of<UserProvider>(context).myUser;
    }

    nFollowed = myUser!.followed.length;
    nFollowers = myUser!.followers.length;
    nPosts = myUser!.posts.length;

    isFollowing =
        myUser!.followers.contains(FirebaseAuth.instance.currentUser!.uid);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getData();
    print('changed dependencies');
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
            // bottomNavigationBar:
            //     BottomNavBar(selectedIndex: widget.selectedIndex),
          )
        : Scaffold(
            appBar: AppBar(
              // backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              title: Text(myUser!.username),
              actions: [
                IconButton(
                    onPressed: () {
                      // Navigator.of(context).pushReplacementNamed('/upload');
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UploadPostScreen(
                          myUser: myUser,
                        ),
                      ));
                    },
                    icon: Icon(Icons.add_a_photo))
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 40,
                            backgroundImage:
                                NetworkImage(myUser!.profileImgUrl),
                          ),
                          Column(
                            children: [Text(nPosts.toString()), Text('post')],
                            // posts
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SearchScreen(
                                  isFollowersPage: true,
                                  uid: myUser!.uid,
                                ),
                              ));
                            },
                            child: Column(children: [
                              Text(nFollowers.toString()),
                              Text('follower')
                            ]),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SearchScreen(
                                  isFollowedPage: true,
                                  uid: myUser!.uid,
                                ),
                              ));
                            },
                            child: Column(
                              children: [
                                Text(nFollowed.toString()),
                                Text('seguiti')
                              ],
                              // seguiti
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(myUser!.bio),
                    ),
                    Row(
                      // direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isCurrentUser)
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          EditProfileScreen(myUser: myUser!),
                                    ));
                                  },
                                  child: Text('Modifica profilo')))
                        else
                          Expanded(
                              child: isFollowing
                                  ? ElevatedButton(
                                      onPressed: () async {
                                        await FirestoreMethods().followUser(
                                            currentUid: FirebaseAuth
                                                .instance.currentUser!.uid,
                                            receiveUid: myUser!.uid,
                                            followers: myUser!.followers);

                                        setState(() {
                                          isFollowing = false;
                                          nFollowers--;
                                        });
                                      },
                                      child: Text('Non seguire più'))
                                  : ElevatedButton(
                                      onPressed: () async {
                                        await FirestoreMethods().followUser(
                                            currentUid: FirebaseAuth
                                                .instance.currentUser!.uid,
                                            receiveUid: myUser!.uid,
                                            followers: myUser!.followers);

                                        setState(() {
                                          isFollowing = true;
                                          nFollowers++;
                                        });
                                      },
                                      child: Text('Segui profilo'))),
                        SizedBox(
                          width: 10,
                        ),
                        // Expanded(
                        //   child: ElevatedButton(
                        //       onPressed: null,
                        //       child: Text('Condividi profilo')),
                        // )
                      ],
                    ),
                    Divider(),
                    isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5),
                              itemCount: myUser!.posts.length,
                              itemBuilder: (context, index) {
                                return PostThumb(
                                  snap: myUser!.posts[index],
                                  isCurrentUser: _isCurrentUser,
                                );
                              },
                            ),
                          )
                  ]),
            ),
            drawer: _isCurrentUser ? UserProfileDrower() : null,
            // bottomNavigationBar: _isCurrentUser
            //     ? BottomNavBar(selectedIndex: widget.selectedIndex)
            //     : BottomNavBar(selectedIndex: widget.selectedIndex - 1),
          );
  }
}
