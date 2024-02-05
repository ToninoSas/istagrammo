// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:istagrammo/providers/theme_provider.dart';
import 'package:istagrammo/providers/user_provider.dart';
import 'package:istagrammo/resources/firestore_methods.dart';
import 'package:istagrammo/utils/styles.dart';
import 'package:istagrammo/widgets/post_card.dart';
import 'package:istagrammo/widgets/twitt_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  int selectedIndex = 0;
  static const pageRouteName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedValue = 0;
  final ScrollController _scrollController = ScrollController();

  void scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    // _scrollController.jumpTo(0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: DropdownButtonHideUnderline(
            child: DropdownButton(
                dropdownColor: Provider.of<ThemeProvider>(context).isDarkTheme
                    ? primaryColorDark
                    : primaryColorLight,
                alignment: AlignmentDirectional.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  // color: Theme.of(context).primaryColor
                ),
                value: _selectedValue,
                items: const <DropdownMenuItem>[
                  DropdownMenuItem(
                    value: 0,
                    child: Text('Più recente'),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Text('Più likes'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value;
                  });

                  scrollToTop();
                }),
          ),
          actions: const [
            IconButton(onPressed: null, icon: Icon(Icons.favorite)),
            IconButton(onPressed: null, icon: Icon(Icons.send_rounded)),
          ],
        ),
        body: StreamBuilder(
            stream: _selectedValue == 0
                ? FirebaseFirestore.instance
                    .collection(FirestoreMethods.postsCollection)
                    .orderBy('datePublished', descending: true)
                    // .where('isTwitt', isEqualTo: false)
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection(FirestoreMethods.postsCollection)
                    .orderBy('nLikes', descending: true)
                    // .where('isTwitt', isEqualTo: false)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('Non ci sono posts ora. Riprova più tardi'),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    if (snapshot.data!.docs[index].data()['isTwitt']) {
                      return TwittCard(snap: snapshot.data!.docs[index].data());
                    } else {
                      return PostCard(snap: snapshot.data!.docs[index].data());
                    }
                  },
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            })

        // bottomNavigationBar: hasLoadedData
        //     ? BottomNavBar(selectedIndex: widget.selectedIndex)
        //     : null);
        );
  }
}
