// // ignore_for_file: library_private_types_in_public_api, prefer_const_constructors
//
// import 'package:flutter/material.dart';
// import 'package:instagram_app/dialogs/post_settings_popup.dart';
// import 'package:instagram_app/models/post.dart';
// import 'package:instagram_app/models/user.dart';
// import 'package:instagram_app/providers/app_state.dart';
// import 'package:instagram_app/widgets/circle_box_widget.dart';
// import 'package:provider/provider.dart';
//
// import 'package:instagram_app/utils/api.dart' as api;
//
// class PostWidget extends StatefulWidget {
//   //Costruttore
//   const PostWidget({Key? key, required this.openedPost}) : super(key: key);
//
//   final Post openedPost;
//
//   //gestione dello stato
//   @override
//   _Post createState() => _Post();
// }
//
// class _Post extends State<PostWidget> {
//   // int selectedIndex = 1;
//   bool like = false;
//   bool isSaved = false;
//   // TextEditingController _commentController = TextEditingController();
//   // late AuthUser currentUser;
//   late User postOwner;
//
//   checkLike() {
//     // String currentUsername =
//     //     Provider.of<UserProvider>(context, listen: false).userProfile.username;
//     // if (widget.openedPost.likes.contains(currentUsername)) {
//     //   return true;
//     // }
//     //
//     // return false;
//   }
//
//   checkSaved() {
//     return false;
//   }
//
//   addLikeApi(context) async {
//     // return (await api.PostApi.addLike(
//     //     widget.openedPost.ownerName,
//     //     widget.openedPost.id.toString(),
//     //     Provider.of<UserProvider>(context, listen: false)
//     //         .userProfile
//     //         ));
//   }
//
//   removeLikeApi(context) async {
//     // return await api.PostApi.removeLike(
//     //     widget.openedPost.ownerName,
//     //     widget.openedPost.id.toString(),
//     //     Provider.of<UserProvider>(context, listen: false).userProfile);
//   }
//
//   addComment() async {}
//
//   @override
//   Widget build(BuildContext context) {
//     // currentUser = Provider.of<UserProvider>(context).userProfile;
//     postOwner = widget.openedPost.ownerUser;
//
//     like = checkLike();
//     // isSaved = checkSaved();
//
//     return Consumer<AppState>(builder: (context, appState, _) {
//       return SingleChildScrollView(
//         child: Container(
//           color: Theme.of(context).primaryColor,
//           child: Column(
//             // mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               //username
//               Row(
//                 //textDirection: TextDirection.ltr,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Row(
//                     children: [
//                       CircleBox(
//                         imageProvider: NetworkImage(
//                             widget.openedPost.ownerUser.profileImgUrl),
//                         radius: 25,
//                       ),
//                       SizedBox(
//                         height: 50,
//                         child: Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: Text(
//                               widget.openedPost.ownerName,
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 16),
//                             )),
//                       ),
//                     ],
//                   ),
//                   const Row(
//                     children: [
//                       // PostSettingsPopup()
//                     ],
//                   )
//                 ],
//               ),
//               const Divider(
//                 thickness: 1,
//                 height: 0,
//                 color: Colors.grey,
//               ),
//               Container(
//                 color: Theme.of(context).primaryColor,
//                 child: SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   height: 400,
//                   child: Image.network(
//                     widget.openedPost.url,
//                     errorBuilder: (context, error, stackTrace) {
//                       return const Center(
//                         child: Text('Ops.. Post not found'),
//                       );
//                     },
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//               const Divider(
//                 thickness: 1,
//                 height: 0,
//                 color: Colors.grey,
//               ),
//               //buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     children: [
//                       Row(
//                         children: [
//                           IconButton(
//                               icon: Icon(like
//                                   ? Icons.favorite
//                                   : Icons.favorite_border),
//                               color: like ? Colors.red : Colors.black,
//                               onPressed: () {
//                                 setState(() {
//                                   like = !like;
//
//                                   if (like) {
//                                     widget.openedPost.likes
//                                         .add(currentUser.username);
//
//                                     addLikeApi(context);
//                                   } else {
//                                     if (widget.openedPost.likes.isNotEmpty) {
//                                       widget.openedPost.likes
//                                           .remove(currentUser.username);
//
//                                       removeLikeApi(context);
//                                     }
//                                   }
//                                 });
//                               }),
//                           IconButton(
//                               // onPressed: () async {
//                               //   await textDialog(context, _commentController);
//
//                               //   widget.openedPost.comments
//                               //       .add(_commentController.text);
//                               // },
//                               onPressed: null,
//                               icon: const Icon(Icons.add_comment)),
//                           IconButton(
//                             onPressed: null,
//                             icon: const Icon(Icons.send_rounded),
//                             tooltip: 'Invia',
//                           ),
//                           IconButton(
//                             onPressed: null,
//                             icon: const Icon(Icons.share),
//                             tooltip: 'Condividi',
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: Icon(isSaved
//                             ? Icons.bookmark_added
//                             : Icons.bookmark_add_outlined),
//                         onPressed: () {
//                           setState(() {
//                             isSaved = !isSaved;
//                             print(isSaved);
//                           });
//                         },
//                         tooltip: 'Salva',
//                       ),
//                       currentUser.username == postOwner.username
//                           ? IconButton(
//                               onPressed: () => {},
//                               icon: const Icon(Icons.delete),
//                               tooltip: 'Elimina',
//                             )
//                           : Container(),
//                     ],
//                   )
//                 ],
//               ),
//               //comments
//               Row(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8),
//                         child: Text(
//                           'Likes: ${widget.openedPost.likes.length}',
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8),
//                             child: Row(
//                               children: [
//                                 const Text('Descrizione: ',
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.bold)),
//                                 Text(widget.openedPost.descr)
//                               ],
//                             ),
//                           ),
//
//                           // Padding(
//                           //   padding: const EdgeInsets.all(8),
//                           //   child: Text(
//                           //       'Commenti: ${widget.openedPost.comments.length}',
//                           //       style:
//                           //           const TextStyle(fontWeight: FontWeight.bold)),
//                           // ),
//                         ],
//                       ),
//                       // SizedBox(
//                       //   height: 300,
//                       //   width: 300,
//                       //   child: ListView.builder(
//                       //     // shrinkWrap: true,
//                       //     itemBuilder: (context, index) {
//                       //       return Row(
//                       //         children: [
//                       //           Text(
//                       //             widget.openedPost.comments[index]['sender'] + " ",
//                       //             style: const TextStyle(fontWeight: FontWeight.bold),
//                       //           ),
//                       //           Text(widget.openedPost.comments[index]['text']),
//                       //         ],
//                       //       );
//                       //     },
//                       //     itemCount: widget.openedPost.comments.length,
//                       //   ),
//                       // )
//                     ],
//                   )
//                 ],
//               ),
//               const Padding(padding: EdgeInsets.only(bottom: 12))
//             ],
//           ),
//         ),
//       );
//     });
//
//     ;
//   }
// }
