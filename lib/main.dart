// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:instagram_app/main_level.dart';
// import 'package:instagram_app/main_level.dart';
import 'package:instagram_app/pages/login_page.dart';
import 'package:instagram_app/pages/modify_profile_page.dart';
import 'package:instagram_app/pages/search_page.dart';
import 'package:instagram_app/pages/profile_page.dart';
// import 'package:instagram_app/providers/user_data_service_provider.dart';
import 'package:instagram_app/providers/user_provider.dart';
import 'package:instagram_app/utils/theme.dart';
// import 'package:instagram_app/models/user.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';

void main() {
  // runApp(UserDataServiceProvider(userData: AuthUser.vacand(), child: MyApp()));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => UserProvider(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: lightTeam(),
          home: MainLevelWidget(),
          debugShowCheckedModeBanner: false,
          routes: {
            MyHomePage.pageRoute: (context) => const MyHomePage(),
            MySearchPage.pageRoute: (context) => const MySearchPage(),
            ProfilePage.pageRoute: (context) => const ProfilePage(),
            ModifyProfilePage.pageRoute: (context) => const ModifyProfilePage(),
            MyLoginPage.pageRoute: (context) => MyLoginPage(),
            // OtherPlayerProfilePage.pageRoute: (context) => OtherPlayerProfilePage(user: '')
          },
        ));
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: lightTeam(),
//       home: MainLevelWidget(),
//       debugShowCheckedModeBanner: false,
//       routes: {
//         MyHomePage.pageRoute: (context) => const MyHomePage(),
//         MySearchPage.pageRoute: (context) => const MySearchPage(),
//         ProfilePage.pageRoute: (context) => const ProfilePage(),
//         ModifyProfilePage.pageRoute: (context) => const ModifyProfilePage(),
//         MyLoginPage.pageRoute: (context) => MyLoginPage(),
//         // OtherPlayerProfilePage.pageRoute: (context) => OtherPlayerProfilePage(user: '')
//       },
//     );
//   }
// }
