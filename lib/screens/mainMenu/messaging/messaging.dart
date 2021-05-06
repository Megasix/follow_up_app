import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/screens/mainMenu/messaging/conversation.dart';
import 'package:follow_up_app/screens/mainMenu/messaging/user_research.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:follow_up_app/shared/constants.dart';

class Messaging extends StatefulWidget {
  @override
  _MessagingState createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DatabaseService _databaseService = new DatabaseService();

  DocumentSnapshot recipientSnapshot;
  Stream chatRoomStream;

  void initChatRoomStream() async {
    await _databaseService.getChatRooms(UserInformations.userEmail).then((val) {
      chatRoomStream = val;
    });
  }

  void initRecipientSnapshot(email) async{
    recipientSnapshot = await _databaseService.getUserByEmail(email);
    print(recipientSnapshot.get('lastName'));
  }

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ChatRoomTile(
                       getUsersRecipientObjectByEmail(snapshot.data.docs[index].get('users')),
                        snapshot.data.docs[index].get('chatRoomID'),
                      ),
                    );
                  },
                )
              : Container();
        });
  }

  String getRecipientEmail(List users) {
    String email;
    if (users[0] == UserInformations.userEmail)
      email = users[1];
    else
      email = users[0];
    print(email);
    return email;
  }

  getUsersRecipientObjectByEmail(List users) {
    try {
      initRecipientSnapshot(getRecipientEmail(users));
      print(recipientSnapshot.get('firstName'));
      return UsersRecipient(
        recipientSnapshot.get('firstName'),
        recipientSnapshot.get('lastName'),
        recipientSnapshot.get('country'),
        recipientSnapshot.get('email'),
        recipientSnapshot.get('phoneNumber'),
        recipientSnapshot.get('birthDate'),
        recipientSnapshot.get('profilePictureAdress'),
      );
    }catch (error){
      print(error.toString());
      return null;
    }
  }

  void _openDrawer() {
    _scaffoldKey.currentState.openEndDrawer();
  }

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    initChatRoomStream();
    super.initState();
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
        actions: [FlatButton(onPressed: _openDrawer, child: Text('New Conversation'))],
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
            child: FlatButton(
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
  final UsersRecipient recipient;
  final String chatRoomID;

  const ChatRoomTile(this.recipient, this.chatRoomID);

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
        Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(recipient.firstName, chatRoomID)));
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Theme.of(context).accentColor,
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Theme.of(context).secondaryHeaderColor,
              ),
              child: Text(('${recipient.firstName.substring(0, 1).toUpperCase()}' + '${recipient.lastName.substring(0, 1).toUpperCase()}')),
            ),
            SizedBox(width: 8.0),
            Text((recipient.firstName + ' ' + recipient.lastName)),
          ],
        ),
      ),
    );
  }
}
