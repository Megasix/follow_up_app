import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static StreamController<UserData?> controller = StreamController<UserData?>();

  // auth change user data stream
  static Stream<UserData?> signedInUser = controller.stream;

  // auth change user stream, just to check if user is signed in
  static Stream<User?> get userStream => _firebaseAuth.authStateChanges();

  // initializes the service
  static void init() {
    _firebaseAuth.userChanges().listen(_refreshUserData);
  }

  //refreshes all user data and adds it to the stream (in the future can be used to make sure the user data on our end is up to date)
  static void _refreshUserData(User? user) async {
    print(user?.uid);
    if (user == null) {
      controller.add(null);
      return;
    }

    //always gets the most up to date user data, responding to whatever auth changes happen
    final UserData? userData = await DatabaseService.getUserById(user.uid);
    controller.add(userData);
  }

  // Sign out from all providers.
  static void signOutAll() {
    _firebaseAuth.signOut();
  }

  // register with email & password
  static Future registerWithEmailAndPassword(UserData userData, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(password: password, email: userData.email as String);

      //TODO: check if the user registered successfully

      //registers the user in the database
      await DatabaseService.updateUser(userData);
    } on FirebaseAuthException catch (exception) {
      switch (exception.code) {
        //TODO: add more cases
      }
    }
  }

  // sign-in with email & password
  static Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (exception) {
      switch (exception.code) {
        //TODO: add more cases
      }
    }
  }

  // sign-in with google
  static Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

    if (googleSignInAccount == null) return null; //user cancelled sign-in

    // Signs in with a Google account and returns Google Auth credentials
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential googleCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    try {
      // Signs in with Google Auth credentials and gets Firebase Auth user
      final UserCredential googleUserCredential = await _firebaseAuth.signInWithCredential(googleCredential);
      final User googleSignedUser = googleUserCredential.user as User;

      // Won't be null since we're signing in with a Google account
      final firstName = googleSignedUser.displayName!.split(" ")[0];
      final lastName = googleSignedUser.displayName!.split(" ")[1];

      final UserData userData = UserData(
        googleSignedUser.uid,
        firstName: firstName,
        lastName: lastName,
        email: googleSignedUser.email,
        phoneNumber: googleSignedUser.phoneNumber,
        profilePictureUrl: googleSignedUser.photoURL,
      );

      await DatabaseService.updateUser(userData);

      return googleUserCredential;
    } on FirebaseAuthException catch (exception) {
      switch (exception.code) {
        //TODO: add more cases
      }
    }
  }

  static Future<UserCredential?> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile', 'user_friends'],
        loginBehavior: LoginBehavior.nativeWithFallback); // by default we request the email, the public profile and user friends
    if (result.status != LoginStatus.success) return null;

    // Signs in with a Facebook account and returns Facebook Auth credentials
    final AccessToken? accessToken = result.accessToken;
    final OAuthCredential authCredential = FacebookAuthProvider.credential(
      accessToken!.token,
    );

    try {
      // Signs in with Facebook Auth credentials and gets Firebase Auth user
      final UserCredential facebookUserCredential = await FirebaseAuth.instance.signInWithCredential(authCredential);
      final User facebookSignedUser = facebookUserCredential.user as User;
      // Won't be null since we're signing in with a Google account
      final firstName = facebookSignedUser.displayName!.split(" ")[0];
      final lastName = facebookSignedUser.displayName!.split(" ")[1];

      final UserData userData = UserData(
        facebookSignedUser.uid,
        firstName: firstName,
        lastName: lastName,
        email: facebookSignedUser.email,
        phoneNumber: facebookSignedUser.phoneNumber,
        profilePictureUrl: facebookSignedUser.photoURL,
      );

      await DatabaseService.updateUser(userData);

      return facebookUserCredential;
    } on FirebaseAuthException catch (exception) {
      switch (exception.code) {
        //TODO: add more cases
      }
    }
  }
}
