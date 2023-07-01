import 'package:flutter/material.dart';
import 'package:instagram_app/models/post.dart';
import 'package:instagram_app/widgets/post_widget.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key, required this.currentPost});

  final Post currentPost;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Post'),
      ),
      body: PostWidget(openedPost: currentPost),
    );
  }
}
