// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:instagram_app/pages/home_page.dart';
import 'package:instagram_app/pages/login_page.dart';
import 'package:instagram_app/providers/user_data_service_provider.dart';
import 'package:instagram_app/models/user.dart';
import 'package:instagram_app/providers/user_provider.dart';
import 'package:instagram_app/utils/func.dart';
import 'package:instagram_app/utils/api.dart' as api;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class MainLevelWidget extends StatelessWidget {
  const MainLevelWidget({super.key});

  Future<Widget> firstPage(BuildContext context) async {
    // PER CANCELLARE I DATI NEL LOCAL STORAGE
    // final prefs = await SharedPreferences.getInstance();
    // prefs.clear();

    if (await LocalStorage.isLoggedIn()) {
      // AuthUser user = (await LocalStorage.getUserData())!;
      print('L\'UTENTE è LOGGATO');
      // prendo l'apikey è vedo se è valida
      String apiKey = await LocalStorage.getApiKey();

      if (!(await api.Auth.syn(apiKey))) {
        // l'utente deve rifare il login
        print('KEY NON VALIDA-> $apiKey');
        return MyLoginPage();
      }

      // se l'apikey è valida, prendo il profilo dell'utente dal server
      String username = (await LocalStorage.getUserData())!.username;
      print('1');
      print(username);
      AuthUser userProfile = AuthUser(await api.UserApi.userProfile(username));
      print('2');

      userProfile.setPosts(await api.PostApi.getUserPosts(username));
      print('3');

      userProfile.setApiKey(apiKey);
      // lo salvo localmente
      // LocalStorage.saveUserData(userProfile);

      // aggiorno i dati dell'utente
      Provider.of<UserProvider>(context, listen: false).updateUser(userProfile);

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
