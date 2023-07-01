// ignore_for_file: avoid_print

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:io' show Platform;

import 'package:instagram_app/models/user.dart';

String host = Platform.isAndroid ? '10.0.2.2:5000' : '127.0.0.1:5000';

class Paths {
  static String login = '/api/users/login';
  static String newUser = '/api/users/new';
  static String allUsers = '/api/users';

  static var allUserFollowers =
      (String username) => '/api/users/active/$username/followers';

  static var userProfile = (String username) => '/api/users/active/$username';

  static var userPosts =
      (String username) => '/api/users/active/$username/posts';

  static var followUser = (String usernameToFollow, String username) =>
      '/api/users/active/$usernameToFollow/followers/$username';

  static var removeFollowUser = (String usernameToRemoveFollow,
          String username) =>
      '/api/users/active/$usernameToRemoveFollow/followers/$username/remove';

  static String syn = '/api/auth/syn';
}

class UserApi {
  static Future<dynamic> userProfile(String username) async {
    // Uri url = Uri.http(host, '${PATHS['user_profile']!}$username');
    Uri url = Uri.http(host, Paths.userProfile(username));

    var response = await http.get(url);

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    return null;
  }

  static followUser(String usernameToFollow, User currentUser) async {
    Uri url = Uri.http(
        host, Paths.followUser(usernameToFollow, currentUser.username));

    var response = await http.post(url, body: {"api_key": currentUser.apiKey});

    print(response.body.toString());
    print(response.statusCode);

    var data = json.decode(response.body);

    return data;
  }

  static removeFollowUser(
      String usernameToRemoveFollow, User currentUser) async {
    Uri url = Uri.http(host,
        Paths.removeFollowUser(usernameToRemoveFollow, currentUser.username));

    var response =
        await http.delete(url, body: {"api_key": currentUser.apiKey});

    print(response.body.toString());
    print(response.statusCode);

    var data = json.decode(response.body);

    return data;
  }

  static Future<List> getUserFollowers(String username) async {
    Uri url = Uri.http(host, Paths.allUserFollowers(username));

    var response = await http.get(url);

    print(response.statusCode);
    print(response.body);

    var data = json.decode(response.body);

    return data;
  }

  static Future<List> getUserPosts(String username) async {
    Uri url = Uri.http(host, Paths.userPosts(username));

    var response = await http.get(url);

    print(response.statusCode);
    print(response.body);

    var data = json.decode(response.body);

    return data;
  }

  static Future<dynamic> login(String username, String password) async {
    Uri url = Uri.http(host, Paths.login);

    var response = await http
        .post(url, body: {'username': username, 'password': password});

    var data = json.decode(response.body);
    // print(data);
    if (response.statusCode == 200) {
      String apiKey = data['api_key'];

      return apiKey;
    }

    return null;
  }
}

class Auth {
  // richiesta al server per vedere se l'apikey è ancora valida
  static syn(String apiKey) async {
    Uri url = Uri.http(host, Paths.syn);
    var response = await http.post(url, body: {'api_key': apiKey});

    // var data = json.decode(response.body);

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }
}

Future<dynamic> getAllUsers() async {
  Uri url = Uri.http(host, Paths.allUsers);
  var response = await http.get(url);

  var data = json.decode(response.body);

  if (response.statusCode == 200) {
    return data;
  }

  return null;
}
