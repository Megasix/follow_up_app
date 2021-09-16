import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:follow_up_app/models/user.dart';

// class containing the data for a chatroom
class ChatroomData {
  final String chatroomId;

  String name;
  List<ChatUserData>? members;
  ChatMessage? lastMessage;

  ChatroomData(this.chatroomId, {required this.name, this.members, this.lastMessage});

  ChatroomData.fromMap(String id, Map<String, dynamic>? map) : this(id, name: map?['name'], members: map?['members'], lastMessage: map?['lastMessage']);

  Map<String, dynamic> toMap() => {'name': name, 'lastMessage': lastMessage};
}

//class containing the data for a chat message
class ChatMessage {
  final String messageId; //works as doc id and chat message id

  String message;
  ChatUserData author;
  Timestamp time;

  ChatMessage(this.messageId, {required this.message, required this.author, required this.time});

  ChatMessage.fromMap(String id, Map<String, dynamic>? map)
      : this(
          id,
          message: map?['message'],
          author: ChatUserData.fromMap(map?['author']),
          time: map?['time'],
        );

  Map<String, dynamic> toMap() => {
        'message': message,
        'authorId': author.toMap(),
        'time': time,
      };
}

//class containing user data only for chat functionality
class ChatUserData {
  final String uid; //works as doc id and user id, also is identical to the UserData id corresponding to the user

  String? firstName;
  String? lastName;
  String? email;
  String? profilePictureUrl;

  ChatUserData(this.uid, {this.firstName, this.lastName, this.email, this.profilePictureUrl});

  ChatUserData.fromMap(Map<String, dynamic>? map)
      : this(map?['uid'], firstName: map?['firstName'], lastName: map?['lastName'], email: map?['email'], profilePictureUrl: map?['profilePictureUrl']);

  ChatUserData.fromUserData(UserData userData)
      : this(userData.uid as String,
            firstName: userData.firstName, lastName: userData.lastName, email: userData.email, profilePictureUrl: userData.profilePictureUrl);

  Map<String, dynamic> toMap() => {'uid': uid, 'firstName': firstName, 'lastName': lastName, 'email': email, 'profilePictureUrl': profilePictureUrl};
}
