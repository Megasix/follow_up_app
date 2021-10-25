import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:follow_up_app/models/markers.dart';
import 'package:rxdart/rxdart.dart';
import 'package:follow_up_app/models/chat.dart';
import 'package:follow_up_app/models/enums.dart';
import 'package:follow_up_app/models/rides.dart';
import 'package:follow_up_app/models/user.dart';

class DatabaseService {
  //collections references
  static final CollectionReference<UserData> usersCollection = FirebaseFirestore.instance
      .collection('users')
      .withConverter<UserData>(fromFirestore: (snap, opt) => UserData.fromMap(snap.id, snap.data()), toFirestore: (user, opt) => user.toMap());

  static final CollectionReference<SchoolData> schoolsCollection = FirebaseFirestore.instance
      .collection('schools')
      .withConverter<SchoolData>(fromFirestore: (snap, opt) => SchoolData.fromMap(snap.id, snap.data()), toFirestore: (school, opt) => school.toMap());

  static final CollectionReference<RideData> ridesCollection = FirebaseFirestore.instance
      .collection('rides')
      .withConverter<RideData>(fromFirestore: (snap, opt) => RideData.fromMap(snap.id, snap.data()), toFirestore: (ride, opt) => ride.toMap());

  static final CollectionReference<ChatroomData> chatRoomCollection = FirebaseFirestore.instance
      .collection('chatrooms')
      .withConverter<ChatroomData>(fromFirestore: (snap, opt) => ChatroomData.fromMap(snap.data()), toFirestore: (chatroom, opt) => chatroom.toMap());

  //
  // UPDATERS
  //

  static Future<void> updateUser(UserData data) {
    return usersCollection.doc(data.uid).set(data, SetOptions(merge: true));
  }

  static Future<void> updateSchool(SchoolData schoolData) async {
    return schoolsCollection.doc(schoolData.uid).set(schoolData, SetOptions(merge: true));
  }

  static Future<void> addChatroom(String userId, ChatroomData chatroomData) async {
    //uploads the new chatroom to the chatroom collection
    DocumentReference<ChatroomData> chatroomDocRef = chatRoomCollection.doc(chatroomData.chatroomId);
    await chatroomDocRef.set(chatroomData);

    return usersCollection.doc(userId).update({
      'activeChatrooms': FieldValue.arrayUnion([
        FirebaseFirestore.instance
            .doc(chatroomDocRef.path) //have to re-reference the collection because the return of 'chatroomDocRef.path' is an incompatble type...
      ])
    });
  }

  static Future<void> addChatMessage(ChatroomData chatroomData, ChatMessage chatMessage) async {
    //updates chatroom data with latest chat message
    chatroomData.lastMessage = chatMessage;

    //uploads the updated chatroom to the chatroom collection
    DocumentReference<ChatroomData> chatroomDocRef = chatRoomCollection.doc(chatroomData.chatroomId);
    await chatroomDocRef.set(chatroomData, SetOptions(merge: true));

    await usersCollection.doc(chatMessage.authorId).update({
      'activeChatrooms': FieldValue.arrayUnion([
        FirebaseFirestore.instance
            .doc(chatroomDocRef.path) //have to re-reference the collection because the return of 'chatroomDocRef.path' is an incompatble type...
      ])
    });

    //uploads the chat message to the chatroom's chat collection
    return chatRoomCollection.doc(chatroomData.chatroomId).collection('chatroom.chats').doc(chatMessage.messageId).set(chatMessage.toMap());
  }

  static Future<void> addRide(String userId, RideData rideData) {
    return usersCollection.doc(userId).collection('user.rides').doc(rideData.rideId).set(rideData.toMap());
  }

  //
  // DELETERS
  //

  static Future<void> deleteUser(String userId) {
    return usersCollection.doc(userId).delete();
  }

  //
  // FETCHERS
  //

  static Future<SchoolData?> getSchoolById(String schoolCode) async {
    return schoolsCollection.doc(schoolCode).get().then<SchoolData?>((snap) => snap.data());
  }

  static Future<List<ChatUserData>> getStudentsByName(String name) async {
    //todo: test if a string is considered an array by Firestore
    var firstNameList = await usersCollection
        .where('type', isEqualTo: UserType.STUDENT.index)
        .orderBy('firstName')
        .startAt([name])
        .endAt([name + '\uf8ff'])
        .get()
        .then<List<ChatUserData>>(_chatUsersFromUsersSnapshotMap);

    var lastNameList = await usersCollection
        .where('type', isEqualTo: UserType.STUDENT.index)
        .orderBy('lastName')
        .startAt([name])
        .endAt([name + '\uf8ff'])
        .get()
        .then<List<ChatUserData>>(_chatUsersFromUsersSnapshotMap);
    var sortedNameList = firstNameList.followedBy(lastNameList).toList();

    //todo: also check if this is functioning properly
    sortedNameList.sort((data1, data2) => data1.lastName?.compareTo(data2.lastName as String) ?? 0);
    return sortedNameList;
  }

  static Future<List<UserData>> getStudentsBySchool(String schoolCode) {
    return usersCollection
        .where('schoolCode', isEqualTo: schoolCode)
        .where('type', isEqualTo: UserType.STUDENT.index)
        .get()
        .then<List<UserData>>(_usersFromSnapshot);
  }

  static Future<List<UserData>> getInstructorsBySchool(String schoolCode) {
    return usersCollection
        .where('schoolCode', isEqualTo: schoolCode)
        .where('type', isEqualTo: UserType.INSTRUCTOR.index)
        .get()
        .then<List<UserData>>(_usersFromSnapshot);
  }

  static Future<UserData?> getUserById(String userId) {
    return usersCollection.doc(userId).get().then<UserData?>((docSnap) => docSnap.data());
  }

  static Future<List<ChatroomData>> getChatRoomsByMemberId(String userId) {
    return chatRoomCollection
        .where('members', arrayContains: userId)
        .orderBy('lastMessage.time', descending: true)
        .get()
        .then<List<ChatroomData>>(_chatroomsFromSnapshot);
  }

  static Future<List<ChatMessage>> getChatMessages(String chatRoomID) {
    return chatRoomCollection
        .doc(chatRoomID)
        .collection('chatroom.chats')
        .orderBy('time', descending: false)
        .get()
        .then<List<ChatMessage>>(_chatMessagesFromSnapshotMap);
  }

  static Future<List<RideData>> getRides(String userId) {
    return usersCollection.doc(userId).collection('user.rides').orderBy('date', descending: false).get().then<List<RideData>>(_ridesFromSnapshotMap);
  }

  //
  // CHECKERS
  //

  static Future<String?> isSchoolCodeValid(String schoolCode) async {
    final QuerySnapshot querySnap = await schoolsCollection.where('displayCode', isEqualTo: schoolCode).get();
    if (querySnap.size > 0)
      return querySnap.docs.first.id;
    else
      return null;
  }

  static Future<UserData?> isActivationCodeValid(String activationCode) async {
    final QuerySnapshot<UserData> querySnap =
        await usersCollection.where('activationCode', isEqualTo: activationCode).where('isActive', isEqualTo: false).get();

    if (querySnap.size > 0)
      return querySnap.docs.first.data();
    else
      return null;
  }

  //
  // STREAMERS (streams that require parameters)
  //

  static Stream<List<ChatMessage>> streamChatMessages(String chatRoomID) {
    return chatRoomCollection
        .doc(chatRoomID)
        .collection('chatroom.chats')
        .orderBy('time', descending: false)
        .snapshots()
        .map<List<ChatMessage>>(_chatMessagesFromSnapshotMap);
  }

  //get all chatrooms the signed in user has
  static Stream<List<ChatroomData>> streamStudentChatrooms(UserData userData) {
    return chatRoomCollection
        .where('members', arrayContains: ChatUserData.fromUserData(userData).toMap())
        .snapshots()
        .map<List<ChatroomData>>(_chatroomsFromSnapshot);
  }

//get all chatrooms the signed in school has
  static Stream<List<ChatroomData>> streamSchoolChatrooms(SchoolData schoolData) {
    return chatRoomCollection
        .where('members', arrayContains: ChatUserData.fromSchoolData(schoolData).toMap())
        .snapshots()
        .map<List<ChatroomData>>(_chatroomsFromSnapshot);
  }

  //get all students related to the signed in school
  static Stream<List<UserData>> streamSchoolStudents(String schoolCode) {
    return usersCollection
        .where('type', isEqualTo: UserType.STUDENT.index)
        .where('schoolCode', isEqualTo: schoolCode)
        .snapshots()
        .map<List<UserData>>(_usersFromSnapshot);
  }

  //get all instructors related to the signed in school
  static Stream<List<UserData>> streamSchoolInstructors(String schoolCode) {
    return usersCollection
        .where('type', isEqualTo: UserType.INSTRUCTOR.index)
        .where('schoolCode', isEqualTo: schoolCode)
        .snapshots()
        .map<List<UserData>>(_usersFromSnapshot);
  }

  Stream<List<RideData>> streamRides(String userId) {
    return usersCollection.doc(userId).collection('user.rides').snapshots().map(_ridesFromSnapshotMap);
  }

  //
  // CONVERTERS
  // functions that contain "Map" at the end convert maps to objects, contrary to the ones that don't;
  // they're mainly used for subcollections, where the automatic converters don't apply
  //

  static List<UserData> _usersFromSnapshot(QuerySnapshot<Object?> querySnapshot) {
    return querySnapshot.docs.map((queryDocSnap) => queryDocSnap.data() as UserData).toList();
  }

  static List<ChatroomData> _chatroomsFromSnapshot(QuerySnapshot<Object?> querySnapshot) {
    return querySnapshot.docs.map((queryDocSnap) => queryDocSnap.data() as ChatroomData).toList();
  }

  static List<RideData> _ridesFromSnapshot(QuerySnapshot<Object?> querySnapshot) {
    return querySnapshot.docs.map((queryDocSnap) => queryDocSnap.data() as RideData).toList();
  }

  static List<ChatUserData> _chatUsersFromUsersSnapshotMap(QuerySnapshot<Object?> querySnapshot) {
    return querySnapshot.docs.map((queryDocSnap) => ChatUserData.fromUserData(queryDocSnap.data() as UserData)).toList();
  }

  static List<UserData> _usersFromSnapshotMap(QuerySnapshot<Object?> querySnapshot) {
    return querySnapshot.docs.map((queryDocSnap) => UserData.fromMap(queryDocSnap.id, queryDocSnap.data() as Map<String, dynamic>)).toList();
  }

  static List<ChatMessage> _chatMessagesFromSnapshotMap(QuerySnapshot<Object?> querySnapshot) {
    return querySnapshot.docs.map((queryDocSnap) => ChatMessage.fromMap(queryDocSnap.data() as Map<String, dynamic>)).toList();
  }

  static List<RideData> _ridesFromSnapshotMap(QuerySnapshot<Object?> querySnapshot) {
    return querySnapshot.docs.map((queryDocSnap) => RideData.fromMap(queryDocSnap.id, queryDocSnap.data() as Map<String, dynamic>)).toList();
  }
}
