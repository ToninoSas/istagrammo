// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:istagrammo/models/user.dart';
import 'package:istagrammo/providers/theme_provider.dart';
import 'package:istagrammo/providers/user_provider.dart';
import 'package:istagrammo/resources/auth_methods.dart';
import 'package:istagrammo/utils/styles.dart';
import 'package:istagrammo/utils/utils.dart';
import 'package:provider/provider.dart';

class UserProfileDrower extends StatefulWidget {
  const UserProfileDrower({super.key});

  @override
  State<UserProfileDrower> createState() => _UserProfileDrowerState();
}

class _UserProfileDrowerState extends State<UserProfileDrower> {
  final globalKey = GlobalKey<_UserProfileDrowerState>();

  deleteUser(String uid) async {
    //todo aggiustare user experience
    // showSnackBar(
    //     context, 'Eliminazione account effettuata!');

    // Navigator.of(context).pop();
    // Navigator.of(context).pop();

    if (await AuthMethods().deleteUser(uid: uid)) {
      // è andato a buon fine
      if (context.mounted) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pushReplacementNamed('/main');
        });
      }
    } else {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      showSnackBar(context,
          'E\' necessario l\'riautenticarsi. Effettui il logout e successivamente il login e riprovi l\'operazione');
    }
    // TODO RIMUOVERE L'UTENTE DAI FOLLOWERS E DAI SEGUITI DEGLI ALTRI UTENTI
    // TODO ELIMINA PROFILO UTENTE E LOGOUT
  }

  @override
  Widget build(BuildContext context) {
    final MyUser user = Provider.of<UserProvider>(context).myUser;
    final ThemeProvider theme = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            // accountName: Text(user.username),
            // accountEmail: Text(user.email),

            accountName: const Text(''),
            accountEmail: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(user.email),
                  ],
                ),
                IconButton(
                    onPressed: () {
                      theme.toogleTheme();
                    },
                    icon: theme.isDarkTheme
                        ? const Icon(Icons.light_mode_rounded)
                        : const Icon(Icons.dark_mode_rounded))
              ],
            ),

            currentAccountPicture:
                CircleAvatar(backgroundImage: NetworkImage(user.profileImgUrl)),
            decoration: BoxDecoration(
                color: Provider.of<ThemeProvider>(context).isDarkTheme
                    ? primaryColorDark
                    : primaryColorLight),
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
          // const ListTile(
          //   title: Text('Settings'),
          //   leading: Icon(Icons.settings),
          // ),
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
          ),
          ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Elimina account'),
                    content: const Text(
                        'Sei sicuro di voler eliminare l\'account?\nTutti i tuoi dati andranno persi\n(Potrebbe essere richiesta l\'autenticazione)'),
                    actions: [
                      ElevatedButton(
                          onPressed: () async {
                                  // deleteUser(user.uid);
                                },
                          child: const Text('OK')),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Annulla'))
                    ],
                  );
                },
              );
            },
            title: const Text('Elimina account'),
            leading: const Icon(Icons.delete_forever_rounded),
          )
        ],
      ),
    );
  }
}
