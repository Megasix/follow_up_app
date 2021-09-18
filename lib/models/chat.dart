import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:uuid/uuid.dart';

// class containing the data for a chatroom
class ChatroomData {
  final String chatroomId;

  String name;
  List<ChatUserData> members;
  ChatMessage? lastMessage;

  ChatroomData(this.chatroomId, {required this.name, required this.members, this.lastMessage});

  ChatroomData.fromMap(Map<String, dynamic>? map)
      : this(map?['chatroomId'],
            name: map?['name'],
            members: (map?['members'] as List).map<ChatUserData>((map) => ChatUserData.fromMap(map)).toList(),
            lastMessage: ChatMessage.fromMap(map?['lastMessage']));

  Map<String, dynamic> toMap() =>
      {'chatroomId': chatroomId, 'name': name, 'members': members.map((chatUser) => chatUser.toMap()).toList(), 'lastMessage': lastMessage?.toMap()};
}

//class containing the data for a chat message
class ChatMessage {
  final String messageId; //works as doc id and chat message id

  String message;
  String authorId;
  Timestamp time;

  ChatMessage(this.messageId, {required this.message, required this.authorId, required this.time});

  ChatMessage.fromMap(Map<String, dynamic>? map)
      : this(
          map?['messageId'],
          message: map?['message'],
          authorId: map?['authorId'],
          time: map?['time'],
        );

  Map<String, dynamic> toMap() => {
        'messageId': messageId,
        'message': message,
        'authorId': authorId,
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
