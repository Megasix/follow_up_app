import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:follow_up_app/screens/admin/admin_home.dart';
import 'package:follow_up_app/screens/admin/admin_login.dart';
import 'package:follow_up_app/screens/mainMenu/main_menu.dart';
import 'package:follow_up_app/services/localisation.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'authenticate/authenticate.dart';
import 'authenticate/welcome.dart';

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
      Get.until((route) => Get.currentRoute == '/');
      Localisation.getPermission();
      try {
        return MainMenu();
      } on Exception catch (e) {
        return Loading();;//Authenticate();
      }
    } else
      return Welcome();
  }
}
