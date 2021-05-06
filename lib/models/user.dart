import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CustomUser {
  final String uid;

  CustomUser({this.uid});
}

class UserData {
  String firstName;
  String lastName;
  String country;
  String email;
  String phoneNumber;
  Timestamp birthDate;
  String profilePictureAdress;

  UserData(this.firstName, this.lastName, this.country, this.email, this.phoneNumber, this.birthDate, this.profilePictureAdress);
}

class UsersRecipient extends UserData {
  UsersRecipient(String firstName, String lastName, String country, String email, String phoneNumber, Timestamp birthDate, String profilePictureAdress) : super(firstName, lastName, country, email, phoneNumber, birthDate, profilePictureAdress);
}
