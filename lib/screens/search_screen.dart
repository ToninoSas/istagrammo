import 'package:flutter/material.dart';
import 'package:istagrammo/models/user.dart';
import 'package:istagrammo/resources/auth_methods.dart';
import 'package:istagrammo/resources/database_methods.dart';
import 'package:istagrammo/screens/profile_screen.dart';
import 'package:istagrammo/utils/styles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen(
      {super.key,
      this.inSeguiti = false,
      this.inFollowers = false,
      required this.targetId});

  static String pageRouteName = '/search';
  final int selectedIndex = 1;

  bool inFollowers, inSeguiti;
  String targetId;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

// pagina chiamata per cercare persone
// viene chiamata anche per cercare tra i follower e i seguiti
class _SearchScreenState extends State<SearchScreen> {
  bool hasSearched = false, _isCurrentUser = true, _isLoading = false;
  User currentUser = Supabase.instance.client.auth.currentUser!;

  MyUser? targetUser;

  final TextEditingController _searchController =
      TextEditingController(text: "");

  getUsers() {
    // String yourPosts = "I tuoi posts";
    String usernameToSearch = _searchController.text;

    // cerco nei followers
    if (widget.inFollowers) {

      return DatabaseMethods().getUserFollowers(userId: currentUser.id, filter: usernameToSearch);

    } else if (widget.inSeguiti) {
      // cerco nei seguiti
      return DatabaseMethods().getUserSeguiti(userId: currentUser.id, filter: usernameToSearch);
    } else {
      return DatabaseMethods().getUsers(filter: usernameToSearch);
    }
  }

  @override
  void initState() {
    super.initState();

    // setState(() {
    //   _isLoading = true;
    // });

    // if(widget.targetId!=currentUser.id){
    //   // carico i dati del target
    //   AuthMethods().getUserData(uid: widget.targetId).then((value) {
    //     setState(() {
    //       _isCurrentUser = false;
    //       targetUser = value;
    //       _isLoading = false;
    //     });
    //   });
    // }

    // setState(() {
    //   _isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    String emptyFollowers =
        _isCurrentUser ? "Non hai followers" : "Non ha followers";
    String emptyFollowed =
        _isCurrentUser ? "Non hai seguiti" : "Non ha seguiti";
    String yourSeguiti =
        _isCurrentUser ? "I tuoi seguiti" : "I seguiti di ${targetUser!.username}";
    String yourFollowers = _isCurrentUser
        ? "I tuoi followers"
        : "I followers di ${targetUser!.username}";

    AppBar appBar = AppBar(
      title: (widget.inSeguiti)
          ? Text("Utenti")
          : (widget.inFollowers)
              ? Text("Utenti")
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

                      print(snapshot.data);
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if ((snapshot.data as dynamic).length == 0) {
                        if (widget.inSeguiti) {
                          return Center(
                            child: Text(emptyFollowed),
                          );
                        } else if (widget.inFollowers) {
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
                        itemCount: (snapshot.data as dynamic).length,
                        itemBuilder: (context, index) {
                          MyUser listedUser =
                              (snapshot.data as dynamic)[index];

                          return InkWell(
                            onTap: () {
                              // se l'utente è diverso da quello corrente, lo porto alla pagina dell altro utente
                              if (currentUser.id != listedUser.id) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileScreen(
                                              userToShowUid: listedUser.id,
                                            )));
                              }
                            },
                            child: ListTile(
                              subtitle: currentUser.id == listedUser.id
                                  ? const Text('(io)')
                                  : Text(listedUser.bio),
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    NetworkImage(listedUser.profileImgUrl),
                              ),
                              title: Text(listedUser.username),
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
