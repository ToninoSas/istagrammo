// import 'package:flutter/material.dart';
// import 'package:instagram_app/models/user.dart';
// import 'package:instagram_app/screens/other_users_profile_page.dart';
// import 'package:instagram_app/providers/app_state.dart';
// import 'package:provider/provider.dart';
//
// import 'circle_box_widget.dart';
//
// class UserListTileWidget extends StatelessWidget {
//   UserListTileWidget({super.key, required this.userMap});
//
//   var userMap;
//
//   @override
//   Widget build(BuildContext context) {
//     // AuthUser currentUser = Provider.of<UserProvider>(context).userProfile;
//
//     Widget user = Consumer<AppState>(
//       builder: (context, appState, child) {
//         return Container(
//           margin: const EdgeInsets.only(top: 4),
//           child: InkWell(
//             onTap: () {
//               // se l'utente è diverso da quello corrente, lo porto alla pagina dell altro utente
//               if (currentUser.username != userMap['username']) {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => OtherUserProfilePage(
//                             username: userMap['username'])));
//               }
//             },
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
//               child: SizedBox(
//                   width: double.infinity,
//                   child: GestureDetector(
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         CircleBox(
//                           imageProvider:
//                               NetworkImage(userMap['profile_img_url']),
//                           radius: 30,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 20),
//                           child: Text(userMap['username']),
//                         )
//
//                         // TODO ADD NUMBER OF FOLLOWERS
//                       ],
//                     ),
//                   )),
//             ),
//           ),
//         );
//       },
//     );
//
//     return user;
//   }
// }
