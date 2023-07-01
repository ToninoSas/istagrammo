// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:instagram_app/main_level.dart';
import 'package:instagram_app/pages/home_page.dart';
import 'package:instagram_app/providers/user_data_service_provider.dart';
import 'package:instagram_app/utils/api.dart' as api;
import 'package:instagram_app/models/user.dart';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:instagram_app/utils/func.dart';

//stateless quindi quando si fa hot refresh si perdono i dati nei text field
class MyLoginPage extends StatelessWidget {
  MyLoginPage({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  static const String pageRoute = '/login';

  login(context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    var apiKey = await api.UserApi.login(username, password);

    if (apiKey is String) {
      // api.apiKey = apiKey;

      User userProfile = User.fromJsonMap(await api.UserApi.userProfile(username));
      userProfile.apiKey = apiKey;

      // UserDataServiceProvider(userData: userProfile, child: MainLevelWidget());

      UserDataServiceProvider.of(context).update(userProfile);
      LocalStorage.saveUserData(userProfile);
      LocalStorage.login();

      LocalStorage.saveApiKey(apiKey);

      print(userProfile.toJsonString());

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));

    } else {
      // manage state
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(24),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'Instagram',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _usernameController,
                    decoration:
                        InputDecoration(labelText: 'Inserisci username'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _passwordController,
                    decoration:
                        InputDecoration(labelText: 'Inserisci password'),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      login(context);
                    },
                    child: const Text('Login')),
                const SizedBox(
                  height: 25,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
