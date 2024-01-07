import 'package:flutter/material.dart';

var routes = {'home': 0, 'search': 1, 'profile': 2};

void teleport(context, int selectedIndex) {
  switch (selectedIndex) {
    case 0:
      //push senza possibilità di tornare indietro,
      // quindi tolgono direttamente la freccia per tornare indietro
      // Navigator.pushReplacementNamed(context, '/home');

      Navigator.pushNamed(context, '/home');

      break;
    case 1:
      Navigator.pushReplacementNamed(context, '/search');
      break;
    case 2:
      Navigator.pushReplacementNamed(context, '/profile');
  }
}

void modifyProfile(context) {
  //push con possibilità di tornare indietro
  Navigator.pushNamed(context, '/modify_profile');
}

showSnackBar(String txt, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(txt)));
}

class LocalStorage {
  // static SharedPreferences prefs;

  // static saveUserData(User user) async {
  //   final prefs = await SharedPreferences.getInstance();
  //
  //   final userDataJson = jsonEncode(user.getJsonMap());
  //
  //   prefs.setString('userData', userDataJson);
  // }
  //
  // static Future<AuthUser?> getUserData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   // Retrieve the JSON string from shared preferences
  //   final userDataJson = prefs.getString('userData');
  //   if (userDataJson != null) {
  //     // If the JSON string exists, parse it into a UserDataModel object
  //     final userData = AuthUser(jsonDecode(userDataJson));
  //     return userData;
  //   }
  //   return null; // Return null if no user data is found
  // }
  //
  // static login(User userdata, String apiKey) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('loggedIn', true);
  //
  //   print('LOGIN EFFETTUATO E DATI SALVATI');
  //
  //   await saveUserData(userdata);
  //   await saveApiKey(apiKey);
  // }
  //
  // static logout() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // prefs.setBool('loggedIn', false);
  //   prefs.clear();
  // }
  //
  // static Future<bool> isLoggedIn() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool state = prefs.getBool('loggedIn') ?? false;
  //
  //   return state;
  // }
  //
  // static saveApiKey(String apiKey) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('api_key', apiKey);
  // }
  //
  // static getApiKey() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('api_key');
  // }
}
