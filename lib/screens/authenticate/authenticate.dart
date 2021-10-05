import 'package:flutter/material.dart';
import 'package:follow_up_app/screens/authenticate/register.dart';
import 'package:follow_up_app/screens/authenticate/sign_in.dart';
import 'package:follow_up_app/screens/authenticate/welcome.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return Welcome();
  }
}
