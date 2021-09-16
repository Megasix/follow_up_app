import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:follow_up_app/models/chat.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/screens/mainMenu/messaging/conversation.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:follow_up_app/shared/style_constants.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class UserResearch extends StatefulWidget {
  @override
  _UserResearchState createState() => _UserResearchState();
}

class _UserResearchState extends State<UserResearch> {
  String search = '';

  late Future<List<ChatUserData>> _searchUsers = DatabaseService.getUsersByName(search);

  Widget searchListByName() {
    return search.isNotEmpty
        ? FutureBuilder<List<ChatUserData>>(
            future: _searchUsers,
            builder: (context, asyncSnap) {
              //todo: add more cases (i.e. show an error msg if an error occurs)
              if (asyncSnap.connectionState != ConnectionState.done) {
                return Loading();
              }
              List<ChatUserData>? matchingUsers = asyncSnap.data;
              return matchingUsers != null && matchingUsers.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: matchingUsers.length,
                      itemBuilder: (context, index) {
                        return SearchTile(matchingUsers[index]);
                      },
                    )
                  : Container();
            })
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    const _referenceHeight = 820.5714285714286;
    const _referenceWidth = 411.42857142857144;
    final double contextHeight = MediaQuery.of(context).size.height;
    final double contextWidth = MediaQuery.of(context).size.width;
    var heightRatio = contextHeight / _referenceHeight;
    var widthRatio = contextWidth / _referenceWidth;

    return Container(
      padding: EdgeInsets.only(top: 50.0 * heightRatio, left: 20.0 * widthRatio, right: 20.0 * widthRatio),
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Search by name'),
                  onFieldSubmitted: (name) {
                    setState(() => search = name);
                  },
                ),
              ),
              Icon(Icons.search)
            ],
          ),
          searchListByName(),
        ],
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  final ChatUserData chatUser;

  const SearchTile(this.chatUser);

  @override
  Widget build(BuildContext context) {
    const _referenceHeight = 820.5714285714286;
    const _referenceWidth = 411.42857142857144;
    final double contextHeight = MediaQuery.of(context).size.height;
    final double contextWidth = MediaQuery.of(context).size.width;
    var heightRatio = contextHeight / _referenceHeight;
    var widthRatio = contextWidth / _referenceWidth;

    return Container(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chatUser.firstName! + ' ' + chatUser.lastName!,
                style: TextStyle(fontSize: 17),
              ),
              Text(
                chatUser.email!,
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).buttonColor, borderRadius: BorderRadius.circular(20)),
            child: TextButton(
              child: Text(
                'Message',
                style: TextStyle(color: Theme.of(context).textSelectionColor),
              ),
              onPressed: () {
                createChatRoom(context, chatUser);
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> createChatRoom(BuildContext context, ChatUserData chatUser) async {
  ChatUserData signedInChatUser =
      ChatUserData.fromUserData(Provider.of<UserData?>(context)!); //create a chat user from the current user (for chatroom creation)

  //create chatroom
  List<ChatUserData> members = [chatUser, signedInChatUser];
  ChatroomData chatroomData = ChatroomData(Uuid().v4(), name: 'Chat between ${chatUser.firstName!} ${signedInChatUser.firstName!}', members: members);

  //add it to the database
  await DatabaseService.addChatroom(signedInChatUser.uid, chatroomData);

  //switch to the new chatroom
  Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(chatroomData)));
}
