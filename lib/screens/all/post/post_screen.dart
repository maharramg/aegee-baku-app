import 'dart:ui';

import 'package:aegeeapp/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:toast/toast.dart';
import 'edit_post.dart';

// ignore: must_be_immutable
class PostScreen extends StatelessWidget {
  final String title;
  final String date;
  final String image;
  final String type;
  final String text;

  PostScreen(this.title, this.date, this.image, this.type, this.text);

  String postID;

  final CollectionReference postCollection = Firestore.instance.collection('posts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              titleSpacing: 20.0,
              floating: false,
              pinned: true,
              snap: false,
              expandedHeight: Window.height(context, 350),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(title),
                titlePadding: EdgeInsets.only(left: 50, bottom: 15),
                background: Image(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([buildBody()]),
            ),
          ],
        ),
      ),
      floatingActionButton: adminFeature(context),
    );
  }

  Widget buildBody() {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text("Date: $date"),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              text,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget adminFeature(BuildContext context) {
    if (Variable.isAdmin == true) {
      return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.edit),
              backgroundColor: Colors.green,
              label: 'Edit',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () async {
                await postCollection.where("image", isEqualTo: image).getDocuments().then((value) => postID = value.documents[0].documentID);

                Navigator.push(context, MaterialPageRoute(builder: (context) => EditPost(postID, title, image, text, date, type)));
              }),
          SpeedDialChild(
              child: Icon(Icons.delete_outline),
              backgroundColor: Colors.red,
              label: 'Delete',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () async {
                await postCollection.where("image", isEqualTo: image).getDocuments().then((value) => postID = value.documents[0].documentID);

                await postCollection.document(postID).delete();

                Toast.show("Deleted", context, duration: Toast.LENGTH_SHORT, backgroundColor: Colors.red);

                Navigator.popUntil(context, (route) => route.isFirst);
              }),
        ],
      );
    } else {
      return Container();
    }
  }
}
