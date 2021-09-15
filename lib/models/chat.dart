import 'package:cloud_firestore/cloud_firestore.dart';

// class containing the data for a chatroom
class ChatroomData {
  final String chatroomId;

  ChatMessage? lastMessage;

  ChatroomData(this.chatroomId, {this.lastMessage});

  ChatroomData.fromMap(String id, Map<String, dynamic>? map) : this(id, lastMessage: map?['lastMessage']);

  Map<String, dynamic> toMap() => {'lastMessage': lastMessage};
}

//class containing the data for a chat message
class ChatMessage {
  final String messageId; //works as doc id and chat message id

  String? message;
  String? authorId;
  Timestamp? time;

  ChatMessage(this.messageId, {this.message, this.authorId, this.time});

  ChatMessage.fromMap(String id, Map<String, dynamic>? map)
      : this(
          id,
          message: map?['message'],
          authorId: map?['authorId'],
          time: map?['time'],
        );

  Map<String, dynamic> toMap() => {
        'message': message,
        'authorId': authorId,
        'time': time,
      };
}

//class containing user data only for chat functionality
class ChatUserData {
  final String uid; //works as doc id and user id

  String? firstName;
  String? lastName;
  String? profilePictureUrl;

  ChatUserData(this.uid, {this.firstName, this.lastName, this.profilePictureUrl});

  ChatUserData.fromMap(String id, Map<String, dynamic>? map)
      : this(id, firstName: map?['firstName'], lastName: map?['lastName'], profilePictureUrl: map?['profilePictureUrl']);

  Map<String, dynamic> toMap() => {'firstName': firstName, 'lastName': lastName, 'profilePictureUrl': profilePictureUrl};
}
