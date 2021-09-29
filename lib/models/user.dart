import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:follow_up_app/models/chat.dart';
import 'package:follow_up_app/models/enums.dart';
import 'package:follow_up_app/services/database.dart';

//class containing general user data
class UserData {
  String uid;
  UserType type;

  bool isActive;
  String? activationCode;

  String firstName;
  String lastName;
  String? country;
  String? email;
  String? phoneNumber;
  Timestamp? birthDate;
  String? profilePictureUrl;
  String? schoolId;

  //uid is separated because it's metadata and not directly user data
  UserData(this.uid, this.type,
      {required this.firstName,
      required this.lastName,
      this.schoolId,
      this.country,
      this.email,
      this.phoneNumber,
      this.birthDate,
      this.profilePictureUrl,
      this.activationCode,
      this.isActive = false});

  UserData.fromMap(String id, Map<String, dynamic>? map)
      : this(
          id,
          UserType.values[map?['type'] ?? 0],
          firstName: map?['firstName'],
          lastName: map?['lastName'],
          schoolId: map?['schoolId'],
          country: map?['country'],
          email: map?['email'],
          phoneNumber: map?['phoneNumber'],
          birthDate: map?['birthDate'],
          profilePictureUrl: map?['profilePictureUrl'],
          isActive: map?['isActive'] ?? false,
          activationCode: map?['activationCode'],
        );

  Map<String, dynamic> toMap() => {
        'type': type.index,
        'firstName': firstName,
        'lastName': lastName,
        'schoolId': schoolId,
        'country': country,
        'email': email,
        'phoneNumber': phoneNumber,
        'birthDate': birthDate,
        'profilePictureUrl': profilePictureUrl,
        'isActive': isActive,
        'activationCode': activationCode
      };
}

class SchoolData {
  String uid;
  String? displayId;

  String name;
  String email;
  String? phoneNumber;
  String? address;
  String? schoolPictureUrl;
// mic was here but wasn't sure if it was needed

  SchoolData(this.uid, {this.displayId, required this.name, required this.email, this.phoneNumber, this.address});

  SchoolData.fromMap(String id, Map<String, dynamic>? map)
      : this(id, displayId: map?['displayId'], name: map?['name'], email: map?['email'], phoneNumber: map?['phoneNumber'], address: map?['address']);

  Map<String, dynamic> toMap() => {'displayId': displayId, 'name': name, 'email': email, 'phoneNumber': phoneNumber, 'address': address};
}
