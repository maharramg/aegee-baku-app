import 'package:aegeeapp/models/post.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Post> titles = [
    Post("AEGEE Meeting", DateTime.now(), "assets/posts/image1.jpg",
        "Elshad Ismayilov"),
    Post("Winter Camp in Shaki", DateTime.now(), "assets/posts/image2.jpg",
        "Maharram Guliyev"),
    Post("Winter Camp", DateTime.now(), "assets/posts/image3.jpg",
        "Elshad Ismayilov"),
    Post("AEGEE Meeting", DateTime.now(), "assets/posts/image1.jpg",
        "Elshad Ismayilov"),
    Post("Winter Camp in Shaki", DateTime.now(), "assets/posts/image2.jpg",
        "Maharram Guliyev"),
    Post("Winter Camp", DateTime.now(), "assets/posts/image3.jpg",
        "Elshad Ismayilov"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: titles.length,
          itemBuilder: (BuildContext context, int index) =>
              buildPostCard(context, index)),
    );
  }

  Widget buildPostCard(BuildContext context, int index) {
    final Post item = titles[index];
    return Container(
      height: 200,
      margin: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image:
            DecorationImage(image: AssetImage(item.image), fit: BoxFit.cover),
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
            Text(item.title,
                style: TextStyle(color: Colors.white, fontSize: 20)),
            Text(item.publisher,
                style: TextStyle(color: Colors.white, fontSize: 10)),
            Text(item.date.toString(),
                style: TextStyle(color: Colors.white, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
