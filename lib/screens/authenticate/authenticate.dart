import 'package:flutter/material.dart';
import 'package:follow_up_app/screens/authenticate/register.dart';
import 'package:follow_up_app/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  bool showSignIn;
  Authenticate(this.showSignIn);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  void _toggleAuthWidget() {
    setState(() => widget.showSignIn = !widget.showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return widget.showSignIn ? SignIn(toggleAuth: _toggleAuthWidget) : Register(toggleAuth: _toggleAuthWidget);
  }
}
