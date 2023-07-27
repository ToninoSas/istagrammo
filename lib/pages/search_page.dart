import 'package:flutter/material.dart';
import 'package:instagram_app/pages/other_users_profile_page.dart';
import 'package:instagram_app/providers/user_data_service_provider.dart';
import 'package:instagram_app/utils/func.dart';
import 'package:instagram_app/models/user.dart';
import 'package:instagram_app/widgets/bottom_navbar_widget.dart';

import 'package:instagram_app/utils/api.dart' as api;
import 'package:instagram_app/widgets/circle_box_widget.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class MySearchPage extends StatefulWidget {
  static const String pageRoute = '/search';

  const MySearchPage({super.key});

  @override
  _MySearchPage createState() => _MySearchPage();
}

class _MySearchPage extends State<MySearchPage> {
  int selectedIndex = routes['search']!;

  // TODO ADD NUMBER OF FOLLOWERS
  List<String> usernames = [];
  List<String> profilesImgUrl = [];

  getAllUsersData() async {
    var data = await api.getAllUsers();

    usernames.clear();
    profilesImgUrl.clear();

    if (data != null) {
      for (var user in data) {
        usernames.add(user['username']);
        profilesImgUrl.add(user['profile_img_url']);
      }
    }
  }

  @override
  //al posto di cercare le foto, cercherà gli utenti, quindi ci sarà una lista di utenti
  Widget build(BuildContext context) {
    // User currentUser = UserDataServiceProvider.of(context).userData;
    AuthUser currentUser = Provider.of<UserProvider>(context).userProfile;

    return SafeArea(
        child: Scaffold(
            body: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        labelText: 'Cerca',
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        icon: Icon(Icons.search_rounded)),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: getAllUsersData(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return const Center(
                            child: Text('Anything is appened'),
                          );
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          return const Center(
                              child: CircularProgressIndicator());
                        case ConnectionState.done:
                          return ListView.builder(
                              itemCount: usernames.length,
                              itemBuilder: (BuildContext context, int index) {
                                // per non far mostrare l'user corrente
                                if (usernames[index] != currentUser.username) 
                                {
                                  return Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OtherUserProfilePage(
                                                        username:
                                                            usernames[index])));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 0, 0, 0),
                                        child: SizedBox(
                                            width: double.infinity,
                                            child: GestureDetector(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  CircleBox(
                                                    imageProvider: NetworkImage(
                                                        profilesImgUrl[index]),
                                                    height: 60,
                                                    width: 60,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20),
                                                    child:
                                                        Text(usernames[index]),
                                                  )

                                                  // TODO ADD NUMBER OF FOLLOWERS
                                                ],
                                              ),
                                            )),
                                      ),
                                    ),
                                  );
                                }

                                return SizedBox();
                              });
                      }
                    },
                  ),
                )
              ],
            ),
            bottomNavigationBar: BottomNavBar(
              selectedIndex: selectedIndex,
            )));
  }
}
