import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/screens/wrapper.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/shared/constants.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:provider/provider.dart';

bool _lightThemeEnabled = false;

// ignore: missing_return
Future<void> main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            print("erreur dans le builder");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamProvider<CustomUser>.value(
              value: AuthService().user,
              child: MaterialApp(
                theme:
                    _lightThemeEnabled ? lightThemeConstant : darkThemeConstant,
                darkTheme: darkThemeConstant,
                home: Wrapper(),
              ),
            );
          }
          return Loading();
        });
  }
}

bool getTheme() {
  return _lightThemeEnabled;
}

void setTheme(bool lightThemeEnabled) {
  _lightThemeEnabled = lightThemeEnabled;
}
