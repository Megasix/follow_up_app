import 'package:flutter/material.dart';
import 'package:follow_up_app/shared/constants.dart';

class ConversationScreen extends StatefulWidget {
  final String recipientName;

  const ConversationScreen(this.recipientName);

  @override
  _ConversationScreenState createState() => _ConversationScreenState(recipientName);
}

class _ConversationScreenState extends State<ConversationScreen> {
  final String recipientName;

  _ConversationScreenState(this.recipientName);

  Widget messageList(){

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
              child: Container(),
            ),
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: Theme.of(context).accentColor),
              child: TextFormField(decoration: textInputDecoration.copyWith(hintText: 'Message', contentPadding: EdgeInsets.only(left: 10.0))),
            ),
          ],
        ),
      ),
    );
  }
}
