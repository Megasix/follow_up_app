import 'package:flutter/material.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/screens/mainMenu/messaging/recipient_tile.dart';
import 'package:provider/provider.dart';

class RecipientList extends StatefulWidget {
  @override
  _RecipientListState createState() => _RecipientListState();
}

class _RecipientListState extends State<RecipientList> {
  @override
  Widget build(BuildContext context) {
    final recipients = Provider.of<List<UsersRecipient>>(context);

    return recipients != null ? ListView.builder(
        itemCount: recipients.length,
        itemBuilder: (context, index) {
          return RecipientTile(recipient: recipients[index]);
        }) : Container();
  }
}
