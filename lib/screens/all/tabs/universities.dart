import 'package:aegeeapp/models/post.dart';
import 'package:aegeeapp/models/user.dart';
import 'package:aegeeapp/screens/all/post/post_list.dart';
import 'package:aegeeapp/services/database.dart';
import 'package:aegeeapp/shared/constants.dart';
import 'package:aegeeapp/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../post/add_post.dart';

class Universities extends StatefulWidget {
  @override
  _UniversitiesState createState() => _UniversitiesState();
}

class _UniversitiesState extends State<Universities> {
  bool _isAdmin;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return Container(
      child: StreamBuilder(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          }
          UserData userData = snapshot.data;
          _isAdmin = userData.admin;
          Variable.isAdmin = _isAdmin;

          return StreamProvider<List<Post>>.value(
            value: DatabaseService().postsUniversities,
            child: Scaffold(
              body: Container(
                child: PostList(),
              ),
              floatingActionButton: adminFeature(),
            ),
          );
        },
      ),
    );
  }

  Widget adminFeature() {
    if (_isAdmin == true) {
      return FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 8.0,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPost()));
        },
      );
    } else {
      return Container();
    }
  }
}
