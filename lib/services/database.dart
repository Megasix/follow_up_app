import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:follow_up_app/models/user.dart';

class DatabaseService {
  final String email;

  //collections references
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference chatRoomCollection = FirebaseFirestore.instance.collection('chatRoom');

  DatabaseService({this.email});

  Future updateUserPersonnalDatas({
    String firstName,
    String lastName,
    String country,
    String email,
    String phoneNumber,
    Timestamp birthDate,
  }) async {
    return await usersCollection.doc(email).set({
      'firstName': firstName,
      'lastName': lastName,
      'country': country,
      'email': email,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
      'profilePictureAdress': (country + "-_-" + firstName + "_" + lastName)
    });
  }

  Future addUserRecipient(
    String firstName,
    String lastName,
    String country,
    String recipientEmail,
    String phoneNumber,
    Timestamp birthDate,
    String profilePictureAdress,
  ) async {
    return await usersCollection.doc(email).collection('usersData').doc('chatData').collection('recipients').doc(recipientEmail).set({
      'firstName': firstName,
      'lastName': lastName,
      'country': country,
      'email': recipientEmail,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
      'profilePictureAdress': profilePictureAdress,
    });
  }

  //setting list from snapshot
  List<UsersRecipient> _usersRecipientListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UsersRecipient(
        doc.get('firstName'),
        doc.get('lastName'),
        doc.get('country'),
        doc.get('email'),
        doc.get('phoneNumber'),
        doc.get('birtDate'),
        doc.get('profilePictureAdress'),
      );
    }).toList();
  }

  // userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      snapshot.get('firstName'),
      snapshot.get('lastName'),
      snapshot.get('country'),
      snapshot.get('email'),
      snapshot.get('phoneNumber'),
      snapshot.get('birthDate'),
      snapshot.get('profilePictureAdress'),
    );
  }

  //get usersSettings stream
  Stream<List<UsersRecipient>> get usersRecipients {
    return usersCollection
        .doc(email)
        .collection('usersData')
        .doc('chatData')
        .collection('recipients')
        .snapshots()
        .map(_usersRecipientListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return usersCollection.doc(email).snapshots().map(_userDataFromSnapshot);
  }

  getUser() async {
    return await usersCollection.doc(email).get();
  }

  getUserByFirstName(String name) async {
    return await usersCollection.where("firstName", isEqualTo: name).get();
  }

  getUserByLastName(String name) async {
    return await usersCollection.where('lastName', isEqualTo: name).get();
  }

  getUserByEmail(String email) async {
    return await usersCollection.where('email', isEqualTo: email).get();
  }

  createChatRoom(String chatRoomID, chatRoomMap) async {
      return await chatRoomCollection.doc(chatRoomID).set(chatRoomMap).catchError((e) {
        print(e.toString());
      });
  }
}
