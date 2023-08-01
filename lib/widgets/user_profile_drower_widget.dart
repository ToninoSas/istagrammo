import 'package:flutter/material.dart';
import 'package:instagram_app/models/user.dart';

class UserProfileDrower extends StatelessWidget {
  UserProfileDrower(
      {super.key, required this.userProfile, required this.logoutFunction});

  AuthUser userProfile;
  var logoutFunction;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userProfile.username),
            accountEmail: Text(userProfile.email),
            currentAccountPicture:
                const CircleAvatar(backgroundImage: AssetImage('images/img1.jpg')),
            arrowColor: Colors.black,
            decoration: const BoxDecoration(
              color: Colors.grey,
              // border: Border(
              //   bottom: BorderSide(color: Colors.black)
              // ),
            ),
          ),
          ListTile(
            title: Text(userProfile.username),
            leading: const Icon(Icons.person),
            subtitle: const Text("username"),
            onTap: () {},
          ),
          ListTile(
            title: Text(userProfile.email),
            leading: const Icon(Icons.email),
            subtitle: const Text("email"),
            onTap: () {},
            // horizontalTitleGap: 16,
          ),
          const ListTile(
            title: Text('Settings'),
            leading: Icon(Icons.settings),
          ),
          ListTile(
            title: Text(userProfile.apiKey),
            subtitle: const Text("Api Key"),
            leading: const Icon(Icons.key),
          ),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout),
            onTap: () {
              logoutFunction(context);
              // logout(context);
            },
          )
        ],
      ),
    );
  }
}
