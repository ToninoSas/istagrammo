// ignore_for_file: avoid_print
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:instagram_app/models/user.dart';

String host = kIsWeb
    ? '127.0.0.1:5000'
    : Platform.isAndroid
        ? '10.0.2.2:5000'
        : '127.0.0.1:5000';

class Paths {
  static String login = '/api/users/login';
  static String newUser = '/api/users/new';
  static String allUsers = '/api/users';

  static var allUserFollowers =
      (String username) => '/api/users/active/$username/followers';

  static var userProfile = (String username) => '/api/users/active/$username';

  static var userPosts =
      (String username) => '/api/users/active/$username/posts';
  static var userPost =
      (String username, int postId) => '/api/users/active/$username/posts/$postId';

  static var followUser = (String usernameToFollow, String username) =>
      '/api/users/active/$usernameToFollow/followers/$username';

  static var removeFollowUser = (String usernameToRemoveFollow,
          String username) =>
      '/api/users/active/$usernameToRemoveFollow/followers/$username/remove';

  static String syn = '/api/auth/syn';
  static String logOut = '/api/auth/logout';

  static var like = (String username, String postId) =>
      '/api/users/active/$username/posts/$postId/likes';
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

  static followUser(String usernameToFollow, AuthUser currentUser) async {
    Uri url = Uri.http(
        host, Paths.followUser(usernameToFollow, currentUser.username));

    var response = await http.post(url, body: {"api_key": currentUser.apiKey});

    print(response.body.toString());
    print(response.statusCode);

    return response.statusCode;
  }

  static removeFollowUser(
      String usernameToRemoveFollow, AuthUser currentUser) async {
    Uri url = Uri.http(host,
        Paths.removeFollowUser(usernameToRemoveFollow, currentUser.username));

    var response =
        await http.delete(url, body: {"api_key": currentUser.apiKey});

    print(response.body.toString());
    print(response.statusCode);

    return response.statusCode;
  }

  static Future<List> getUserFollowers(String username) async {
    Uri url = Uri.http(host, Paths.allUserFollowers(username));

    var response = await http.get(url);

    print(response.statusCode);
    print(response.body);

    var data = json.decode(response.body);

    return data;
  }

  
}

class PostApi {
  static Future<List> getUserPosts(String username) async {
    Uri url = Uri.http(host, Paths.userPosts(username));

    var response = await http.get(url);

    print(response.statusCode);
    print(response.body);

    var data = json.decode(response.body);

    return data;
  }

  static getPost(String username, int postId) async {
    Uri url = Uri.http(host, Paths.userPost(username, postId));

    var response = await http.get(url);

    print(response.statusCode);
    print(response.body);

    var data = json.decode(response.body);

    return data;
  }
  static addLike(String postOwner, String postId, String currentUsername) async {
    Uri url = Uri.http(host, Paths.like(postOwner, postId));

    var response = await http.post(url, body: {'like_by':currentUsername});

    print(response.statusCode);
    print(response.body);

    return response.statusCode;
  }

  static removeLike(String username, String postId, String currentUsername) async {
    Uri url = Uri.http(host, Paths.like(username, postId));

    var response = await http.delete(url, body: {'like_by':currentUsername});

    print(response.statusCode);
    print(response.body);

    return response.statusCode;
  }
}

class Auth {
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

  static logout(String apiKey) async {
    Uri url = Uri.http(host, Paths.logOut);
    var response = await http.delete(url, body: {'api_key': apiKey});

    print(response.statusCode);
    print(response.body);

    return response.statusCode;
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
