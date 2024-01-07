// import 'package:flutter/material.dart';
// import 'package:instagram_app/utils/func.dart';
// import 'package:instagram_app/models/user.dart';
// import 'package:instagram_app/widgets/bottom_navbar_widget.dart';
//
// import 'package:instagram_app/utils/api.dart' as api;
// import 'package:instagram_app/widgets/user_list_tile_widget.dart';
// import 'package:provider/provider.dart';
//
// import '../providers/app_state.dart';
//
// class MySearchPage extends StatefulWidget {
//   static const String pageRoute = '/search';
//
//   const MySearchPage({super.key});
//
//   @override
//   _MySearchPage createState() => _MySearchPage();
// }
//
// class _MySearchPage extends State<MySearchPage> {
//   int selectedIndex = routes['search']!;
//
//   // mantiene le info originali
//   List allUsers = [];
//   List usersToShow = [];
//
//   // viene chiamato una sola volta
//   late Future future = getAllUsersData();
//
//   TextEditingController _searchController = TextEditingController();
//
//   Future getAllUsersData() async {
//     var data = await api.getAllUsers();
//
//     // per mantenere le info originali
//     allUsers = data;
//     usersToShow = allUsers;
//     return allUsers;
//   }
//
//   @override
//   //al posto di cercare le foto, cercherà gli utenti, quindi ci sarà una lista di utenti
//   Widget build(BuildContext context) {
//
//     return SafeArea(
//         child: Scaffold(
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
//             ),
//             bottomNavigationBar: BottomNavBar(
//               selectedIndex: selectedIndex,
//             )));
//   }
// }
