class Comment {
  final String commentId;
  final String codUtente;
  final String codPost;
  final String text;
  // final DateTime datePublished;

  Comment(
      {required this.commentId,
      required this.text,
      required this.codPost,
      required this.codUtente});

  static Comment fromSnap(Map<String, dynamic> snapshot) {
    // var snapshot = snap.data() as Map<String, dynamic>;

    return Comment(
      text: snapshot['text'],
      commentId: snapshot["id"],
      codUtente: snapshot["codUtente"],
      codPost: snapshot["codPost"],
    );
  }

  Map<String, dynamic> toJson() => {
        "text": text,
        "id": commentId,
        "codUtente": codUtente,
        "codPick": codPost
      };
}
