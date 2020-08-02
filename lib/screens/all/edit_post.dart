import 'package:aegeeapp/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class EditPost extends StatefulWidget {
  final String postID;
  final String title;
  final String image;
  final String text;
  final String date;

  EditPost(this.postID, this.title, this.image, this.text, this.date);

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final CollectionReference postCollection =
      Firestore.instance.collection('posts');

  final _formKey = GlobalKey<FormState>();

  String title;
  String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: widget.title,
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
                  initialValue: widget.text,
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
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  color: Colors.indigo[500],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      try {
                        if (title == null && text != null) {
                          await postCollection
                              .document(widget.postID)
                              .updateData(
                                  {'title': widget.title, 'text': text});
                        } else if (text == null && title != null) {
                          await postCollection
                              .document(widget.postID)
                              .updateData(
                                  {'title': title, 'text': widget.text});
                        } else if (text == null && title == null) {
                          await postCollection
                              .document(widget.postID)
                              .updateData(
                                  {'title': widget.title, 'text': widget.text});
                        } else {
                          await postCollection
                              .document(widget.postID)
                              .updateData({'title': title, 'text': text});
                        }

                        Toast.show("Edited", context,
                            duration: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.lightGreen);
                        Navigator.popUntil(context, (route) => route.isFirst);
                      } catch (e) {
                        print(e.message);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(e.message),
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
