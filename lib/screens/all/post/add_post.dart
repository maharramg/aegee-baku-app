import 'dart:io';
import 'package:aegeeapp/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final CollectionReference postCollection =
      Firestore.instance.collection('posts');

  final _formKey = GlobalKey<FormState>();

  File _image;
  String imageLocation;

  String title;
  String image;
  String date;
  String type;
  String text;

  String searchKey;
  int _value = 1;

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
                RaisedButton(
                  color: Colors.indigo[500],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  child: Text(
                    'Upload an image',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    getAndUploadImage();
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
                  maxLines: null,
                  onChanged: (val) {
                    text = val;
                  },
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
                      if (imageLocation != null) {
                        try {
                          // Get image URL from firebase
                          final ref =
                              FirebaseStorage().ref().child(imageLocation);
                          var imageString = await ref.getDownloadURL();

                          // Set current date
                          setDate();

                          await postCollection.add({
                            'title': title,
                            'date': date,
                            'image': imageString,
                            'type': type,
                            'text': text,
                            'searchKey': searchKey,
                          });

                          Toast.show("Posted", context,
                              duration: Toast.LENGTH_SHORT,
                              backgroundColor: Colors.lightGreen);
                          Navigator.pop(context);
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
                      } else {
                        Toast.show(
                          "Please upload an image !",
                          context,
                          duration: Toast.LENGTH_LONG,
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

  void setDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm \n EEE-d-MMM').format(now);
    date = formattedDate;
  }

  Future getAndUploadImage() async {
    try {
      // Get image from gallery.
      // ignore: deprecated_member_use
      _image = await ImagePicker.pickImage(source: ImageSource.gallery);

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('kk-mm-ss-EEE-d-MMM').format(now);
      imageLocation = 'images/image$formattedDate.png';

      // Upload image to firebase.
      final StorageReference storageReference =
          FirebaseStorage().ref().child(imageLocation);
      final StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;
    } catch (e) {
      print(e.message);
    }
  }
}
