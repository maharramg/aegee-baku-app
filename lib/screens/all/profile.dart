import 'dart:io';
import 'dart:math';

import 'package:aegeeapp/models/user.dart';
import 'package:aegeeapp/services/database.dart';
import 'package:aegeeapp/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                userAvatar(userData.avatar),
                SizedBox(height: 20),
                RaisedButton(
                  child: Text("Upload image"),
                  onPressed: () async {
                    try{
                      getImage();

                      final ref =
                      FirebaseStorage().ref().child(imageLocation);
                      var imageString = await ref.getDownloadURL();

                      //UPDATE USER DATA
                      await userCollection.document(user.uid).setData({
                        'first_name': userData.firstName,
                        'last_name': userData.lastName,
                        'email': userData.email,
                        'password': userData.password,
                        'admin': userData.admin,
                        'avatar': imageString
                      });

                    }catch(e){
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

  userAvatar(String _avatar){
    if(_avatar == null){
      return CircleAvatar(
        backgroundColor: Colors.red,
        radius: 60,
      );
    }
    else{
      return CircleAvatar(
        backgroundImage: NetworkImageWithRetry(_avatar),
        radius: 60,
      );
    }
  }

  Future getImage() async {
    // Get image from gallery.
    // ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _uploadImageToFirebase(_image);
  }

  Future<void> _uploadImageToFirebase(File image) async {
    try {
      // Make random image name.
      int randomNumber = Random().nextInt(100000);
      imageLocation = 'avatars/avatar$randomNumber.jpg';

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
