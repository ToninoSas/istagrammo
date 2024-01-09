// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:instagram_app_cool/models/user.dart';
import 'package:instagram_app_cool/resources/auth_methods.dart';
import 'package:instagram_app_cool/utils/utils.dart';

class UserProfileDrower extends StatefulWidget {
  UserProfileDrower({super.key, required this.user});

  MyUser user;

  @override
  State<UserProfileDrower> createState() => _UserProfileDrowerState();
}

class _UserProfileDrowerState extends State<UserProfileDrower> {

  final globalKey = GlobalKey<_UserProfileDrowerState>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.username),
            accountEmail: Text(widget.user.email),
            currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(widget.user.profileImgUrl)),
            arrowColor: Colors.black,
            decoration: const BoxDecoration(
              color: Colors.grey,
              // border: Border(
              //   bottom: BorderSide(color: Colors.black)
              // ),
            ),
          ),
          ListTile(
            title: Text(widget.user.username),
            leading: const Icon(Icons.person),
            subtitle: const Text("username"),
            onTap: () {},
          ),
          ListTile(
            title: Text(widget.user.email),
            leading: const Icon(Icons.email),
            subtitle: const Text("email"),
            onTap: () {},
            // horizontalTitleGap: 16,
          ),
          const ListTile(
            title: Text('Settings'),
            leading: Icon(Icons.settings),
          ),
          // ListTile(
          //   title: Text(userProfile.apiKey),
          //   subtitle: const Text("Api Key"),
          //   leading: const Icon(Icons.key),
          // ),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout),
            onTap: () {
              AuthMethods().logout().then((msg) {
                if (msg == "") {
                  Navigator.pop(context);

                  showSnackBar(context, 'Logout effettuato');
                  Navigator.of(context).pushReplacementNamed('/main');
                } else {
                  showSnackBar(context, msg);
                }
              });
            },
          )
        ],
      ),
    );
  }
}
