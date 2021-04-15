import 'package:flutter/material.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/screens/mainMenu/messaging/recipient_list.dart';
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

  void _openDrawer() {
    _scaffoldKey.currentState.openEndDrawer();
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

    return StreamProvider<List<UsersRecipient>>.value(
      value: DatabaseService().usersRecipients,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        appBar: AppBar(
          title: Text('Messages'),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          elevation: 0.0,
          actions: [FlatButton(onPressed: _openDrawer, child: Text('New Conversation'))],
        ),
        body: Container(
          padding: EdgeInsets.only(bottom: 40.0 * heightRatio),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0)),
            color: Theme.of(context).backgroundColor,
          ),
          child: RecipientList(),
        ),
        endDrawer: UserResearch(),
      ),
    );
  }
}
