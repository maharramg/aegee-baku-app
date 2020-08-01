import 'package:aegeeapp/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'edit_post.dart';

class PostScreen extends StatelessWidget {
  final String title;
  final String date;
  final String image;
  final String publisher;
  final String text;

  PostScreen(this.title, this.date, this.image, this.publisher, this.text);

  String postID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              Image(
                image: NetworkImage(image),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(text),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: adminFeature(context),
    );
  }

  Widget adminFeature(BuildContext context) {
    if (Variable.isAdmin == true) {
      return FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () async {
          await Firestore.instance
              .collection('posts')
              .where("image", isEqualTo: image)
              .getDocuments()
              .then((value) => postID = value.documents[0].documentID);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditPost(postID, title, image, text)));
        },
      );
    } else {
      return Container();
    }
  }
}
