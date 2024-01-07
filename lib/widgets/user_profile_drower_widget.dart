import 'package:flutter/material.dart';
import 'package:instagram_app/methods/auth_methods.dart';
import 'package:instagram_app/models/user.dart';
import 'package:instagram_app/providers/app_state.dart';
import 'package:instagram_app/utils/func.dart';
import 'package:provider/provider.dart';

class UserProfileDrower extends StatefulWidget {
  const UserProfileDrower({super.key});

  @override
  State<UserProfileDrower> createState() => _UserProfileDrowerState();
}

class _UserProfileDrowerState extends State<UserProfileDrower> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Consumer<UserProvider>(builder: (context, provider, child) {
      MyUser user = provider.getUser;

      return ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user.username),
            accountEmail: Text(user.email),
            currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('images/img1.jpg')),
            arrowColor: Colors.black,
            decoration: const BoxDecoration(
              color: Colors.grey,
              // border: Border(
              //   bottom: BorderSide(color: Colors.black)
              // ),
            ),
          ),
          ListTile(
            title: Text(user.username),
            leading: const Icon(Icons.person),
            subtitle: const Text("username"),
            onTap: () {},
          ),
          ListTile(
            title: Text(user.email),
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
              AuthMethods().logout().then((value) {
                showSnackBar('Logout effettuato!', context);
                Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed('/login');
              });
            },
          )
        ],
      );
    }));
  }
}
