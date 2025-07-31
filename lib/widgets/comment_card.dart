// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:wepick/models/user.dart';
// import 'package:wepick/providers/user_provider.dart';
// import 'package:wepick/resources/database_methods.dart';
// import 'package:wepick/screens/profile_screen.dart';
// import 'package:wepick/utils/utils.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class CommentCard extends StatefulWidget {
//   const CommentCard({super.key, this.snap});
//   final snap;

//   @override
//   State<CommentCard> createState() => _CommentCardState();
// }

// class _CommentCardState extends State<CommentCard> {
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
//     return InkWell(
//       onLongPress: isCurrentUser
//           ? () {
//               showDialog(
//                 context: context,
//                 builder: (context) {
//                   return SimpleDialog(
//                       contentPadding: EdgeInsets.zero,
//                       children: [
//                         SimpleDialogOption(
//                           onPressed: () async {
//                             String msg = await DatabaseMethods().deleteComment(
//                                 postId: widget.snap['postId'],
//                                 commentId: widget.snap['commentId']);

//                             if (context.mounted) {
//                               if (msg != "") {
//                                 showSnackBar(context, msg);
//                               } else {
//                                 showSnackBar(context, "Commento eliminato");
//                               }

//                               Navigator.of(context).pop();
//                             }
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.all(12),
//                             child: const Text(
//                               'Elimina commento',
//                               style: TextStyle(fontSize: 16),
//                             ),
//                           ),
//                         )
//                       ]);
//                 },
//               );
//             }
//           : null,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                   backgroundImage: NetworkImage(widget.snap['profileImgUrl']),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       InkWell(
//                         onTap: isCurrentUser
//                             ? null
//                             : () {
//                                 Navigator.of(context).push(MaterialPageRoute(
//                                   builder: (context) =>
//                                       ProfileScreen(uid: widget.snap['uid']),
//                                 ));
//                               },
//                         child: Text(
//                           widget.snap['username'],
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 5,
//                       ),
//                       SizedBox(
//                         // il size è quello che non fa andare in overflow il testo
//                         width: MediaQuery.of(context).size.width * 0.60,
//                         child: Text(
//                           '${widget.snap['text']}',
//                           softWrap: true,
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 5,
//                       ),
//                       Text(
//                         DateFormat.yMMMd()
//                             .add_Hms()
//                             .format(widget.snap['datePublished'].toDate()),
//                         style:
//                             const TextStyle(color: Colors.grey, fontSize: 12),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Stack(
//               children: [
//                 IconButton(
//                   onPressed: () async {
//                     DatabaseMethods().likeComment(
//                         postId: widget.snap['postId'],
//                         commentId: widget.snap['commentId'],
//                         uid: user.uid,
//                         likes: widget.snap['likes']);
//                   },
//                   icon: widget.snap['likes'].contains(user.uid)
//                       ? const Icon(
//                           size: 20,
//                           Icons.favorite,
//                           color: Colors.red,
//                         )
//                       : const Icon(
//                           size: 20,
//                           Icons.favorite_border,
//                         ),
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   left: 20,
//                   child: Text('${widget.snap['likes'].length}'),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
