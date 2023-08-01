import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:instagram_app/models/user.dart';
import 'package:instagram_app/providers/user_provider.dart';
import 'package:instagram_app/widgets/user_list_tile_widget.dart';

import 'package:instagram_app/utils/api.dart' as api;
import 'package:provider/provider.dart';

class FollowedPage extends StatefulWidget {
  FollowedPage({super.key, required this.user});

  User user;

  @override
  State<FollowedPage> createState() => _FollowedPageState();
}

class _FollowedPageState extends State<FollowedPage> {
  // late AuthUser currentUser;

  late Future future = getData();
  List allUsers = [];
  List usersToShow = [];

  TextEditingController _searchController = TextEditingController();

  Future getData() async {
    var myData = await api.UserApi.getUserFollowed(widget.user.username);

    allUsers = myData;
    usersToShow = allUsers;

    return allUsers;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('Followed'),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        usersToShow = allUsers
                            .where((element) => element['username']!
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                    controller: _searchController,
                    decoration: const InputDecoration(
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
                    future: future,
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
                              itemCount: usersToShow.length,
                              itemBuilder: (BuildContext context, int index) {
                                return UserListTileWidget(
                                    userMap: usersToShow[index]);
                              });
                      }
                    },
                  ),
                )
              ],
            )));
  }
}
