// ignore_for_file: no_leading_underscores_for_local_identifiers

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:istagrammo/models/user.dart';
import 'package:istagrammo/providers/user_provider.dart';
// import 'package:istagrammo/screens/home_screen.dart';
import 'package:istagrammo/screens/profile_screen.dart';
import 'package:istagrammo/screens/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:istagrammo/screens/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      SearchScreen(targetId: Supabase.instance.client.auth.currentUser!.id),
      ProfileScreen(userToShowUid: Supabase.instance.client.auth.currentUser!.id)
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
          selectedFontSize: 10,
          unselectedFontSize: 10,
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
              // icon: FaIcon(FontAwesomeIcons.globe),
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            const BottomNavigationBarItem(
                icon: Icon(Icons.chat), label: 'Chat'),
            BottomNavigationBarItem(
                icon: CircleAvatar(
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
