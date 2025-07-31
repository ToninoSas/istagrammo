// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:wepick/models/user.dart';
// import 'package:wepick/providers/user_provider.dart';
// import 'package:wepick/resources/database_methods.dart';
// import 'package:wepick/screens/comments_screen.dart';
// import 'package:wepick/screens/edit_post_screen.dart';
// import 'package:wepick/screens/profile_screen.dart';
// import 'package:wepick/utils/utils.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class TwittCard extends StatefulWidget {
//   TwittCard({super.key, required this.snap, this.disableActions = false});

//   Map<String, dynamic> snap;

//   bool disableActions = false;

//   @override
//   State<TwittCard> createState() => _TwittCardState();
// }

// class _TwittCardState extends State<TwittCard> {
//   bool isCurrentUser = false;
//   late MyUser user;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     user = Provider.of<UserProvider>(context, listen: false).myUser;

//     if (user.uid == widget.snap['uid']) {
//       isCurrentUser = true;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CircleAvatar(
//                     backgroundImage: NetworkImage(widget.snap['profileImgUrl']),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         InkWell(
//                           onTap: isCurrentUser
//                               ? null
//                               : () {
//                                   Navigator.of(context).push(MaterialPageRoute(
//                                     builder: (context) =>
//                                         ProfileScreen(uid: widget.snap['uid']),
//                                   ));
//                                 },
//                           child: Text(
//                             widget.snap['username'],
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         SizedBox(
//                           // il size è quello che non fa andare in overflow il testo
//                           width: MediaQuery.of(context).size.width * 0.60,
//                           child: Text(
//                             '${widget.snap['description']}',
//                             softWrap: true,
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             Stack(
//                               children: [
//                                 IconButton(
//                                   onPressed: widget.disableActions
//                                       ? null
//                                       : () async {
//                                           await DatabaseMethods().likePost(
//                                               uid: user.uid,
//                                               postId: widget.snap['postId'],
//                                               likes: widget.snap['likes']);
//                                         },
//                                   icon: widget.disableActions
//                                       ? const Icon(
//                                           size: 22,
//                                           Icons.favorite,
//                                         )
//                                       : widget.snap['likes'].contains(user.uid)
//                                           ? const Icon(
//                                               size: 22,
//                                               Icons.favorite,
//                                               color: Colors.red,
//                                             )
//                                           : const Icon(
//                                               size: 22,
//                                               Icons.favorite_border,
//                                             ),
//                                 ),
//                                 Positioned(
//                                   bottom: 15,
//                                   left: 40,
//                                   child: Text('${widget.snap['likes'].length}'),
//                                 )
//                               ],
//                             ),
//                             Stack(
//                               children: [
//                                 IconButton(
//                                   onPressed: widget.disableActions
//                                       ? null
//                                       : () {
//                                           Navigator.of(context)
//                                               .push(MaterialPageRoute(
//                                             builder: (context) =>
//                                                 CommentsScreen(
//                                                     snap: widget.snap),
//                                           ));
//                                         },
//                                   icon: const FaIcon(
//                                     size: 22,
//                                     FontAwesomeIcons.commentDots,
//                                   ),
//                                 ),
//                                 Positioned(
//                                   bottom: 15,
//                                   left: 40,
//                                   child:
//                                       Text('${widget.snap['comments'].length}'),
//                                 )
//                               ],
//                             ),
//                             // const IconButton(
//                             //     onPressed: null,
//                             //     icon: Icon(
//                             //       Icons.share,
//                             //       size: 20,
//                             //     )),
//                           ],
//                         ),
//                         Container(
//                           padding: const EdgeInsets.only(left: 0, bottom: 0),
//                           child: Text(
//                             DateFormat.yMMMd()
//                                 .add_Hms()
//                                 .format(widget.snap['datePublished'].toDate()),
//                             style: const TextStyle(
//                                 color: Colors.grey, fontSize: 12),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               if (user.uid == widget.snap['uid'].toString())
//                 IconButton(
//                     onPressed: widget.disableActions
//                         ? null
//                         : () {
//                             showDialog(
//                                 context: context,
//                                 builder: (context) {
//                                   return SimpleDialog(
//                                     contentPadding: EdgeInsets.zero,
//                                     children: [
//                                       SimpleDialogOption(
//                                         onPressed: () {
//                                           Navigator.of(context).pop();

//                                           Navigator.of(context)
//                                               .push(MaterialPageRoute(
//                                             builder: (context) =>
//                                                 EditPostScreen(
//                                               snap: widget.snap,
//                                               isTwitt: true,
//                                             ),
//                                           ));
//                                         },
//                                         child: Container(
//                                           padding: const EdgeInsets.all(12),
//                                           child: const Text(
//                                             'Modifica twitt',
//                                             style: TextStyle(fontSize: 16),
//                                           ),
//                                         ),
//                                       ),
//                                       SimpleDialogOption(
//                                         onPressed: () async {
//                                           String msg = await DatabaseMethods()
//                                               .deletePost(
//                                                   widget.snap['postId']);

//                                           Navigator.of(context).pop();

//                                           if (msg != "") {
//                                             showSnackBar(context, msg);
//                                           } else {
//                                             showSnackBar(
//                                                 context, 'Twitt eliminato');
//                                           }
//                                         },
//                                         child: Container(
//                                           padding: const EdgeInsets.all(12),
//                                           child: const Text(
//                                             'Elimina twitt',
//                                             style: TextStyle(fontSize: 16),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   );
//                                 });
//                           },
//                     icon: const Icon(Icons.more_vert))
//             ],
//           ),
//         ),
//         // const Divider(
//         //   thickness: 2,
//         //   height: 0,
//         // ),
//       ],
//     );
//   }
// }
