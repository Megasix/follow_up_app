import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:follow_up_app/models/chat.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:follow_up_app/shared/appdata.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:follow_up_app/shared/style_constants.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ConversationScreen extends StatefulWidget {
  final ChatroomData chatroomData;

  const ConversationScreen(this.chatroomData);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final messageController = TextEditingController();
  late Stream<List<ChatMessage>> chatMessagesStream = DatabaseService.streamChatMessages(widget.chatroomData.chatroomId);

  Widget messageList() {
    return StreamBuilder<List<ChatMessage>>(
        stream: chatMessagesStream,
        builder: (context, asyncSnap) {
          //todo: add more cases (i.e. show an error msg if an error occurs)
          if (asyncSnap.connectionState != ConnectionState.done) {
            return Loading();
          }

          List<ChatMessage>? messages = asyncSnap.data;

          return messages != null && messages.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return MessageTile(messages[index].message, messages[index].author);
                  })
              : Container();
        });
  }

  sendMessage(String message) async {
    DatabaseService.addChatMessage(widget.chatroomData,
        ChatMessage(Uuid().v1(), message: message, author: ChatUserData.fromUserData(Provider.of<UserData?>(context)!), time: Timestamp.now()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: Text(widget.chatroomData.name),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(child: messageList()),
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

//todo: separate every widget in its own file, for organization purposes
class MessageTile extends StatelessWidget {
  final String message;
  final ChatUserData chatUser;

  const MessageTile(this.message, this.chatUser);

  @override
  Widget build(BuildContext context) {
    bool isUser = chatUser.uid == Provider.of<UserData?>(context)!.uid as String;

    return Container(
      padding: EdgeInsets.only(left: isUser ? 0 : 24, right: !isUser ? 0 : 24),
      margin: EdgeInsets.symmetric(vertical: 7.0),
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
