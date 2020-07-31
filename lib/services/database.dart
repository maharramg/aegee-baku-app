import 'package:aegeeapp/models/post.dart';
import 'package:aegeeapp/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  final CollectionReference postCollection =
      Firestore.instance.collection('posts');

  Future updateUserData(
      String firstName, String lastName, String email, String password) async {
    return await userCollection.document(uid).setData({
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'admin': false,
      'avatar': null
    });
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      firstName: snapshot.data['first_name'],
      lastName: snapshot.data['last_name'],
      email: snapshot.data['email'],
      password: snapshot.data['password'],
      admin: snapshot.data['admin'],
      avatar: snapshot.data['avatar'],
    );
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  List<Post> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Post(
        doc.data['title'] ?? '',
        doc.data['date'] ?? '',
        doc.data['image'],
        doc.data['publisher'] ?? '',
        doc.data['text'] ?? '',
      );
    }).toList();
  }

  // get posts stream
  Stream<List<Post>> get posts {
    return postCollection.snapshots().map(_postListFromSnapshot);
  }
}
