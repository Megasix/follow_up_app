import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:follow_up_app/models/enums.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:follow_up_app/shared/page_routes.dart';
import 'package:follow_up_app/shared/snackbar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static StreamController<UserData?> userDataController = StreamController<UserData?>();
  static StreamController<SchoolData?> schoolDataController = StreamController<SchoolData?>();

  // auth change user data stream
  static Stream<UserData?> customUser = userDataController.stream;

  // auth change user data stream
  static Stream<SchoolData?> schoolUser = schoolDataController.stream;

  // auth change user stream, just to check if user is signed in
  static Stream<User?> get fireUser => _firebaseAuth.authStateChanges();

  // initializes the service
  static void init() {
    _firebaseAuth.userChanges().listen(_refreshUserData);
  }

  // Sign out from all providers.
  static void signOutAll() {
    _firebaseAuth.signOut();
  }

  //TODO: implement more features on certain types of exception messages (below)

  // register with email & password
  static Future<bool> registerWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      UserCredential emailCredential = await _firebaseAuth.createUserWithEmailAndPassword(password: password, email: email);

      //registers the user in the database if authentication is successful

      return await _handleRegisterOrSignIn(context, emailCredential);
    } on FirebaseAuthException catch (exception) {
      CustomSnackbar.showBar(context, exception.message as String);

      return false;
    }
  }

  // sign-in with email & password
  static Future<bool> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      UserCredential emailCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      return await _handleRegisterOrSignIn(context, emailCredential);
    } on FirebaseAuthException catch (exception) {
      CustomSnackbar.showBar(context, exception.message as String);
      return false;
    }
  }

  //in case the user forgot their password
  static Future forgotPassword(BuildContext context, String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);

      CustomSnackbar.showBar(context, "Password reset email sent!");
    } on FirebaseAuthException catch (exception) {
      CustomSnackbar.showBar(context, exception.message as String);
    }
  }

  // sign-in with google
  static Future<bool> signInWithGoogle(BuildContext context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

    if (googleSignInAccount == null) return false; //user cancelled sign-in

    // Signs in with a Google account and returns Google Auth credentials
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential googleCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    try {
      // Signs in with Google Auth credentials and gets Firebase Auth user
      final UserCredential googleUserCredential = await _firebaseAuth.signInWithCredential(googleCredential);
      return _handleRegisterOrSignIn(context, googleUserCredential);
    } on FirebaseAuthException catch (exception) {
      CustomSnackbar.showBar(context, exception.message as String);

      return false;
    }
  }

  static Future<bool> signInWithFacebook(BuildContext context) async {
    final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile', 'user_friends'],
        loginBehavior: LoginBehavior.nativeWithFallback); // by default we request the email, the public profile and the user's friends
    if (result.status != LoginStatus.success) return false;

    // Signs in with a Facebook account and returns Facebook Auth credentials
    final AccessToken? accessToken = result.accessToken;
    final OAuthCredential authCredential = FacebookAuthProvider.credential(
      accessToken!.token,
    );

    try {
      // Signs in with Facebook Auth credentials and gets Firebase Auth user
      final UserCredential facebookUserCredential = await FirebaseAuth.instance.signInWithCredential(authCredential);

      return _handleRegisterOrSignIn(context, facebookUserCredential);
    } on FirebaseAuthException catch (exception) {
      CustomSnackbar.showBar(context, exception.message as String);

      return false;
    }
  }

  //refreshes all user data and adds it to the stream (in the future can be used to make sure the user data on our end is up to date)
  static void _refreshUserData(User? user) async {
    print(user?.uid);

    //if we're on the web, we're only dealing with schools
    if (user == null) {
      kIsWeb ? schoolDataController.add(null) : userDataController.add(null);
      return;
    }

    if (kIsWeb) {
      //always gets the most up to date user data, responding to whatever auth changes happen
      final SchoolData? schoolData = await DatabaseService.getSchoolById(user.uid);
      schoolDataController.add(schoolData);
    } else {
      //always gets the most up to date user data, responding to whatever auth changes happen
      final UserData? userData = await DatabaseService.getUserById(user.uid);
      userDataController.add(userData);
    }
  }

  // returns true if successfuly signed in and false if not
  static Future<bool> _handleRegisterOrSignIn(BuildContext context, UserCredential fireCredential) async {
    if (kIsWeb) return true;

    final User fireUser = fireCredential.user as User;

    UserData? registeredUser = await DatabaseService.getUserById(fireUser.uid);

    if (registeredUser == null) {
      UserData? verifiedUser = await Navigator.push<UserData?>(context, Routes.codesVerificationdialog());
      print('Allo');
      if (verifiedUser == null) {
        CustomSnackbar.showBar(context, "Verification failed. Please contact your school or try again later.");
        await fireUser.delete();
        return false;
      }

      if (!fireUser.emailVerified) fireUser.sendEmailVerification();

      await DatabaseService.deleteUser(verifiedUser.uid); //delete the temp user with the temp uid

      verifiedUser.uid = fireUser.uid;
      verifiedUser.email = fireUser.email;
      verifiedUser.isActive = true;

      await DatabaseService.updateUser(verifiedUser); //create the permanent user with the FirebaseAuth uid
      fireUser.reload(); //reload the user data from the database
      return true;
    } else {
      return true;
    }
  }
}
