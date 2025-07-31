class Post {
  final String postId;
  final String description;
  final String codUtente;
  // final int interactions;
  final String createdAt;
  final String imgUrl;
  // bool isVisible = false;

  // final comments = [];
  // late int nLikes;

  Post({
    required this.description,
    required this.postId,
    // required this.interactions,
    required this.createdAt,
    required this.imgUrl,
    // required this.isVisible,
    required this.codUtente,
  });

  static Post fromSnap(Map<String, dynamic> snapshot) {
    // var snapshot = snapshot.data() as Map<String, dynamic>;

    return Post(
        // isVisible: snapshot["visibile"],
        // twittTitle: snapshot["twittTitle"],
        description: snapshot["description"] ?? "",
        postId: snapshot["id"],

        // interactions: snapshot["interazioni"],
        createdAt: snapshot["created_at"],
        imgUrl: snapshot['imgUrl'] ?? "",
        codUtente: snapshot["codUtente"]);
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "id": postId,
        // "interactions": interactions,
        "created_at": createdAt,
        'postUrl': imgUrl,
        // "isVisible": isVisible,
        "codUtente": codUtente
      };
}
