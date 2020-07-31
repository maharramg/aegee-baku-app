import 'package:flutter/material.dart';

class PostScreen extends StatelessWidget {
  final String title;
  final String date;
  final String image;
  final String publisher;
  final String text;

  PostScreen(this.title, this.date, this.image, this.publisher, this.text);

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
              )
            ],
          ),
        ),
      ),
    );
  }
}
