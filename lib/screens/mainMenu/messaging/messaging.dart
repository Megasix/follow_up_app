import 'package:flutter/material.dart';
import 'package:follow_up_app/models/chat.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/screens/mainMenu/messaging/conversation.dart';
import 'package:follow_up_app/screens/mainMenu/messaging/user_research.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:provider/provider.dart';

class Messaging extends StatefulWidget {
  @override
  _MessagingState createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Stream<List<ChatroomData>> chatRoomStream = DatabaseService.streamChatrooms(Provider.of<UserData?>(context, listen: false)!);

  Widget chatRoomList() {
    return StreamBuilder<List<ChatroomData>>(
        stream: chatRoomStream,
        builder: (context, asyncSnap) {
          //todo: add more cases (i.e. show an error msg if an error occurs)
          if (asyncSnap.connectionState != ConnectionState.active) {
            return Loading();
          }
          List<ChatroomData>? chatrooms = asyncSnap.data;

          return chatrooms != null && chatrooms.isNotEmpty
              ? ListView.builder(
                  itemCount: chatrooms.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ChatRoomTile(chatrooms[index]),
                    );
                  },
                )
              : Container();
        });
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const _referenceHeight = 820.5714285714286;
    const _referenceWidth = 411.42857142857144;
    final double contextHeight = MediaQuery.of(context).size.height;
    final double contextWidth = MediaQuery.of(context).size.width;
    var heightRatio = contextHeight / _referenceHeight;
    var widthRatio = contextWidth / _referenceWidth;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      appBar: AppBar(
        title: Text('Messages'),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        elevation: 0.0,
        actions: [TextButton(onPressed: _openDrawer, child: Text('New Conversation'))],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 50.0 * heightRatio, bottom: 30.0 * heightRatio, left: 25.0 * widthRatio, right: 25.0 * widthRatio),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0)),
          color: Theme.of(context).backgroundColor,
        ),
        child: chatRoomList(),
      ),
      endDrawer: Column(
        children: [
          Expanded(child: UserResearch()),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).backgroundColor,
            child: TextButton(
              onPressed: _closeDrawer,
              child: Text('Close'),
            ),
          )
        ],
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final ChatroomData chatroomData;

  const ChatRoomTile(this.chatroomData);

  @override
  Widget build(BuildContext context) {
    const _referenceHeight = 820.5714285714286;
    const _referenceWidth = 411.42857142857144;
    final double contextHeight = MediaQuery.of(context).size.height;
    final double contextWidth = MediaQuery.of(context).size.width;
    var heightRatio = contextHeight / _referenceHeight;
    var widthRatio = contextWidth / _referenceWidth;

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(chatroomData)));
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Theme.of(context).accentColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              chatroomData.name,
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  child: Text(chatroomData.members.firstWhere((member) => member.uid == chatroomData.lastMessage?.authorId).firstName as String),
                ),
                SizedBox(width: 8.0),
                Text(chatroomData.lastMessage?.message as String),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
