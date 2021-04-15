import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:follow_up_app/shared/constants.dart';
import 'package:follow_up_app/shared/shared_functions.dart';
import 'package:ntp/ntp.dart';

class ConversationScreen extends StatefulWidget {
  final String recipientName;
  final String chatRoomID;

  const ConversationScreen(this.recipientName, this.chatRoomID);

  @override
  _ConversationScreenState createState() => _ConversationScreenState(recipientName);
}

class _ConversationScreenState extends State<ConversationScreen> {
  final String recipientName;
  final messageController = TextEditingController();
  Stream chatMessagesStream;

  DatabaseService _databaseService = new DatabaseService();

  _ConversationScreenState(this.recipientName);

  Widget messageList() {
    return StreamBuilder(
        stream: chatMessagesStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(snapshot.data.docs[index].get('message'), snapshot.data.docs[index].get('sendBy'));
                  })
              : Container();
        });
  }

  sendMessage(String message) async {
    if (message != null) {
      Map<String, dynamic> messageMap = {
        'message': message,
        'sendBy': UserInformations.userFirstName,
        'time': await NTP.now(),
      };
      _databaseService.addConversationMessage(widget.chatRoomID, messageMap);
    }
  }

  @override
  void initState() {
    _databaseService.getConversationMessages(widget.chatRoomID).then((val) {
      chatMessagesStream = val;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: Text(recipientName),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(padding: EdgeInsets.symmetric(horizontal: 10.0), child: messageList()),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Theme.of(context).accentColor,
              ),
              child: TextFormField(
                controller: messageController,
                decoration: textInputDecoration.copyWith(hintText: 'Message', contentPadding: EdgeInsets.only(left: 10.0)),
                onFieldSubmitted: (message) {
                  setState(() {
                    sendMessage(message);
                    messageController.clear();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final String sender;

  const MessageTile(this.message, this.sender);

  @override
  Widget build(BuildContext context) {
    bool isUser = sender == UserInformations.userFirstName;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 5.0),
      width: MediaQuery.of(context).size.width,
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: isUser
            ? BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0), bottomLeft: Radius.circular(30.0)),
                color: Theme.of(context).backgroundColor,
              )
            : BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0), bottomRight: Radius.circular(30.0)),
                color: Theme.of(context).secondaryHeaderColor,
              ),
        child: Text(message),
      ),
    );
  }
}
