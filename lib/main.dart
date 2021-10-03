import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:follow_up_app/models/user.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:follow_up_app/screens/wrapper.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/shared/style_constants.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AuthService.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //this user data instance is only for authentication purposes, its id (from Firebase Auth) is not equivalent to the actual user id on Firestore
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(value: AuthService.userStream, initialData: null),
        kIsWeb
            ? StreamProvider<SchoolData?>.value(value: AuthService.signedInSchool, initialData: null)
            : StreamProvider<UserData?>.value(value: AuthService.signedInUser, initialData: null)
      ],
      child: GetMaterialApp(
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system,
        localizationsDelegates: [
          //AppLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('en', 'CA'),
          const Locale('fr', 'CA'),
          const Locale('fr', 'FR'),
        ],
        home: Wrapper(),
      ),
    );
  }
}
