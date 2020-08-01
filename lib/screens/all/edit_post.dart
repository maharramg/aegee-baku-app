import 'dart:io';
import 'package:aegeeapp/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';

class EditPost extends StatefulWidget {
  final String postID;
  final String title;
  final String image;
  final String text;

  EditPost(this.postID, this.title, this.image, this.text);

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final CollectionReference postCollection =
      Firestore.instance.collection('posts');

  final _formKey = GlobalKey<FormState>();

  File _image;
  String imageLocation;

  String title;
  String image;
  String date;
  String publisher = "Admin";
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
                RaisedButton(
                  color: Colors.indigo[500],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  child: Text(
                    'Upload an image',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    getImage();
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
                        // Get image URL from firebase
                        final ref = FirebaseStorage().ref().child(imageLocation);
                        var imageString = await ref.getDownloadURL();

                        // Set current date
                        setDate();

                        await postCollection
                            .document(widget.postID)
                            .updateData({
                          'title': title,
                          'date': date,
                          'image': imageString,
                          'publisher': publisher,
                          'text': text
                        });

                        Toast.show("Posted", context,
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

  void setDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm \n EEE-d-MMM').format(now);
    date = formattedDate;
  }

  Future getImage() async {
    // Get image from gallery.
    // ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _uploadImageToFirebase(_image);
  }

  Future<void> _uploadImageToFirebase(File image) async {
    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('kk-mm-ss-EEE-d-MMM').format(now);
      imageLocation = 'images/image$formattedDate.png';

      // Upload image to firebase.
      final StorageReference storageReference =
          FirebaseStorage().ref().child(imageLocation);
      final StorageUploadTask uploadTask = storageReference.putFile(image);
      await uploadTask.onComplete;
    } catch (e) {
      print(e.message);
    }
  }
}
