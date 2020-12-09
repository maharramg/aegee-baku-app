import 'package:aegeeapp/models/post.dart';
import 'package:aegeeapp/screens/all/post/post_screen.dart';
import 'package:aegeeapp/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostTile extends StatelessWidget {
  final Post post;

  PostTile(this.post);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen(post.title, post.date.toString(), post.image, post.type, post.text)));
      },
      child: Container(
        height: 200,
        width: double.infinity,
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: NetworkImage(post.image),
            fit: BoxFit.cover,
          ),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: Window.height(context, 220),
                    child: Text(
                      post.title,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: getColor(post.type),
                    ),
                    child: Text(
                      post.type,
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Color getColor(String type) {
    if (type == "seminar") {
      return Colors.orange;
    } else if (type == "webinar") {
      return Colors.red;
    } else if (type == "universities") {
      return Colors.greenAccent;
    } else {
      return Colors.blueGrey;
    }
  }
}
