import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:follow_up_app/screens/mainMenu/messaging/conversation.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:follow_up_app/shared/constants.dart';
import 'package:ntp/ntp.dart';

final DatabaseService _databaseService = new DatabaseService();
String chatRoomID;

class UserResearch extends StatefulWidget {
  @override
  _UserResearchState createState() => _UserResearchState();
}

class _UserResearchState extends State<UserResearch> {
  QuerySnapshot searchSnapshotFirstName;
  QuerySnapshot searchSnapshotLastName;

  initiateSearch(name) {
    _databaseService.getUserByFirstName(name).then((value) => setState(() => searchSnapshotFirstName = value));
    _databaseService.getUserByLastName(name).then((value) => setState(() => searchSnapshotLastName = value));
  }

  Widget searchListFirstName() {
    return searchSnapshotFirstName != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshotFirstName.docs.length,
            itemBuilder: (context, index) {
              return SearchTile(
                firstName: searchSnapshotFirstName.docs[index].get('firstName'),
                lastName: searchSnapshotFirstName.docs[index].get('lastName'),
                email: searchSnapshotFirstName.docs[index].get('email'),
              );
            },
          )
        : Container();
  }

  Widget searchListLastName() {
    return searchSnapshotLastName != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshotLastName.docs.length,
            itemBuilder: (context, index) {
              return SearchTile(
                firstName: searchSnapshotLastName.docs[index].get('firstName'),
                lastName: searchSnapshotLastName.docs[index].get('lastName'),
                email: searchSnapshotLastName.docs[index].get('email'),
              );
            },
          )
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
                    initiateSearch(name);
                  },
                ),
              ),
              Icon(Icons.search)
            ],
          ),
          searchListFirstName(),
          searchListLastName(),
        ],
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;

  const SearchTile({this.firstName, this.lastName, this.email});

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
                firstName + ' ' + lastName,
                style: TextStyle(fontSize: 17),
              ),
              Text(
                email,
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).buttonColor, borderRadius: BorderRadius.circular(20)),
            child: FlatButton(
              child: Text(
                'Message',
                style: TextStyle(color: Theme.of(context).textSelectionColor),
              ),
              onPressed: () {
                createChatRoom(email);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(firstName, chatRoomID)));
              },
            ),
          ),
        ],
      ),
    );
  }
}

getChatRoomID(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0))
    return '$b\_$a';
  else
    return '$a\_$b';
}

createChatRoom(String recipientEmail) async {
  chatRoomID = getChatRoomID(UserInformations.userEmail, recipientEmail);
  List<String> usersEmail = [UserInformations.userEmail, recipientEmail];
  Map<String, dynamic> chatRoomMap = {'users': usersEmail, 'chatRoomID': chatRoomID, 'lastActivity': await NTP.now()};
  _databaseService.createChatRoom(chatRoomID, chatRoomMap);
}
