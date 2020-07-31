import 'package:aegeeapp/models/post.dart';
import 'package:aegeeapp/screens/all/post_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<Post>>(context) ?? [];


    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) =>
          PostTile(posts[index])
    );
  }
}
