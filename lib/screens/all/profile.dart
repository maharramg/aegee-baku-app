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
import 'package:permission_handler/permission_handler.dart';
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

  String imageLocation;
  String imageUrl;

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
                  child: Text("Upload image"),
                  onPressed: () async {
                    await getAndUploadImage();

                    if (imageUrl != null) {
                      try {
                        //UPDATE USER DATA
                        await userCollection
                            .document(user.uid)
                            .updateData({'avatar': imageUrl});
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
          imageLocation = 'avatar/avatar$formattedDate.png';

          var snapshot = await _storage
              .ref()
              .child(imageLocation)
              .putFile(file)
              .onComplete;

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
