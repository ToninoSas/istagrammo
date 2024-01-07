// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:instagram_app/main_level.dart';
import 'package:instagram_app/screens/auth/login_screen.dart';
import 'package:instagram_app/screens/auth/register_screen.dart';
import 'package:instagram_app/screens/modify_profile_page.dart';
import 'package:instagram_app/screens/search_page.dart';
import 'package:instagram_app/screens/profile_page.dart';
import 'package:instagram_app/screens/upload_post_page.dart';
// import 'package:instagram_app/providers/user_data_service_provider.dart';
import 'package:instagram_app/providers/app_state.dart';
import 'package:instagram_app/utils/theme.dart';
// import 'package:instagram_app/models/user.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';

import 'package:instagram_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AppState()),
      ChangeNotifierProvider(create: (_) => UserProvider())
    ],
    builder: (context, child) => const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // AppState appState = Provider.of<AppState>(context, listen: false);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTeam(),
      home: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.isLogged) {
            Provider.of<UserProvider>(context, listen: false)
                .caricaDatiUtente();

            return HomeScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        HomeScreen.pageRoute: (context) => const HomeScreen(),
        // MySearchPage.pageRoute: (context) => const MySearchPage(),
        ProfilePage.pageRoute: (context) => const ProfilePage(),
        // ModifyProfilePage.pageRoute: (context) => const ModifyProfilePage(),
        LoginScreen.pageRoute: (context) => LoginScreen(),
        RegisterScreen.pageRoute: (context) => RegisterScreen(),
        // UploadPostPage.pageRoute:(context) => UploadPostPage()
        // OtherPlayerProfilePage.pageRoute: (context) => OtherPlayerProfilePage(user: '')
      },
    );
  }
}
