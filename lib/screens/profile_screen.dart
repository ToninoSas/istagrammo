// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:istagrammo/models/post.dart';
import 'package:istagrammo/models/user.dart';
import 'package:istagrammo/providers/user_provider.dart';
import 'package:istagrammo/resources/firestore_methods.dart';
import 'package:istagrammo/screens/edit_profile_screen.dart';
import 'package:istagrammo/screens/search_screen.dart';
import 'package:istagrammo/screens/upload_post_screen.dart';
import 'package:istagrammo/widgets/post_thumb.dart';
import 'package:istagrammo/widgets/twitt_card.dart';
import 'package:istagrammo/widgets/user_profile_drawer.dart';
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

  bool isLoading = false, _isCurrentUser = true, hasLoadedUserData = false;

  int nPosts = 0, nFollowers = 0, nFollowed = 0;
  bool isFollowing = false;

  getData() async {
    setState(() {
      isLoading = true;
    });

    if (widget.uid != FirebaseAuth.instance.currentUser!.uid) {
      _isCurrentUser = false;

      final snap = await FirebaseFirestore.instance
          .collection(FirestoreMethods.utentiCollection)
          .doc(widget.uid)
          .get();

      myUser = MyUser.fromSnap(snap);

      final postsSnap = await FirebaseFirestore.instance
          .collection(FirestoreMethods.postsCollection)
          .where('uid', isEqualTo: widget.uid)
          .orderBy('datePublished', descending: true)
          .get();

      for (var post in postsSnap.docs) {
        if (post.data()['isTwitt']) {
          myUser!.twitts.add(post);
        } else {
          myUser!.posts.add(Post.fromSnap(post));
        }
      }
    } else {
      // è l'user corrente
      myUser = Provider.of<UserProvider>(context).myUser;
    }

    nFollowed = myUser!.followed.length;
    nFollowers = myUser!.followers.length;
    nPosts = myUser!.posts.length + myUser!.twitts.length;

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
                if (_isCurrentUser)
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                contentPadding: EdgeInsets.zero,
                                children: [
                                  SimpleDialogOption(
                                    onPressed: () async {
                                      Navigator.of(context).pop();

                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => UploadPostScreen(
                                          myUser: myUser,
                                        ),
                                      ));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      child: const Text(
                                        'Aggiungi un post',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => UploadPostScreen(
                                          myUser: myUser,
                                          isTwitt: true,
                                        ),
                                      ));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      child: const Text(
                                        'Aggiungi un twitt',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            });
                      },
                      icon: Icon(Icons.add)),
              ],
            ),
            body: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              Widget showProfilePicScreen = Scaffold(
                                appBar: AppBar(
                                  title: Text(
                                      'Immagine profilo di ${myUser!.username}'),
                                ),
                                body: Center(
                                  child: Image(
                                    image: NetworkImage(myUser!.profileImgUrl),
                                    errorBuilder: (context, error, stackTrace) {
                                      return Text(
                                          'Impossibile caricare l\'immagine profilo');
                                    },
                                  ),
                                ),
                              );

                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return showProfilePicScreen;
                                },
                              ));
                            },
                            child: CircleAvatar(
                              // backgroundColor: Colors.grey,
                              radius: 40,
                              backgroundImage:
                                  NetworkImage(myUser!.profileImgUrl),
                            ),
                          ),
                          Column(
                            children: [Text(nPosts.toString()), Text('feed')],
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
                    Divider(
                      thickness: 1,
                    ),
                  ],
                ),
              ),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : DefaultTabController(
                      length: 2,
                      child: Expanded(
                        child: Column(
                          children: [
                            TabBar(
                                unselectedLabelColor:
                                    Theme.of(context).secondaryHeaderColor,
                                indicator: BoxDecoration(),
                                labelColor: Theme.of(context).primaryColor,
                                tabs: [
                                  Container(
                                      // margin: EdgeInsets.only(bottom: 8),
                                      padding: EdgeInsets.all(8),
                                      child: Icon(Icons.grid_view_rounded)),
                                  Container(
                                      // margin: EdgeInsets.only(bottom: 8),
                                      padding: EdgeInsets.all(8),
                                      child: FaIcon(
                                        FontAwesomeIcons.feather,
                                        size: 16,
                                      ))
                                ]),
                            Expanded(
                                child: TabBarView(
                              children: [
                                if (myUser!.posts.isEmpty)
                                  Center(
                                    child: Text('Non ci sono posts'),
                                  )
                                else
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 5,
                                              mainAxisSpacing: 5),
                                      itemCount: myUser!.posts.length,
                                      itemBuilder: (context, index) {
                                        return PostThumb(
                                          index: index,
                                          snap: myUser!.posts[index],
                                          isCurrentUser: _isCurrentUser,
                                        );
                                      },
                                    ),
                                  ),
                                if (myUser!.twitts.isEmpty)
                                  Center(
                                    child: Text('Non ci sono twitts'),
                                  )
                                else
                                  ListView.builder(
                                    itemCount: myUser!.twitts.length,
                                    itemBuilder: (context, index) {
                                      return TwittCard(
                                          snap: myUser!.twitts[index].data());
                                    },
                                  ),
                              ],
                            ))
                          ],
                        ),
                      ))
            ]),
            drawer: _isCurrentUser ? UserProfileDrower() : null,
            // bottomNavigationBar: _isCurrentUser
            //     ? BottomNavBar(selectedIndex: widget.selectedIndex)
            //     : BottomNavBar(selectedIndex: widget.selectedIndex - 1),
          );
  }
}
