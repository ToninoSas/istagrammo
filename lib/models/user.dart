import 'dart:convert';

class User {
  // late String apiKey;

  late String username, bio, email, profileImgUrl;
  late int id, nPosts, nFollowers, nSeguiti;

  late var followers;
  late var posts;

  late Map<String, dynamic> jsonMap;

  User(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    bio = json['bio'];
    email = json['email'];
    nPosts = json['n_posts'];
    nFollowers = json['n_followers'];
    nSeguiti = json['n_seguiti'];
    profileImgUrl = json['profile_img_url'];

    jsonMap = {
      'id': id,
      'username': username,
      'bio': bio,
      'email': email,
      'n_posts': nPosts,
      'n_followers': nFollowers,
      'n_seguiti': nSeguiti,
      'profile_img_url': profileImgUrl,
    };
  }

  // per inizializzare l'app
  User.vacand();

  String toJsonString() {
    return jsonEncode(jsonMap);
  }

  Map<String, dynamic> getJsonMap() {
    return jsonMap;
  }
}

class AuthUser extends User {
  late String apiKey;
  late Map<String, dynamic> json;

  AuthUser(this.json) : super(json) {
    // apiKey = json['api_key'];
  }

  AuthUser.vacand() : super.vacand();

  // void readApiKey() {
  //   apiKey = json['api_key'];
  //   super.jsonMap.update('api_key', (value) => apiKey);
  // }

  void setApiKey(apiKey) {
    this.apiKey = apiKey;
    super.jsonMap['api_key'] = apiKey;
  }

  void setPosts(posts) {
    super.posts = posts;
  }
}
