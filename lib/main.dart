import 'package:flutter/material.dart';
import 'package:istagrammo/app_layout.dart';
// import 'package:istagrammo/app_layout.dart';

// import 'package:firebase_core/firebase_core.dart';
import 'package:istagrammo/providers/theme_provider.dart';
import 'package:istagrammo/providers/user_provider.dart';
import 'package:istagrammo/screens/home_screen.dart';
import 'package:istagrammo/screens/login_screen.dart';
import 'package:istagrammo/screens/register_screen.dart';
import 'package:istagrammo/utils/styles.dart';
import 'package:provider/provider.dart';
// import 'firebase_options.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

/* TODO 

capire se filtrare i commenti in base ai like o in base alla data

caricare video
zoommare i post
notifiche

*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  await Supabase.initialize(
    url: 'https://kdprfkrjxykofgnuteib.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtkcHJma3JqeHlrb2ZnbnV0ZWliIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkyNzI1NDUsImV4cCI6MjA1NDg0ODU0NX0.gHdkU3hKC_E9h8k9DfkmJL9iu7HE3cZYSHSpteOXqjk',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final SupabaseClient supabase = Supabase.instance.client;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        )
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          title: 'istagrammo',
          debugShowCheckedModeBanner: false,
          // theme: Provider.of<ThemeProvider>(context).isDarkTheme
          //     ? darkTheme
          //     : lightTheme,
          theme: lightTheme,
          home: StreamBuilder(
            stream: supabase.auth.onAuthStateChange,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                // return const AppLayout();
                final authState = snapshot.data;
                if (authState == null ||
                    authState.event == AuthChangeEvent.signedOut) {
                  return LoginScreen(); // Mostra la schermata di login se l'utente è disconnesso
                }

                if (authState.event == AuthChangeEvent.signedIn) {
                  return AppLayout(); // Mostra la schermata principale se l'utente è loggato
                }
              }

              return AppLayout();
            },
          ),
          routes: {
            '/main': (context) => MyApp(),
            HomeScreen.pageRouteName: (context) => HomeScreen(),
            LoginScreen.pageRouteName: (context) => LoginScreen(),
            RegisterScreen.pageRouteName: (context) => const RegisterScreen(),
          },
        );
      }),
    );
  }
}
