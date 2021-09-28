import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:follow_up_app/models/chat.dart';
import 'package:follow_up_app/services/database.dart';

//class containing general user data
class UserData {
  String uid;

  String? firstName;
  String? lastName;
  String? country;
  String? email;
  String? phoneNumber;
  Timestamp? birthDate;
  String? profilePictureUrl;
  String? schoolId;
  List<DocumentReference<ChatroomData>>? activeChatrooms;

  //uid is separated because it's metadata and not directly user data
  UserData(this.uid,
      {this.firstName, this.lastName, this.schoolId, this.country, this.email, this.phoneNumber, this.birthDate, this.profilePictureUrl, this.activeChatrooms});

  UserData.fromMap(String id, Map<String, dynamic>? map)
      : this(id,
            firstName: map?['firstName'],
            lastName: map?['lastName'],
            schoolId: map?['schoolId'],
            country: map?['country'],
            email: map?['email'],
            phoneNumber: map?['phoneNumber'],
            birthDate: map?['birthDate'],
            profilePictureUrl: map?['profilePictureUrl'],
            activeChatrooms: (map?['activeChatrooms'] as List?)?.map((map) => DatabaseService.chatRoomCollection.doc(map.id)).toList() ?? []);

  Map<String, dynamic> toMap() => {
        'firstName': firstName,
        'lastName': lastName,
        'schoolId': schoolId,
        'country': country,
        'email': email,
        'phoneNumber': phoneNumber,
        'birthDate': birthDate,
        'profilePictureUrl': profilePictureUrl,
        'activeChatrooms': activeChatrooms?.isEmpty ?? FieldValue.arrayUnion([])
      };
}

class SchoolData {
  String uid;
  String? displayId;

  String name;
  String email;
  String? address;

  SchoolData(this.uid, {this.displayId, required this.name, required this.email, this.address});

  SchoolData.fromMap(String id, Map<String, dynamic>? map)
      : this(id, displayId: map?['displayId'], name: map?['name'], email: map?['email'], address: map?['address']);

  Map<String, dynamic> toMap() => {'displayId': displayId, 'name': name, 'email': email, 'address': address};
}
