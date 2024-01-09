import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:instagram_app_cool/providers/user_provider.dart';
import 'package:instagram_app_cool/screens/edit_profile_screen.dart';
import 'package:instagram_app_cool/screens/home_screen.dart';
import 'package:instagram_app_cool/screens/login_screen.dart';
import 'package:instagram_app_cool/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  

  runApp(ChangeNotifierProvider.value(
    value: UserProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   // useMaterial3: true,
      // ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              // UserProvider().init();

              return HomeScreen();
            }
          }

          return const LoginScreen();
        },
      ),
      routes: {
        '/main': (context) => const MyApp(),
        HomeScreen.pageRouteName: (context) => HomeScreen(),
        LoginScreen.pageRouteName: (context) => const LoginScreen(),
        ProfileScreen.pageRouteName: (context) => ProfileScreen(),
        // EditProfileScreen.pageRoute:(context) => EditProfileScreen(myUser: myUser)
      },
    );
  }
}
