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
  final String type;

  EditPost(
      this.postID, this.title, this.image, this.text, this.date, this.type);

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final CollectionReference postCollection =
      Firestore.instance.collection('posts');

  final _formKey = GlobalKey<FormState>();

  String title;
  String text;
  String type;

  String searchKey;

  int _value;

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
                    searchKey = title.substring(0, 1).toLowerCase();
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                DropdownButton(
                  value: _value,
                  items: [
                    DropdownMenuItem(
                      child: Text("Seminar"),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text("Webinar"),
                      value: 2,
                    ),
                    DropdownMenuItem(
                      child: Text("International event"),
                      value: 3,
                    ),
                    DropdownMenuItem(
                      child: Text("Universities"),
                      value: 4,
                    ),
                  ],
                  onChanged: (int value) {
                    setState(() {
                      _value = value;
                    });
                    if (_value == 1)
                      type = "seminar";
                    else if (_value == 2)
                      type = "webinar";
                    else if (_value == 3)
                      type = "international_event";
                    else
                      type = "universities";
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
                  maxLines: null,
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
                        if (title == null && text != null && type != null) {
                          await postCollection
                              .document(widget.postID)
                              .updateData({
                            'title': widget.title,
                            'text': text,
                            'type': type
                          });
                        } else if (text == null &&
                            title != null &&
                            type != null) {
                          await postCollection
                              .document(widget.postID)
                              .updateData({
                            'title': title,
                            'text': widget.text,
                            'type': type,
                            'searchKey': searchKey
                          });
                        } else if (type == null &&
                            text != null &&
                            title != null) {
                          await postCollection
                              .document(widget.postID)
                              .updateData({
                            'title': title,
                            'text': text,
                            'type': widget.type
                          });
                        } else if (text == null && title == null) {
                          await postCollection
                              .document(widget.postID)
                              .updateData(
                                  {'title': widget.title, 'text': widget.text});
                        } else {
                          await postCollection
                              .document(widget.postID)
                              .updateData(
                                  {'title': title, 'text': text, 'type': type});
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
