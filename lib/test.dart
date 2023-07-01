// ignore_for_file: avoid_print

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:instagram_app/models/user.dart';
import 'utils/api.dart';
import 'package:logger/logger.dart';
import 'dart:convert';

var logger = Logger(printer: PrettyPrinter());

login(String username, String password) async {
  Uri url = Uri.http(host, PATHS['login']!);

  var response =
      await http.post(url, body: {'username': username, 'password': password});

  var data = json.decode(response.body);
  // print(data);
  if (response.statusCode == 200) {
    String apiKey = data['api_key'];
    return apiKey;
  }

  return null;
}

userProfile(String username) async {
  Uri url = Uri.http(host, PATHS['user_profile']! + username);
  var response = await http.get(url);

  var data = json.decode(response.body);

  return data;
}

getAllUsers() async {
  Uri url = Uri.http(host, PATHS['all_users']!);
  var response = await http.get(url);

  var data = json.decode(response.body);

  return data;
}

var session = SessionManager();

main() {
  // login('tino', 'test');
  // userProfile();

  // getAllUsers();

  startSession('tonino');
  getData();
}

void startSession(String username) async {
  // GET USER DATA AND SAVE IT IN SESSION

  var data = await userProfile(username);
  // String apiKey = await Configs.getApiKey();

  User user = User(
      'apiKey',
      data['ID'],
      username,
      data['descr'],
      data['email'],
      data['nPosts'],
      data['nFollowers'],
      data['nSeguiti'],
      data['profileImgUrl']);

  await session.set('userLogged', user);
}

void getData() async {
  var data = await session.get('user');
  print(data);
}
