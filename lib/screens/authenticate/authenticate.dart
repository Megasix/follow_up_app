import 'package:flutter/material.dart';
import 'package:follow_up_app/models/enums.dart';
import 'package:follow_up_app/screens/authenticate/register.dart';
import 'package:follow_up_app/screens/authenticate/sign_in.dart';
import 'package:follow_up_app/screens/authenticate/welcome.dart';

class Authenticate extends StatefulWidget {
  Authenticate(this.userType);

  UserType userType;

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool _showSignIn = true;

  void _toggleAuthWidget() {
    setState(() => _showSignIn = !_showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return _showSignIn ? SignIn(userType: widget.userType, toggleAuth: _toggleAuthWidget) : Register(userType: widget.userType, toggleAuth: _toggleAuthWidget);
  }
}
