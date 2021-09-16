import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:follow_up_app/models/chat.dart';
import 'package:follow_up_app/models/rides.dart';
import 'package:follow_up_app/models/user.dart';

class DatabaseService {
  //collections references
  static final CollectionReference<UserData> usersCollection = FirebaseFirestore.instance
      .collection('users')
      .withConverter<UserData>(fromFirestore: (snap, opt) => UserData.fromMap(snap.id, snap.data()), toFirestore: (user, opt) => user.toMap());

  static final CollectionReference<RideData> ridesCollection = FirebaseFirestore.instance
      .collection('rides')
      .withConverter(fromFirestore: (snap, opt) => RideData.fromMap(snap.id, snap.data()), toFirestore: (ride, opt) => ride.toMap());

  static final CollectionReference<ChatroomData> chatRoomCollection = FirebaseFirestore.instance
      .collection('chatrooms')
      .withConverter(fromFirestore: (snap, opt) => ChatroomData.fromMap(snap.id, snap.data()), toFirestore: (chatroom, opt) => chatroom.toMap());

  //
  //UPDATERS
  //

  static Future<void> updateUser(UserData data) {
    return usersCollection.doc(data.uid).set(data);
  }

  static Future<void> addChatroom(String userId, ChatroomData chatroomData) async {
    await chatRoomCollection.doc(chatroomData.chatroomId).set(chatroomData);
    return usersCollection.doc(userId).collection('user.chatrooms').doc(chatroomData.chatroomId).set(chatroomData.toMap());
  }

  static Future<void> addChatMessage(ChatroomData chatroomData, ChatMessage chatMessage) async {
    chatroomData.lastMessage = chatMessage;

    await usersCollection.doc(chatMessage.author.uid).collection('user.chatrooms').doc(chatroomData.chatroomId).set(chatroomData.toMap());
    await chatRoomCollection.doc(chatroomData.chatroomId).set(chatroomData, SetOptions(merge: true));
    await chatRoomCollection.doc(chatroomData.chatroomId).collection('chatroom.chats').doc(chatMessage.messageId).set(chatMessage.toMap());
  }

  static Future<void> addRide(String userId, RideData rideData) {
    return ridesCollection.doc(userId).collection('user.rides').doc(rideData.rideId).set(rideData.toMap());
  }

  //
  // FETCHERS
  //

  static Future<List<ChatUserData>> getUsersByName(String name) async {
    //todo: test if a string is considered an array by Firestore
    var firstNameList =
        await usersCollection.orderBy('firstName').startAt([name]).endAt([name + '\uf8ff']).get().then<List<ChatUserData>>(_chatUsersFromUsersSnapshot);
    var lastNameList =
        await usersCollection.orderBy('lastName').startAt([name]).endAt([name + '\uf8ff']).get().then<List<ChatUserData>>(_chatUsersFromUsersSnapshot);
    var sortedNameList = firstNameList.followedBy(lastNameList).toList();

    //todo: also check if this is functioning properly
    sortedNameList.sort((data1, data2) => data1.lastName?.compareTo(data2.lastName as String) ?? 0);
    return sortedNameList;
  }

  static Future<List<UserData>> getUsersByFirstName(String name) {
    return usersCollection.where('firstName', isEqualTo: name).get().then<List<UserData>>(_usersFromSnapshot);
  }

  static Future<List<UserData>> getUsersByLastName(String name) async {
    return await usersCollection.where('lastName', isEqualTo: name).get().then<List<UserData>>(_usersFromSnapshot);
  }

  static Future<UserData?> getUserById(String userId) {
    return usersCollection.doc(userId).get().then<UserData>((docSnap) => docSnap.data() as UserData);
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
        .then<List<ChatMessage>>(_chatMessagesFromSnapshot);
  }

  static Future<List<RideData>> getRides(String userId) {
    return ridesCollection.doc(userId).collection('user.rides').orderBy('date', descending: false).get().then<List<RideData>>(_ridesFromSnapshot);
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
        .map<List<ChatMessage>>(_chatMessagesFromSnapshot);
  }

  static Stream<List<ChatroomData>> streamChatroomsByMemberId(String userId) {
    return chatRoomCollection.where('members', arrayContains: userId).snapshots().map<List<ChatroomData>>(_chatroomsFromSnapshot);
  }

  //get all chatrooms the signed in user has
  static Stream<List<ChatroomData>> streamChatrooms(String userId) {
    return usersCollection.doc(userId).collection('user.chatrooms').snapshots().map(_chatroomsFromSnapshot);
  }

  Stream<List<RideData>> streamRides(String userId) {
    return usersCollection.doc(userId).collection('user.rides').snapshots().map(_ridesFromSnapshot);
  }

  //
  //CONVERTERS
  //

  static List<UserData> _usersFromSnapshot(QuerySnapshot<Object?> querySnapshot) {
    return querySnapshot.docs.map((queryDocSnap) => queryDocSnap.data() as UserData).toList();
  }

  static List<ChatUserData> _chatUsersFromUsersSnapshot(QuerySnapshot<Object?> querySnapshot) {
    return querySnapshot.docs.map((queryDocSnap) => ChatUserData.fromUserData(queryDocSnap.data() as UserData)).toList();
  }

  static List<ChatroomData> _chatroomsFromSnapshot(QuerySnapshot<Object?> querySnapshot) {
    return querySnapshot.docs.map((queryDocSnap) => ChatroomData.fromMap(queryDocSnap.id, queryDocSnap.data() as Map<String, dynamic>)).toList();
  }

  static List<ChatMessage> _chatMessagesFromSnapshot(QuerySnapshot<Object?> querySnapshot) {
    return querySnapshot.docs.map((queryDocSnap) => queryDocSnap.data() as ChatMessage).toList();
  }

  static List<RideData> _ridesFromSnapshot(QuerySnapshot<Object?> snapshot) {
    return snapshot.docs.map((queryDocSnap) => queryDocSnap.data() as RideData).toList();
  }
}
