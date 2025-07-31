// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:istagrammo/models/pick.dart';
import 'package:istagrammo/models/user.dart';
import 'package:istagrammo/providers/user_provider.dart';
import 'package:istagrammo/resources/auth_methods.dart';
import 'package:istagrammo/resources/database_methods.dart';
import 'package:istagrammo/screens/search_screen.dart';
// import 'package:istagrammo/screens/edit_profile_screen.dart';
// import 'package:istagrammo/screens/search_screen.dart';
// import 'package:istagrammo/screens/upload_post_screen.dart';
// import 'package:istagrammo/widgets/post_thumb.dart';
// import 'package:istagrammo/widgets/twitt_card.dart';
import 'package:istagrammo/widgets/user_profile_drawer.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'edit_profile_screen.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key, required this.userToShowUid});

  String userToShowUid;
  static const pageRouteName = '/profile';
  int selectedIndex = 2;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  MyUser? pageUser;

  bool isLoading = false, _isCurrentUser = true, hasLoadedUserData = false;

  bool isFollowing = false;

  get supabase => Supabase.instance.client;
  get currentUser => Supabase.instance.client.auth.currentUser;

  int nPosts = 0, nFollowers = 0, nSeguiti = 0;

  getData() async {
    setState(() {
      isLoading = true;
    });

    if (widget.userToShowUid != supabase.auth.currentUser.id) {
      // sto vedendo il profilo di un altro utente
      _isCurrentUser = false;

      pageUser = await AuthMethods().getUserData(uid: widget.userToShowUid);
      pageUser!.posts = await DatabaseMethods().getUserPosts(userId: pageUser!.id);
      pageUser!.followers = await DatabaseMethods().getUserFollowers(userId: pageUser!.id);
      pageUser!.followed = await DatabaseMethods().getUserSeguiti(userId: pageUser!.id);

      for (var follower in pageUser!.followers){
        print(follower.toJson());
      }

      pageUser!.followers.map((follower){
        print('json: ${follower.toJson()}');
        if(follower.id == currentUser.id) {
          isFollowing = true;
          print('lo seguo');
        }
      });
    } else {
      pageUser = Provider.of<UserProvider>(context).myUser;
    }



    nPosts = pageUser!.posts.length;
    nFollowers = pageUser!.followers.length;
    nSeguiti = pageUser!.followed.length;

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
              title: Text(pageUser!.username),
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
                                      // Navigator.of(context).pop();
                                      //
                                      // Navigator.of(context)
                                      //     .push(MaterialPageRoute(
                                      //   builder: (context) => UploadPostScreen(
                                      //     myUser: myUser,
                                      //   ),
                                      // ));
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
                                      // Navigator.of(context).pop();
                                      // Navigator.of(context)
                                      //     .push(MaterialPageRoute(
                                      //   builder: (context) => UploadPostScreen(
                                      //     myUser: myUser,
                                      //     isTwitt: true,
                                      //   ),
                                      // ));
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
                                      'Immagine profilo di ${pageUser!.username}'),
                                ),
                                body: Center(
                                  child: Image(
                                    image:
                                        NetworkImage(pageUser!.profileImgUrl),
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
                                  NetworkImage(pageUser!.profileImgUrl),
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
                                  inFollowers: true,
                                  targetId: pageUser!.id,
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
                                  inSeguiti: true,
                                  targetId: pageUser!.id,
                                ),
                              ));
                            },
                            child: Column(
                              children: [
                                Text(nSeguiti.toString()),
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
                      child: Text(pageUser!.bio),
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
                                      builder: (context) => EditProfileScreen(
                                          userToEdit: pageUser!),
                                    ));
                                  },
                                  child: Text('Modifica profilo')))
                        else
                          Expanded(
                              child: isFollowing
                                  ? ElevatedButton(
                                      onPressed: () async {
                                        await DatabaseMethods().followUser(
                                            codUtente: currentUser.id,
                                            codSeguito: pageUser!.id);

                                        setState(() {
                                          isFollowing = false;
                                          nFollowers--;
                                        });
                                      },
                                      child: Text('Non seguire più'))
                                  : ElevatedButton(
                                      onPressed: () async {
                                        await DatabaseMethods().followUser(
                                            codUtente: currentUser.id,
                                            codSeguito: pageUser!.id);

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
                                if (pageUser!.posts.isEmpty)
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
                                      itemCount: pageUser!.posts.length,
                                      itemBuilder: (context, index) {
                                        // return PostThumb(
                                        //   index: index,
                                        //   snap: myUser!.posts[index],
                                        //   isCurrentUser: _isCurrentUser,
                                        // );
                                      },
                                    ),
                                  ),
                                if (pageUser!.twitts.isEmpty)
                                  Center(
                                    child: Text('Non ci sono twitts'),
                                  )
                                else
                                  ListView.builder(
                                    itemCount: pageUser!.twitts.length,
                                    itemBuilder: (context, index) {
                                      // return TwittCard(
                                      //     snap: myUser!.twitts[index].data());
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
