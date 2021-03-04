import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/screens/authenticate/authenticate.dart';
import 'package:follow_up_app/screens/mainMenu/mainMenu.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    final user = Provider.of<CustomUser>(context);

    // return Home or Authenticate widget
    if (user == null)
      return Authenticate();
    else
      return MainMenu();
  }
}
