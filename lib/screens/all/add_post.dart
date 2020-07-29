import 'package:aegeeapp/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final CollectionReference postCollection =
      Firestore.instance.collection('posts');

  final _formKey = GlobalKey<FormState>();

  String title;
  String image;
  String date;
  String publisher;
  String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    hintText: 'title',
                  ),
                  validator: (val) => val.length < 1
                      ? 'Title must be at least 1 character'
                      : null,
                  onChanged: (val) {
                    title = val;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    hintText: 'image',
                  ),
                  validator: (val) => val.length < 1
                      ? 'Title must be at least 1 character'
                      : null,
                  onChanged: (val) {
                    image = val;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    hintText: 'date',
                  ),
                  validator: (val) => val.length < 1
                      ? 'Title must be at least 1 character'
                      : null,
                  onChanged: (val) {
                    date = val;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    hintText: 'publisher',
                  ),
                  validator: (val) => val.length < 1
                      ? 'Title must be at least 1 character'
                      : null,
                  onChanged: (val) {
                    publisher = val;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    hintText: 'text',
                  ),
                  validator: (val) => val.length < 1
                      ? 'Title must be at least 1 character'
                      : null,
                  onChanged: (val) {
                    text = val;
                  },
                ),
                RaisedButton(
                    color: Colors.indigo[500],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await postCollection.add({
                          'title': title,
                          'date': date,
                          'image': image,
                          'publisher': publisher,
                          'text': text
                        });
                        Toast.show("Posted", context,
                            duration: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.lightGreen);
                        Navigator.pop(context);
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
