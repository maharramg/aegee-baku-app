import 'package:aegeeapp/models/post.dart';
import 'package:aegeeapp/models/user.dart';
import 'package:aegeeapp/screens/all/add_post.dart';
import 'package:aegeeapp/screens/all/post_screen.dart';
import 'package:aegeeapp/services/database.dart';
import 'package:aegeeapp/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isAdmin;

  final CollectionReference postCollection =
      Firestore.instance.collection('posts');

  final List<Post> posts = [
    Post("AEGEE Meeting", DateTime.now(), "assets/posts/image1.jpg",
        "Elshad Ismayilov", "AEGEE Meeting was great."),
    Post("Winter Camp in Shaki", DateTime.now(), "assets/posts/image2.jpg",
        "Maharram Guliyev", "We had an amazing trip."),
    Post("Winter Camp", DateTime.now(), "assets/posts/image3.jpg",
        "Elshad Ismayilov", "We loved it so much!"),
  ];

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return Scaffold(
      body: StreamBuilder(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          }
          UserData userData = snapshot.data;
          _isAdmin = userData.admin;

          return Container(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (BuildContext context, int index) =>
                  buildPostCard(context, index),
            ),
          );
        },
      ),
      floatingActionButton: adminFeature(),
    );
  }

  Future _getPosts() async{
     await postCollection.getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((post) {
        posts.add(Post(
            post.data['title'],
            DateTime.now(),
            "assets/posts/image1.jpg",
            post.data['publisher'],
            post.data['text']));
      });
    });
  }

  Widget adminFeature() {
    if (_isAdmin == true) {
      return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPost()));
        },
      );
    } else {
      return Container();
    }
  }

  Widget buildPostCard(BuildContext context, int index) {
    final Post item = posts[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostScreen(
                    item.title,
                    item.date.toString(),
                    item.image,
                    item.publisher,
                    item.text)));
      },
      child: Container(
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
      ),
    );
  }
}
