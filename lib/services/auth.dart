import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:follow_up_app/shared/shared.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

// create custom user based on FirebaseUser
  static CustomUser _userFromFirebaseUser(User? user) {
    return CustomUser(uid: user?.uid as String);
  }

// auth change user stream
  static Stream<CustomUser> get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebaseUser);
  }

// sign-in anonymously
  static Future signInAnonymously() async {
    try {
      UserCredential result = await _firebaseAuth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

// sign-in with email & password
  static Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      String firstName;
      DocumentSnapshot userInfo = await DatabaseService(email: email).getUser();
      firstName = userInfo.get('firstName');
      Shared.saveUserLoggedInSharedPreference(true);
      Shared.saveUserEmailSharedPreference(email);
      Shared.saveUserNameSharedPreference(firstName);
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

// register with email & password
  static Future registerWithEmailAndPassword(
      String firstName, String lastName, String country, String email, String phoneNumber, Timestamp birthDate, String password) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

    User registeredUser;
    if (result.user != null) {
      registeredUser = result.user as User;

      //create a new document for the user with the uid
      await DatabaseService(email: registeredUser.email)
          .updateUserPersonnalDatas(firstName: firstName, lastName: lastName, country: country, email: email, phoneNumber: phoneNumber, birthDate: birthDate);
      Shared.saveUserLoggedInSharedPreference(true);
      Shared.saveUserEmailSharedPreference(registeredUser.email!); //won't be null since we're registering with email and password
      Shared.saveUserNameSharedPreference(firstName);
      return _userFromFirebaseUser(registeredUser);
    }
  }

  static Future<String?> signInWithGoogle() async {
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

    //if it's a new user, we create a new document for the user on the database
    if (authResult.additionalUserInfo!.isNewUser)
      await DatabaseService(email: googleSignedUser.email)
          .updateUserPersonnalDatas(firstName: firstName, lastName: lastName, email: googleSignedUser.email, phoneNumber: googleSignedUser.phoneNumber);
    Shared.saveUserLoggedInSharedPreference(true);
    Shared.saveUserEmailSharedPreference(googleSignedUser.email as String); //won't be null since we're registering with a Google account
    Shared.saveUserNameSharedPreference(firstName);
    print('signInWithGoogle succeeded: $user');

    return '$_userFromFirebaseUser(user);';
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
          return '$_userFromFirebaseUser(user);';
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
