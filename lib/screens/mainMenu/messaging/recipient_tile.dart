import 'package:flutter/material.dart';
import 'package:follow_up_app/models/user.dart';

class RecipientTile extends StatelessWidget {
  final UsersRecipient recipient;

  const RecipientTile({this.recipient});

  @override
  Widget build(BuildContext context) {
    const _referenceHeight = 820.5714285714286;
    const _referenceWidth = 411.42857142857144;
    final double contextHeight = MediaQuery.of(context).size.height;
    final double contextWidth = MediaQuery.of(context).size.width;
    var heightRatio = contextHeight / _referenceHeight;
    var widthRatio = contextWidth / _referenceWidth;

    return Padding(
      padding: EdgeInsets.only(top: 8.0 * heightRatio),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0*widthRatio, 6.0*heightRatio, 20.0*widthRatio, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
          ),
          title: Text(recipient.firstName + ' ' + recipient.lastName),
        ),
      ),
    );
  }
}
