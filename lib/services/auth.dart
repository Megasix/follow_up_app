import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:follow_up_app/shared/shared.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

//TODO: REFACTOR THIS WHOOOOOOOLE THING

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

// auth change user stream
  static Stream<UserData?> get user {
    return _firebaseAuth.authStateChanges().asyncMap<UserData?>((user) => user == null ? Future.value(null) : DatabaseService.getUserById(user.uid));
  }

// sign-in with email & password
  static Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      UserData? userData = await DatabaseService.getUserById(user!.uid);
      return userData;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

// register with email & password
  static Future<UserData> registerWithEmailAndPassword(String password, UserData userData) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(password: password, email: userData.email as String);

    //todo: check if the user registered successfully

    //create a new document for the user with the uid
    await DatabaseService.updateUser(userData);
    return userData;
  }

  static Future<UserData?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    if (googleSignInAccount == null) return null; //user cancelled sign-in

    //todo: check how this works
    final methods = await _firebaseAuth.fetchSignInMethodsForEmail(googleSignInAccount.email);

    // Signs in with the GoogleSignIn account and returns Google Auth credentials
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential googleCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await _firebaseAuth.signInWithCredential(googleCredential);
    final User googleSignedUser = authResult.user as User;

    // Won't be null since we're signing in with a Google account
    final firstName = googleSignedUser.displayName!.split(" ")[0];
    final lastName = googleSignedUser.displayName!.split(" ")[1];

    UserData userData = UserData(googleSignedUser.uid,
        firstName: firstName,
        lastName: lastName,
        email: googleSignedUser.email,
        phoneNumber: googleSignedUser.phoneNumber,
        profilePictureUrl: googleSignedUser.photoURL);

    await DatabaseService.updateUser(userData);

    print('signInWithGoogle succeeded: ${userData.uid}');

    return userData;
  }

  static Future<String?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(); // by default we request the email and the public profile
      if (result.status == LoginStatus.success) {
        // you are logged
        final AccessToken? accessToken = result.accessToken;
        final OAuthCredential credential = FacebookAuthProvider.credential(
          accessToken!.token,
        );
        final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = authResult.user;
        if (user != null) {
          return '(user);';
        }
      }
    } on FirebaseAuthException catch (e) {
      // handle the FirebaseAuthException
    } finally {}
    return null;
  }

// sign out
  Future signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    Shared.saveUserLoggedInSharedPreference(false);
    Shared.saveUserEmailSharedPreference('');
    Shared.saveUserNameSharedPreference('');
  }
}
