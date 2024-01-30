import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app_cool/models/user.dart';
import 'package:instagram_app_cool/resources/auth_methods.dart';
import 'package:instagram_app_cool/screens/profile_screen.dart';
import 'package:instagram_app_cool/utils/styles.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen(
      {super.key,
      this.isFollowedPage = false,
      this.isFollowersPage = false,
      required this.uid});

  static String pageRouteName = '/search';
  final int selectedIndex = 1;

  bool? isFollowersPage, isFollowedPage;
  String uid;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool hasSearched = false, _isCurrentUser = true, _isLoading = false;
  User currentUser = FirebaseAuth.instance.currentUser!;

  MyUser? user;

  TextEditingController _searchController = TextEditingController(text: "");

  getUsers() {
    // String yourPosts = "I tuoi posts";
    String usernameToSearch = _searchController.text;

    if (widget.isFollowersPage!) {
      return FirebaseFirestore.instance
          .collection('utenti')
          .where('followed', arrayContains: widget.uid)
          .where('username', isGreaterThanOrEqualTo: usernameToSearch)
          .get();
    } else if (widget.isFollowedPage!) {
      return FirebaseFirestore.instance
          .collection('utenti')
          .where('followers', arrayContains: widget.uid)
          .where('username', isGreaterThanOrEqualTo: usernameToSearch)
          .get();
    } else {
      return FirebaseFirestore.instance
          .collection('utenti')
          .where('username', isGreaterThanOrEqualTo: usernameToSearch)
          .get();
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _isLoading = true;
    });

    AuthMethods().getUserData(uid: widget.uid).then((value) {
      if (value!.uid != currentUser.uid) {
        if (context.mounted) {
          setState(() {
            _isCurrentUser = false;
          });
        }
      }
      if (context.mounted) {
        setState(() {
          user = value;
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String emptyFollowers =
        _isCurrentUser ? "Non hai followers" : "Non ha followers";
    String emptyFollowed =
        _isCurrentUser ? "Non hai seguiti" : "Non ha seguiti";
    String yourSeguiti =
        _isCurrentUser ? "I tuoi seguiti" : "I seguiti di ${user!.username}";
    String yourFollowers = _isCurrentUser
        ? "I tuoi followers"
        : "I followers di ${user!.username}";

    AppBar appBar = AppBar(
      title: (widget.isFollowedPage!)
          ? Text(yourSeguiti)
          : (widget.isFollowersPage!)
              ? Text(yourFollowers)
              : const Text('Cerca'),
    );

    return Scaffold(
      appBar: appBar,
      body: Column(children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 4),
          child: Form(
            child: TextFormField(
              controller: _searchController,
              decoration: textFieldDecoration(
                  icon: const Icon(Icons.search), label: 'Nome utente..'),
              onFieldSubmitted: (String _) {
                setState(() {});
              },
            ),
          ),
        ),
        Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : FutureBuilder(
                    future: getUsers(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if ((snapshot.data as dynamic).docs.length == 0) {
                        if (widget.isFollowedPage!) {
                          return Center(
                            child: Text(emptyFollowed),
                          );
                        } else if (widget.isFollowersPage!) {
                          return Center(
                            child: Text(emptyFollowers),
                          );
                        } else {
                          return const Center(
                            child: Text('Non ci sono utenti'),
                          );
                        }
                      }

                      return ListView.builder(
                        itemCount: (snapshot.data as dynamic).docs.length,
                        itemBuilder: (context, index) {
                          MyUser myUser = MyUser.fromSnap(
                              (snapshot.data as dynamic).docs[index]);

                          return InkWell(
                            onTap: () {
                              // se l'utente è diverso da quello corrente, lo porto alla pagina dell altro utente
                              if (currentUser.uid != myUser.uid) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileScreen(
                                              uid: myUser.uid,
                                            )));
                              }
                            },
                            child: ListTile(
                              subtitle: currentUser.uid == myUser.uid
                                  ? const Text('(io)')
                                  : Text(myUser.bio),
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    NetworkImage(myUser.profileImgUrl),
                              ),
                              title: Text(myUser.username),
                            ),
                          );
                        },
                      );
                      // return Text('ok');
                    },
                  ))
      ]),
      // bottomNavigationBar: bottomNavBar
    );
  }
}
