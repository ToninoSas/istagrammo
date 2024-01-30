import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:instagram_app_cool/app_layout.dart';
import 'package:instagram_app_cool/providers/theme_provider.dart';
import 'package:instagram_app_cool/providers/user_provider.dart';
import 'package:instagram_app_cool/screens/edit_profile_screen.dart';
import 'package:instagram_app_cool/screens/home_screen.dart';
import 'package:instagram_app_cool/screens/login_screen.dart';
import 'package:instagram_app_cool/screens/profile_screen.dart';
import 'package:instagram_app_cool/screens/register_screen.dart';
import 'package:instagram_app_cool/screens/search_screen.dart';
import 'package:instagram_app_cool/screens/upload_post_screen.dart';
import 'package:instagram_app_cool/utils/styles.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Map<String, dynamic>? args =
    //     ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        )
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Instagram App',
            debugShowCheckedModeBanner: false,
            theme: Provider.of<ThemeProvider>(context).isDarkTheme ? darkTheme : lightTheme,

            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return const AppLayout();
                  }
                }

                return LoginScreen();
              },
            ),
            routes: {
              '/main': (context) => const MyApp(),
              HomeScreen.pageRouteName: (context) => HomeScreen(),
              LoginScreen.pageRouteName: (context) => LoginScreen(),
              RegisterScreen.pageRouteName: (context) => const RegisterScreen(),
              SearchScreen.pageRouteName: (context) => SearchScreen(
                    uid: FirebaseAuth.instance.currentUser!.uid,
                  ),
              // UploadPostScreen.pageRouteName: (context) => UploadPostScreen(),
              // ProfileScreen.pageRouteName: (context) => ProfileScreen(
              //     // uid: FirebaseAuth.instance.currentUser!.uid,
              //     ),
              // EditProfileScreen.pageRoute:(context) => EditProfileScreen(myUser: myUser)
            },
          );
        }
      ),
    );
  }
}
