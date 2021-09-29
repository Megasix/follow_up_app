import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:follow_up_app/screens/admin/admin_home.dart';
import 'package:follow_up_app/screens/admin/admin_login.dart';
import 'package:follow_up_app/screens/authenticate/authenticate.dart';
import 'package:follow_up_app/screens/mainMenu/main_menu.dart';
import 'package:follow_up_app/services/localisation.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    //if we're on the web, only show the admin login screen (for now)
    if (kIsWeb) {
      if (user == null)
        return AdminLogin();
      else
        return AdminHome();
    }

    // return MainMenu or Authenticate widget
    if (user != null) {
      Localisation.getPermission();
      return MainMenu();
    } else
      return Authenticate();
  }
}
