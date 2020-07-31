import 'package:aegeeapp/models/post.dart';
import 'package:aegeeapp/screens/all/post_screen.dart';
import 'package:flutter/material.dart';

class PostTile extends StatelessWidget {
  final Post post;

  PostTile(this.post);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostScreen(
                    post.title,
                    post.date.toString(),
                    post.image,
                    post.publisher,
                    post.text)));
      },
      child: Container(
        height: 200,
        margin: EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image:
              DecorationImage(image: NetworkImage(post.image), fit: BoxFit.cover),
        ),
        child: Container(
          padding: EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(.9),
                Colors.black.withOpacity(.0),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(post.title,
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              Text(post.publisher,
                  style: TextStyle(color: Colors.white, fontSize: 10)),
              Text(post.date.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}
