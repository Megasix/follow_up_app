import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:follow_up_app/models/user.dart';
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
    //if we're on the web, only show the admin login screen (for now)
    if (kIsWeb) {
      final school = Provider.of<SchoolData?>(context);

      if (school == null)
        return AdminLogin();
      else
        return AdminHome();
    } else {
      final user = Provider.of<UserData?>(context);

      // return MainMenu or Authenticate widget
      if (user != null) {
        Get.until((route) => Get.currentRoute == '/');
        Localisation.getPermission();
        return MainMenu();
      } else
        return Welcome();
    }
  }
}
