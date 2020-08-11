import 'dart:io';

import 'package:aegeeapp/models/user.dart';
import 'package:aegeeapp/services/database.dart';
import 'package:aegeeapp/shared/constants.dart';
import 'package:aegeeapp/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  bool _isAdmin;

  File _image;
  String imageLocation;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return StreamBuilder(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loading();
        }
        UserData userData = snapshot.data;
        _isAdmin = userData.admin;
        return Container(
          color: ColorsGlobal.profile,
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                userAvatar(userData.avatar),
                SizedBox(height: 20),
                RaisedButton(
                  child: Text("Select an image"),
                  onPressed: () async {
                    getAndUploadImage();
                  },
                ),
                RaisedButton(
                  child: Text("Upload image"),
                  onPressed: () async {
                    if (imageLocation != null) {
                      try {
                        final ref =
                            FirebaseStorage().ref().child(imageLocation);
                        var imageString = await ref.getDownloadURL();

                        //UPDATE USER DATA
                        await userCollection
                            .document(user.uid)
                            .updateData({'avatar': imageString});
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
                        "Please select an image first !",
                        context,
                        duration: Toast.LENGTH_LONG,
                      );
                    }
                  },
                ),
                SizedBox(height: 20),
                Text(
                  "${userData.firstName} ${userData.lastName}",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                adminFeature(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget adminFeature() {
    if (_isAdmin == true) {
      return Text("You are an admin");
    } else {
      return Container();
    }
  }

  userAvatar(String _avatar) {
    if (_avatar == null) {
      return CircleAvatar(
        backgroundImage: NetworkImage(Variable.noProfilePicture),
        radius: 60,
      );
    } else {
      return CircleAvatar(
        backgroundImage: NetworkImage(_avatar),
        radius: 60,
      );
    }
  }

  Future getAndUploadImage() async {
    // Get image from gallery.
    // ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);

    // Make random image name.
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk-mm-ss-EEE-d-MMM').format(now);
    imageLocation = 'avatars/avatar$formattedDate.jpg';

    // Upload image to firebase.
    final StorageReference storageReference =
        FirebaseStorage().ref().child(imageLocation);
    final StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
  }
}
