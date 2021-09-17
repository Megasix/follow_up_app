import 'package:flutter/material.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/screens/authenticate/authenticate.dart';
import 'package:follow_up_app/screens/mainMenu/main_menu.dart';
import 'package:follow_up_app/services/localisation.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData?>(context);

    // return MainMenu or Authenticate widget
    if (user != null) {
      Localisation.getPermission();
      return MainMenu();
    } else
      return Authenticate();
  }
}

/* class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData?>(context);

    // return MainMenu or Authenticate widget
    if (user != null) {
      Localisation.getPermission();
      return MainMenu();
    } else
      return Authenticate();
  }
} */
