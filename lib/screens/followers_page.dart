// import 'package:flutter/material.dart';
// import 'package:instagram_app/models/user.dart';
// import 'package:instagram_app/widgets/user_list_tile_widget.dart';
//
// import 'package:instagram_app/utils/api.dart' as api;
//
// class FollowersPage extends StatefulWidget {
//   FollowersPage({super.key, required this.user});
//
//   User user;
//
//   @override
//   State<FollowersPage> createState() => _FollowersPageState();
// }
//
// class _FollowersPageState extends State<FollowersPage> {
//   // late AuthUser currentUser;
//
//   late Future future = getData();
//   List allUsers = [];
//   List usersToShow = [];
//
//   TextEditingController _searchController = TextEditingController();
//
//   Future getData() async {
//     var myData = await api.UserApi.getUserFollowers(widget.user.username);
//
//     allUsers = myData;
//     usersToShow = allUsers;
//
//     return allUsers;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//             appBar: AppBar(
//               title: Text('Followers'),
//             ),
//             body: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: TextField(
//                     onChanged: (value) {
//                       setState(() {
//                         usersToShow = allUsers
//                             .where((element) => element['username']!
//                                 .contains(value.toLowerCase()))
//                             .toList();
//                       });
//                     },
//                     controller: _searchController,
//                     decoration: const InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(8)),
//                         ),
//                         labelText: 'Cerca',
//                         contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
//                         icon: Icon(Icons.search_rounded)),
//                   ),
//                 ),
//                 Expanded(
//                   child: FutureBuilder(
//                     future: future,
//                     builder: (context, snapshot) {
//                       switch (snapshot.connectionState) {
//                         case ConnectionState.none:
//                           return const Center(
//                             child: Text('Anything is appened'),
//                           );
//                         case ConnectionState.waiting:
//                         case ConnectionState.active:
//                           return const Center(
//                               child: CircularProgressIndicator());
//                         case ConnectionState.done:
//                           return ListView.builder(
//                               itemCount: usersToShow.length,
//                               itemBuilder: (BuildContext context, int index) {
//                                 return UserListTileWidget(
//                                     userMap: usersToShow[index]);
//                               });
//                       }
//                     },
//                   ),
//                 )
//               ],
//             )));
//   }
// }
