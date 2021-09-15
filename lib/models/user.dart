import 'package:cloud_firestore/cloud_firestore.dart';

//class containing general user data
class UserData {
  String? uid;

  String? firstName;
  String? lastName;
  String? country;
  String? email;
  String? phoneNumber;
  Timestamp? birthDate;
  String? profilePictureUrl;

  //uid is separated because it's metadata and not directly user data
  UserData(this.uid, {this.firstName, this.lastName, this.country, this.email, this.phoneNumber, this.birthDate, this.profilePictureUrl});

  UserData.fromMap(String id, Map<String, dynamic>? map)
      : this(id,
            firstName: map?['firstName'],
            lastName: map?['lastName'],
            country: map?['country'],
            email: map?['email'],
            phoneNumber: map?['phoneNumber'],
            birthDate: map?['birthDate'],
            profilePictureUrl: map?['profilePictureUrl']);

  Map<String, dynamic> toMap() => {
        'firstName': firstName,
        'lastName': lastName,
        'country': country,
        'email': email,
        'phoneNumber': phoneNumber,
        'birthDate': birthDate,
        'profilePictureUrl': profilePictureUrl
      };
}
