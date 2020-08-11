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

  final Query postSeminarCollection = Firestore.instance
      .collection('posts')
      .where('type', isEqualTo: 'seminar');

  final Query postWebinarCollection = Firestore.instance
      .collection('posts')
      .where('type', isEqualTo: 'webinar');

  final Query postUniversitiesCollection = Firestore.instance
      .collection('posts')
      .where('type', isEqualTo: 'universities');

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

  // get all posts
  List<Post> _allPostsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Post(
        doc.data['title'] ?? '',
        doc.data['date'] ?? '',
        doc.data['image'],
        doc.data['type'] ?? '',
        doc.data['text'] ?? '',
      );
    }).toList();
  }

  // get all posts stream
  Stream<List<Post>> get posts {
    return postCollection.snapshots().map(_allPostsListFromSnapshot);
  }

  // get seminar posts
  List<Post> _seminarPostsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Post(
        doc.data['title'] ?? '',
        doc.data['date'] ?? '',
        doc.data['image'],
        doc.data['type'] ?? '',
        doc.data['text'] ?? '',
      );
    }).toList();
  }

  // get webinar posts stream
  Stream<List<Post>> get postsWebinar {
    return postWebinarCollection.snapshots().map(_webinarPostsListFromSnapshot);
  }

  // get webinar posts
  List<Post> _webinarPostsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Post(
        doc.data['title'] ?? '',
        doc.data['date'] ?? '',
        doc.data['image'],
        doc.data['type'] ?? '',
        doc.data['text'] ?? '',
      );
    }).toList();
  }

  // get seminar posts stream
  Stream<List<Post>> get postsSeminar {
    return postSeminarCollection.snapshots().map(_seminarPostsListFromSnapshot);
  }

  // get universities posts
  List<Post> _universitiesPostsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Post(
        doc.data['title'] ?? '',
        doc.data['date'] ?? '',
        doc.data['image'],
        doc.data['type'] ?? '',
        doc.data['text'] ?? '',
      );
    }).toList();
  }

  // get universities posts stream
  Stream<List<Post>> get postsUniversities {
    return postUniversitiesCollection
        .snapshots()
        .map(_universitiesPostsListFromSnapshot);
  }
}
