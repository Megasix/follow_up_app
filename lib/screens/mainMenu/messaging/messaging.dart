import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/screens/mainMenu/messaging/user_research.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:follow_up_app/shared/constants.dart';
import 'package:provider/provider.dart';

class Messaging extends StatefulWidget {
  @override
  _MessagingState createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DatabaseService _databaseService = new DatabaseService();

  Stream chatRoomStream;

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    UsersRecipient recipient = getRecipient(snapshot.data.docs[index].get('users'));
                    return ChatRoomTile(recipient);
                  })
              : Container(color: Colors.black,);
        });
  }

  UsersRecipient getRecipient(List users) {
    DocumentSnapshot snapshot;
    if (users[0] == UserInformations.userEmail)
      _databaseService.getUserByEmail(users[1]).then((value) => snapshot = value);
    else
      _databaseService.getUserByEmail(users[0]).then((value) => snapshot = value);
    return UsersRecipient(
      snapshot.get('firsName'),
      snapshot.get('lastName'),
      snapshot.get('country'),
      snapshot.get('email'),
      snapshot.get('phoneNumber'),
      snapshot.get('birthDate'),
      snapshot.get('profilePictureAdress'),
    );
  }

  void _openDrawer() {
    _scaffoldKey.currentState.openEndDrawer();
  }

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _databaseService.getChatRooms(UserInformations.userFirstName).then((val) {
      setState(() {
        chatRoomStream = val;
      });
    });
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
        color: Colors.black,
        child: chatRoomList(),
      ),
      endDrawer: UserResearch(),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final UsersRecipient recipient;

  const ChatRoomTile(this.recipient);

  @override
  Widget build(BuildContext context) {
    const _referenceHeight = 820.5714285714286;
    const _referenceWidth = 411.42857142857144;
    final double contextHeight = MediaQuery.of(context).size.height;
    final double contextWidth = MediaQuery.of(context).size.width;
    var heightRatio = contextHeight / _referenceHeight;
    var widthRatio = contextWidth / _referenceWidth;

    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Theme.of(context).backgroundColor,
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
    );
  }
}
