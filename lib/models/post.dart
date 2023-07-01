class Post {
  int id, likes = 0;
  String url, owner;

  late final comments = [], descr = "";

  Post(this.id, this.url, this.owner);
}
