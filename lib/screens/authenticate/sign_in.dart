import 'package:aegeeapp/animations/fade_animation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:aegeeapp/services/auth.dart';
import 'package:aegeeapp/shared/constants.dart';
import 'package:aegeeapp/shared/loading.dart';
import 'package:toast/toast.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    FadeAnimation(
                      1,
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/background1.png'),
                              fit: BoxFit.cover),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                                top: 30,
                                right: 60,
                                width: 400,
                                height: 200,
                                child: FadeAnimation(
                                  1,
                                  Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/girl.png'),
                                      ),
                                    ),
                                  ),
                                )),
                            Positioned(
                              child: FadeAnimation(
                                  1.4,
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        30.0, 140.0, 60.0, 0),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 20.0),
                            FadeAnimation(
                              1.6,
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                  hintText: 'Email',
                                  icon: Icon(Icons.email),
                                ),
                                validator: (val) =>
                                    val.isEmpty ? 'Enter an email' : null,
                                onChanged: (val) {
                                  setState(() => email = val);
                                },
                              ),
                            ),
                            SizedBox(height: 20.0),
                            FadeAnimation(
                              1.8,
                              TextFormField(
                                obscureText: true,
                                decoration: textInputDecoration.copyWith(
                                  hintText: 'Password',
                                  icon: Icon(Icons.fingerprint),
                                ),
                                validator: (val) => val.length < 6
                                    ? 'Enter a password 6+ chars long'
                                    : null,
                                onChanged: (val) {
                                  setState(() => password = val);
                                },
                              ),
                            ),
                            SizedBox(height: 20.0),
                            ButtonTheme(
                              minWidth: 100.0,
                              height: 40.0,
                              child: FadeAnimation(
                                2,
                                RaisedButton(
                                    color: Colors.indigo[500],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0)),
                                    child: Text(
                                      'Sign In',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        setState(() => loading = true);
                                        dynamic result = await _auth
                                            .signInWithEmailAndPassword(
                                                email, password);
                                        Toast.show("Logged In", context,
                                            duration: Toast.LENGTH_SHORT,
                                            backgroundColor: Colors.lightGreen);
                                        if (result == null) {
                                          setState(() {
                                            loading = false;
                                            error =
                                                'Could not sign in with those credentials';
                                          });
                                          Toast.show("Error log in", context,
                                              duration: Toast.LENGTH_LONG,
                                              backgroundColor: Colors.red);
                                        }
                                      }
                                    }),
                              ),
                            ),
                            SizedBox(height: 12.0),
                            ButtonTheme(
                              minWidth: 100.0,
                              height: 40.0,
                              child: FadeAnimation(
                                2,
                                RaisedButton(
                                    color: Colors.indigo[500],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0)),
                                    child: Text(
                                      'Sign In as a Guest',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      setState(() => loading = true);
                                      dynamic result = await _auth.signInAnon();
                                      Toast.show("Logged In", context,
                                          duration: Toast.LENGTH_SHORT,
                                          backgroundColor: Colors.lightGreen);
                                      if (result == null) {
                                        setState(() {
                                          loading = false;
                                          error = 'Something went wrong';
                                        });
                                        Toast.show("Error log in", context,
                                            duration: Toast.LENGTH_LONG,
                                            backgroundColor: Colors.red);
                                      }
                                    }),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            FadeAnimation(
                              2,
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.0),
                                  children: <TextSpan>[
                                    TextSpan(text: "Don't have an account? "),
                                    TextSpan(
                                      text: "Register",
                                      style:
                                          TextStyle(color: Colors.blueAccent),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          widget.toggleView();
                                        },
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              error,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
