// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app_cool/models/user.dart';
import 'package:instagram_app_cool/providers/user_provider.dart';
import 'package:instagram_app_cool/screens/home_screen.dart';
import 'package:instagram_app_cool/screens/profile_screen.dart';
import 'package:instagram_app_cool/screens/search_screen.dart';
import 'package:instagram_app_cool/utils/utils.dart';
import 'package:provider/provider.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  final PageController _pageController = PageController();
  int _page = 0;
  bool hasLoadedData = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // le pagine ogni volta che avviene un redirect a /main devono essere ricostruite
    List<Widget> pages = [
      HomeScreen(),
      SearchScreen(uid: FirebaseAuth.instance.currentUser!.uid),
      ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid)
    ];

    if (Provider.of<UserProvider>(context).hasLoaded) {
      setState(() {
        hasLoadedData = true;
      });
    } else {
      hasLoadedData = false;
    }

    if (hasLoadedData) {
      MyUser user = Provider.of<UserProvider>(context).myUser;
      return Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (_index) {
            setState(() {
              _page = _index;
            });
          },
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _page,
          onTap: (_index) {
            _pageController.jumpToPage(_index);
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).secondaryHeaderColor,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Home'),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
                icon: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 15,
                  backgroundImage: NetworkImage(user.profileImgUrl),
                ),
                label: 'Profile')
          ],
        ),
      );
    }

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
