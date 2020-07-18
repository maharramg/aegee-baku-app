import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;

  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future updateUserData(String firstName, String lastName) async {
    return await userCollection.document(uid).setData({
      'first_name': firstName,
      'last_name': lastName,
    });
  }
}
