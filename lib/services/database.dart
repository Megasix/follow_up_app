import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:follow_up_app/models/rides.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:ntp/ntp.dart';

class DatabaseService {
  final String? email;

  //collections references
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference chatRoomCollection = FirebaseFirestore.instance.collection('chatRoom');
  final CollectionReference ridesCollection = FirebaseFirestore.instance.collection('rides');

  DatabaseService({this.email});

  Future updateUserPersonnalDatas({
    String? firstName,
    String? lastName,
    String? country,
    String? email,
    String? phoneNumber,
    Timestamp? birthDate,
  }) async {
    return await usersCollection.doc(email).set({
      'firstName': firstName,
      'lastName': lastName,
      'country': country,
      'email': email,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
      'profilePictureAdress': (country! + "-_-" + firstName! + "_" + lastName!)
    });
  }

  Future addUserRecipient(
    String? firstName,
    String? lastName,
    String? country,
    String? recipientEmail,
    String? phoneNumber,
    Timestamp? birthDate,
    String? profilePictureAdress,
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

  Future addNewRide(String name, String duration, Timestamp date, String polyline) async {
    return await ridesCollection.doc(email).collection('rides').doc(name).set({
      'duration': duration,
      'date': date,
      'polyline': polyline,
    });
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

  List<Ride> _ridesListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Ride(
        duration: doc.get('duration'),
        date: doc.get('date'),
        polylines: doc.get('polylines'),
      );
    }).toList();
  }

  //get usersSettings stream
  Stream<List<UsersRecipient>> get usersRecipients {
    return usersCollection.doc(email).collection('usersData').doc('chatData').collection('recipients').snapshots().map(_usersRecipientListFromSnapshot);
  }

  Stream<List<Ride>> get Rides {
    return ridesCollection.doc(email).collection('rides').snapshots().map(_ridesListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return usersCollection.doc(email).snapshots().map(_userDataFromSnapshot);
  }

  getUser() async {
    return await usersCollection.doc(email).get();
  }

  getUserByFirstName(String name) async {
    return await usersCollection.where('firstName', isEqualTo: name).get();
  }

  getUserByLastName(String name) async {
    return await usersCollection.where('lastName', isEqualTo: name).get();
  }

  getUserByEmail(String email) async {
    return await usersCollection.doc(email).get();
  }

  getUsersRecipientObjectByEmail(String email) {
    DocumentSnapshot recipientSnapshot = getUserByEmail(email);
    if (recipientSnapshot != null) {
      return UsersRecipient(
        recipientSnapshot.get('firstName'),
        recipientSnapshot.get('lastName'),
        recipientSnapshot.get('country'),
        recipientSnapshot.get('email'),
        recipientSnapshot.get('phoneNumber'),
        recipientSnapshot.get('birthDate'),
        recipientSnapshot.get('profilePictureAdress'),
      );
    } else
      return null;
  }

  createChatRoom(String chatRoomID, chatRoomMap) async {
    await chatRoomCollection.doc(chatRoomID).set(chatRoomMap).catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessage(String chatRoomID, messageMap) async {
    await chatRoomCollection.doc(chatRoomID).set({'lastActivity': await NTP.now()});
    await chatRoomCollection.doc(chatRoomID).collection('chats').add(messageMap).catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomID) async {
    return await chatRoomCollection.doc(chatRoomID).collection('chats').orderBy('time', descending: false).snapshots();
  }

  getChatRooms(String email) async {
    return await chatRoomCollection.where('users', arrayContains: email).orderBy('lastActivity', descending: true).snapshots();
  }

  getRides() async {
    return await ridesCollection.doc(email).collection('rides').orderBy('date', descending: false).get();
  }
}
