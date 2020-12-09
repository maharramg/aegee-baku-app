import 'dart:io';
import 'package:aegeeapp/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final CollectionReference postCollection = Firestore.instance.collection('posts');

  final _formKey = GlobalKey<FormState>();

  String imageLocation;
  String imageUrl;

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
      body: SingleChildScrollView(
        child: Container(
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
                    validator: (val) => val.length < 1 ? 'Title must be at least 1 character' : null,
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
                  (imageUrl != null)
                      ? Image.network(imageUrl)
                      : Placeholder(
                          fallbackHeight: 100,
                          fallbackWidth: double.infinity,
                        ),
                  RaisedButton(
                    color: Colors.indigo[500],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    child: Text(
                      'Upload an image',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
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
                    validator: (val) => val.length < 1 ? 'Title must be at least 1 character' : null,
                    maxLines: null,
                    onChanged: (val) {
                      text = val;
                    },
                  ),
                  RaisedButton(
                    color: Colors.indigo[500],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        if (imageUrl != null) {
                          try {
                            // Set current date
                            setDate();

                            await postCollection.add({
                              'title': title,
                              'date': date,
                              'image': imageUrl,
                              'type': type,
                              'text': text,
                              'searchKey': searchKey,
                            });

                            Toast.show("Posted", context, duration: Toast.LENGTH_SHORT, backgroundColor: Colors.lightGreen);
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
                          Toast.show("Please upload an image !", context, duration: Toast.LENGTH_LONG, backgroundColor: Colors.red);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void setDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm\nEEE-d-MMM').format(now);
    date = formattedDate;
  }

  getAndUploadImage() async {
    try {
      final _storage = FirebaseStorage.instance;
      final _picker = ImagePicker();
      PickedFile image;

      // Check Permission
      await Permission.photos.request();

      var permissionStatus = Permission.photos.status;

      bool isGranted = await permissionStatus.isGranted;

      if (isGranted) {
        // Select image
        image = await _picker.getImage(source: ImageSource.gallery);
        var file = File(image.path);

        if (image != null) {
          // Upload to firebase
          DateTime now = DateTime.now();
          String formattedDate = DateFormat('kk-mm-ss-EEE-d-MMM').format(now);
          imageLocation = 'images/image$formattedDate.png';

          var snapshot = await _storage.ref().child(imageLocation).putFile(file).onComplete;

          var downloadUrl = await snapshot.ref.getDownloadURL();

          setState(() {
            imageUrl = downloadUrl;
          });
        } else {
          print("No path received");
        }
      } else {
        print("Grant permission and try again");
      }
    } catch (e) {
      print(e.message);
    }
  }
}
