import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:follow_up_app/shared/snackbar.dart';

class AdminLogin extends StatefulWidget {
  AdminLogin({Key? key}) : super(key: key);

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String username = '';
  String password = '';

  onNameChanged(val) {
    setState(() => username = val);
  }

  //when the name changes associate the corresponding state
  onPassChanged(val) {
    setState(() => password = val);
  }

  //function to validate name
  validateName(String? val) {
    return val == null || val.isEmpty ? "Username is incorrect" : null;
  }

  //function to validate password
  validatePass(String? val) {
    return val == null || val.isEmpty ? "Password is incorrect" : null;
  }

  //when we request sign in
  _onCredSubmit(context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await _requestSignIn(context);
    }
  }

  //request token from Firebase Auth
  _requestSignIn(context) async {
    await AuthService.signInWithEmailAndPassword(context, username, password);

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading //if we're communicating with the server, show the loading screen
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'SIGN IN',
              ),
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Tooltip(
                      message: 'Username used to sign into the Admin Dashboard',
                      child: TextFormField(
                        onChanged: (val) => onNameChanged(val),
                        validator: (val) => validateName(val),
                        decoration: const InputDecoration(
                          hintText: "Username",
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Tooltip(
                      message: 'Password used to sign into the Admin Dashboard',
                      child: TextFormField(
                        onFieldSubmitted: (val) => _onCredSubmit(context),
                        onChanged: (val) => onPassChanged(val),
                        validator: (val) => validatePass(val),
                        decoration: const InputDecoration(
                          hintText: "Password",
                        ),
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _onCredSubmit(context),
                      child: Text(
                        'Sign In',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
