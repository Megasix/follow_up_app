import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:follow_up_app/models/chat.dart';
import 'package:follow_up_app/models/rides.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/shared/appdata.dart';

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

  static Future updateUser(UserData data) {
    return usersCollection.doc(data.uid).set(data);
  }

  static Future addChatroom(String userId, ChatroomData chatroomData) async {
    await chatRoomCollection.doc(chatroomData.chatroomId).set(chatroomData);
    return usersCollection.doc(userId).collection('user.chatrooms').doc(chatroomData.chatroomId).set(chatroomData.toMap());
  }

  static Future addChatMessage(ChatroomData chatroomData, ChatMessage chatMessage) async {
    chatroomData.lastMessage = chatMessage;

    await chatRoomCollection.doc(chatroomData.chatroomId).set(chatroomData, SetOptions(merge: true));
    await chatRoomCollection.doc(chatroomData.chatroomId).collection('chatroom.chats').add(chatMessage.toMap()).catchError((e) {
      print(e.toString());
    });
  }

  static Future addRide(String userId, RideData rideData) {
    return ridesCollection.doc(userId).collection('user.rides').doc(rideData.rideId).set(rideData.toMap());
  }

  //
  // STREAMS
  //

  //get all chatrooms the signed in user has
  Stream<List<ChatroomData>> get chatrooms {
    return usersCollection.doc(AppData.signedInUser.uid).collection('user.chatrooms').snapshots().map(_chatroomsFromSnapshot);
  }

  Stream<List<RideData>> get rides {
    return ridesCollection.doc(AppData.signedInUser.uid).collection('user.rides').snapshots().map(_ridesFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get users {
    return usersCollection.doc(AppData.signedInUser.uid).snapshots().map(_userFromSnapshot);
  }

  //
  // FETCHERS
  //

  static Future<UserData> refreshUser() {
    return usersCollection.doc(AppData.signedInUser.uid).get().then<UserData>((snap) => snap.data() as UserData);
  }

  static Future<List<UserData>> getUsersByFirstName(String name) {
    return usersCollection.where('firstName', isEqualTo: name).get().then<List<UserData>>(_usersFromSnapshot);
  }

  static Future<List<UserData>> getUsersByLastName(String name) async {
    return await usersCollection.where('lastName', isEqualTo: name).get().then<List<UserData>>(_usersFromSnapshot);
  }

  static Future<UserData> getUserById(String userId) {
    return usersCollection.doc(userId).get().then<UserData>((docSnap) => docSnap.data() as UserData);
  }

  static Future<List<ChatroomData>> getChatRoomsByMemberId(String userId) {
    return chatRoomCollection
        .where('chatroom.members', arrayContains: userId)
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
  //CONVERTERS
  //

  static UserData _userFromSnapshot(DocumentSnapshot<Object?> docSnapshot) {
    return UserData.fromMap(docSnapshot.id, docSnapshot.data() as Map<String, dynamic>);
  }

  static List<UserData> _usersFromSnapshot(QuerySnapshot<Object?> querySnapshot) {
    return querySnapshot.docs.map((queryDocSnap) => queryDocSnap.data() as UserData).toList();
  }

  static List<ChatroomData> _chatroomsFromSnapshot(QuerySnapshot<Object?> querySnapshot) {
    return querySnapshot.docs.map((queryDocSnap) => queryDocSnap.data() as ChatroomData).toList();
  }

  static List<ChatMessage> _chatMessagesFromSnapshot(QuerySnapshot<Object?> querySnapshot) {
    return querySnapshot.docs.map((queryDocSnap) => queryDocSnap.data() as ChatMessage).toList();
  }

  static List<RideData> _ridesFromSnapshot(QuerySnapshot<Object?> snapshot) {
    return snapshot.docs.map((queryDocSnap) => queryDocSnap.data() as RideData).toList();
  }
}
