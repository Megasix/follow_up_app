import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/lawso/AndroidStudioProjects/follow_up_app/lib/shared/features/twitter.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/shared/constants.dart';
import 'package:follow_up_app/shared/features/apple.dart';
import 'package:follow_up_app/shared/features/google.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:follow_up_app/shared/features/facebook.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    //default gap between two elements
    const sameTypePadding = 5.0;
    const generalPadding = 10.0;


    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[50],
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 70.0),

              GoogleSignInButton(onPressed: () async{},),

              SizedBox(height: sameTypePadding,),

              FacebookSignInButton(onPressed: () async{},),

              SizedBox(height: sameTypePadding),

              TwitterSignInButton(onPressed: () async{},),

              SizedBox(height: sameTypePadding,),

              AppleSignInButton(onPressed: () async {}, darkMode: false,),

              SizedBox(height: generalPadding,),

              // email field
              /*TextFormField(
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
                validator: (val) =>
                    val.length < 4 ? 'Enter at least 5 characters' : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: sameTypePadding),
              RaisedButton(
                  color: Colors.blueGrey,
                  child: Text('Sign In', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() => loading = true);
                      dynamic result = await _authService
                          .signInWithEmailAndPassword(email, password);
                      if (result == null)
                        setState(() {
                          error = 'There was an error using these credential please retry';
                          loading = false;
                        });
                    }
                  }),
              SizedBox(height: 8.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )*/
            ],
          ),
        ),
      ),
    );
  }
}
