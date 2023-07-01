// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:instagram_app/pages/home_page.dart';
import 'package:instagram_app/pages/login_page.dart';
import 'package:instagram_app/providers/user_data_service_provider.dart';
import 'package:instagram_app/models/user.dart';
import 'package:instagram_app/utils/func.dart';
import 'package:instagram_app/utils/api.dart' as api;
// import 'package:shared_preferences/shared_preferences.dart';

class MainLevelWidget extends StatelessWidget {
  const MainLevelWidget({super.key});

  Future<Widget> firstPage(BuildContext context) async {
    // PER CANCELLARE I DATI NEL LOCAL STORAGE
    // final prefs = await SharedPreferences.getInstance();
    // prefs.clear();

    if (await LocalStorage.isLoggedIn()) {

      String username = (await LocalStorage.getUserData())!.username;
      String apiKey = await LocalStorage.getApiKey();

      User userProfile =
          User.fromJsonMap(await api.UserApi.userProfile(username));
      userProfile.apiKey = apiKey;

      // fare il syn per mettersi in connessione con il server e verificare l
      // api key

      if (!(await api.Auth.syn(apiKey))) {
        // l'utente deve rifare il login

        return MyLoginPage();
      }

      UserDataServiceProvider.of(context).update(userProfile);

      print(userProfile.apiKey);

      return const MyHomePage();
    } else {
      return MyLoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //funzione asincrona
      future: firstPage(context),
      builder: (context, snapshot) {
        //se la funzione ha restituito
        if (snapshot.hasData) {
          //restituisco il valore
          return snapshot.data!;
        } else if (snapshot.hasError) {
          //altrimenti dico che c'è stato un errore
          return Scaffold(
            body: Center(child: Text('Error ${snapshot.error.toString()}')),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
