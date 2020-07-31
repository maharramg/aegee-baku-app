class User {
  final String uid;

  User({this.uid});
}

class UserData {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final bool admin;
  final String avatar;

  UserData({this.uid, this.firstName, this.lastName, this.email, this.password, this.admin, this.avatar});
}

