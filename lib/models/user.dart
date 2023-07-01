import 'dart:convert';

class OtherUser {
  late String username, descr, email, profileImgUrl;
  late int id, nPosts, nFollowers, nSeguiti;

  OtherUser(this.id, this.username, this.descr, this.email, this.nPosts,
      this.nFollowers, this.nSeguiti, this.profileImgUrl);

  OtherUser.vacand();

  OtherUser.fromJsonMap(Map<String, dynamic> json) {
    OtherUser(
        id = json['ID'],
        username = json['username'],
        descr = json['descr'],
        email = json['email'],
        nPosts = json['nPosts'],
        nFollowers = json['nFollowers'],
        nSeguiti = json['nSeguiti'],
        profileImgUrl = json['profile_img_url']);
  }

  String toJsonString() {
    return jsonEncode({
      'ID': id,
      'username': username,
      'descr': descr,
      'email': email,
      'nPosts': nPosts,
      'nFollowers': nFollowers,
      'nSeguiti': nSeguiti,
      'profile_img_url': profileImgUrl,
    });
  }
}

class User extends OtherUser {
  late String apiKey;

  late var followers;
  late var posts;

  User(this.apiKey, super.id, super.username, super.descr, super.email,
      super.nPosts, super.nFollowers, super.nSeguiti, super.profileImgUrl);

  // per inizializzare l'app
  User.vacand() : super.vacand();

  User.fromJsonMap(Map<String, dynamic> json, {bool readApiKey = false})
      : super(
          json['ID'],
          json['username'],
          json['descr'],
          json['email'],
          json['nPosts'],
          json['nFollowers'],
          json['nSeguiti'],
          json['profile_img_url'],
        ) {
    if (readApiKey) apiKey = json['api_key'];
  }

  @override
  String toJsonString() {
    return jsonEncode({
      'ID': id,
      'username': username,
      'descr': descr,
      'email': email,
      'nPosts': nPosts,
      'nFollowers': nFollowers,
      'nSeguiti': nSeguiti,
      'profile_img_url': profileImgUrl,
      'api_key': apiKey
    });
  }

  Map<String, dynamic> toJsonMap() {
    return {
      'ID': id,
      'username': username,
      'descr': descr,
      'email': email,
      'nPosts': nPosts,
      'nFollowers': nFollowers,
      'nSeguiti': nSeguiti,
      'profile_img_url': profileImgUrl,
      'api_key': apiKey
    };
  }
}
