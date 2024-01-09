// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:instagram_app_cool/models/user.dart';
import 'package:instagram_app_cool/providers/user_provider.dart';
import 'package:instagram_app_cool/resources/auth_methods.dart';
import 'package:instagram_app_cool/widgets/bottom_navbar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  int selectedIndex = 0;
  static const pageRouteName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  logout() async {
    await AuthMethods().logout();
  }

  @override
  Widget build(BuildContext context) {
    MyUser? myUser = Provider.of<UserProvider>(context, listen: false).myUser;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Instagram'),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.add_a_photo_rounded)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.send_rounded)),
          ],
        ),
        body: Center(
            child: Column(
          children: [
            // Text(myUser!.email),
            ElevatedButton(
                onPressed: () {
                  logout();
                },
                child: const Text('Sei dentro! vuoi fare il logout?')),
          ],
        )
        ),
        bottomNavigationBar: BottomNavBar(selectedIndex: widget.selectedIndex));
  }
}
