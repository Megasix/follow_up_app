import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:follow_up_app/shared/features/twitter.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/shared/constants.dart';
import 'package:follow_up_app/shared/features/apple.dart';
import 'package:follow_up_app/shared/features/google.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:follow_up_app/shared/features/facebook.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:get/get.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  Alignment childAlignement = Alignment.center;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  _SignInState() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          childAlignement = visible ? Alignment.topCenter : Alignment.center;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //default gap between two elements
    const sameTypePadding = 10.0;
    const generalPadding = 20.0;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.width;

    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            resizeToAvoidBottomInset: false,
            body: AnimatedContainer(
              curve: Curves.easeOut,
              duration: Duration(milliseconds: 400),
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.all(0),
              alignment: childAlignement,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 100),
                    Text('FOLLOW UP LOGO'),
                    SizedBox(height: 100),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(40.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0),
                          ),
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: textInputDecoration.copyWith(hintText: 'Email'),
                              validator: (val) => val.isEmpty ? 'Enter an Email' : null,
                              onChanged: (val) {
                                setState(() => email = val);
                              },
                            ),
                            SizedBox(height: sameTypePadding),
                            // password field
                            TextFormField(
                              decoration: textInputDecoration.copyWith(hintText: 'Password'),
                              validator: (val) => val.length < 4 ? 'Enter at least 5 characters' : null,
                              obscureText: true,
                              onChanged: (val) {
                                setState(() => password = val);
                              },
                            ),
                            SizedBox(height: generalPadding),

                            SizedBox(
                              width: screenWidth,
                              height: 40.0,
                              child: RaisedButton(
                                  child: Text('Sign In', style: TextStyle(color: Colors.white)),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() => loading = true);
                                      dynamic result = await _authService.signInWithEmailAndPassword(email, password);
                                      if (result == null)
                                        setState(() {
                                          error = 'There was an error using these credential please retry';
                                          loading = false;
                                        });
                                    }
                                  }),
                            ),

                            SizedBox(height: generalPadding),

                            Text('OR SIGN IN WITH'),

                            SizedBox(height: generalPadding),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GoogleSignInButton(onPressed: () async {}),
                                SizedBox(width: sameTypePadding),
                                FacebookSignInButton(onPressed: () async {}),
                                SizedBox(width: sameTypePadding),
                                TwitterSignInButton(onPressed: () async {}),
                                SizedBox(width: sameTypePadding),
                                AppleSignInButton(onPressed: () async {}, darkMode: !lightThemeEnabled),
                              ],
                            ),

                            SizedBox(height: generalPadding),

                            FlatButton(
                              child: Text('CREATE A FREE ACCOUNT'),
                              onPressed: () {
                                widget.toggleView();
                              },
                            ),

                            SizedBox(height: 8.0),
                            Text(
                              error,
                              style: TextStyle(color: Colors.red, fontSize: 14.0),
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
