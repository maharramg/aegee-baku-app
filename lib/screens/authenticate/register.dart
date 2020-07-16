import 'package:aegeeapp/animations/fade_animation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:aegeeapp/services/auth.dart';
import 'package:aegeeapp/shared/constants.dart';
import 'package:aegeeapp/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
                                top: 90,
                                right: 115,
                                width: 300,
                                height: 150,
                                child: FadeAnimation(
                                  1,
                                  Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/boy.png'),
                                      ),
                                    ),
                                  ),
                                )),
                            Positioned(
                              child: FadeAnimation(
                                  1.4,
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        30.0, 140.0, 20.0, 0),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        "Register",
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
                                          BorderRadius.circular(30.0)),
                                  child: Text(
                                    'Register',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() => loading = true);
                                      dynamic result = await _auth
                                          .registerWithEmailAndPassword(
                                              email, password);
                                      if (result == null) {
                                        setState(
                                          () {
                                            loading = false;
                                            error =
                                                'Please supply a valid email';
                                          },
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 12.0),
                            FadeAnimation(
                              2,
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12.0),
                                  children: <TextSpan>[
                                    TextSpan(text: "Already have an account? "),
                                    TextSpan(
                                      text: "Sign in",
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
