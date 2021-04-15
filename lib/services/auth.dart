import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:follow_up_app/shared/shared_functions.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

// create custom user based on FirebaseUser
  CustomUser _userFromFirebaseUser(User user) {
    return user != null ? CustomUser(uid: user.uid) : null;
  }

// auth change user stream
  Stream<CustomUser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

// sign-in anonymously
  Future signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

// sign-in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
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
  Future registerWithEmailAndPassword(
    String firstName,
    String lastName,
    String country,
    String email,
    String phoneNumber,
    Timestamp birthDate,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      //create a new document for the user with the uid
      await DatabaseService(email: user.email).updateUserPersonnalDatas(
          firstName: firstName, lastName: lastName, country: country, email: email, phoneNumber: phoneNumber, birthDate: birthDate);
      Shared.saveUserLoggedInSharedPreference(true);
      Shared.saveUserEmailSharedPreference(user.email);
      Shared.saveUserNameSharedPreference(firstName);
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

//google authentication
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async {
    await Firebase.initializeApp();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(user.displayName != null);
      assert(await user.getIdToken() != null);
      final firstName = user.displayName.split(" ")[0];
      final lastName = user.displayName.split(" ")[1];
      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      if (authResult.additionalUserInfo.isNewUser)
        await DatabaseService(email: user.email)
            .updateUserPersonnalDatas(firstName: firstName, lastName: lastName, email: user.email, phoneNumber: user.phoneNumber);
      Shared.saveUserLoggedInSharedPreference(true);
      Shared.saveUserEmailSharedPreference(user.email);
      Shared.saveUserNameSharedPreference(firstName);
      print('signInWithGoogle succeeded: $user');

      return '$_userFromFirebaseUser(user);';
    }

    return null;
  }

  Future<String> signInWithFacebook() async {
    try {
      final AccessToken accessToken = await FacebookAuth.instance.login();
      final FacebookAuthCredential credential = FacebookAuthProvider.credential(
        accessToken.token,
      );

      final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      final User user = authResult.user;
      if (user != null) {
        final firstName = user.displayName.split(" ")[0];
        final lastName = user.displayName.split(" ")[1];
        if (authResult.additionalUserInfo.isNewUser) {
          await DatabaseService(email: user.email).updateUserPersonnalDatas(
            firstName: firstName,
            lastName: lastName,
            email: user.email,
            phoneNumber: user.phoneNumber,
          );
          Shared.saveUserLoggedInSharedPreference(true);
          Shared.saveUserEmailSharedPreference(user.email);
          Shared.saveUserNameSharedPreference(firstName);
        }
        return '$_userFromFirebaseUser(user);';
      }
    } on FacebookAuthException catch (e) {
      // handle the FacebookAuthException
    } on FirebaseAuthException catch (e) {
      // handle the FirebaseAuthException
    } finally {}
    return null;
  }

// sign out
  Future signOut() async {
    try {
      await _auth.signOut();
      await googleSignIn.signOut();
      Shared.saveUserLoggedInSharedPreference(false);
      Shared.saveUserEmailSharedPreference(null);
      Shared.saveUserNameSharedPreference(null);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
