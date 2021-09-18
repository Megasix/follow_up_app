import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:follow_up_app/models/chat.dart';

//class containing general user data
class UserData {
  String? uid; //needs to be nullable to check if user is logged in

  String? firstName;
  String? lastName;
  String? country;
  String? email;
  String? phoneNumber;
  Timestamp? birthDate;
  String? profilePictureUrl;
  List<DocumentReference<ChatroomData>>? activeChatrooms;

  //uid is separated because it's metadata and not directly user data
  UserData(this.uid, {this.firstName, this.lastName, this.country, this.email, this.phoneNumber, this.birthDate, this.profilePictureUrl, this.activeChatrooms});

  UserData.fromMap(String id, Map<String, dynamic>? map)
      : this(id,
            firstName: map?['firstName'],
            lastName: map?['lastName'],
            country: map?['country'],
            email: map?['email'],
            phoneNumber: map?['phoneNumber'],
            birthDate: map?['birthDate'],
            profilePictureUrl: map?['profilePictureUrl'],
            activeChatrooms: map?['activeChatrooms']);

  Map<String, dynamic> toMap() => {
        'firstName': firstName,
        'lastName': lastName,
        'country': country,
        'email': email,
        'phoneNumber': phoneNumber,
        'birthDate': birthDate,
        'profilePictureUrl': profilePictureUrl,
        'activeChatrooms': activeChatrooms?.isEmpty ?? FieldValue.arrayUnion([])
      };
}
