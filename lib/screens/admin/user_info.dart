import 'dart:math';

import 'package:flutter/material.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:intl/intl.dart';

class UserInfoPage extends StatefulWidget {
  UserInfoPage(this.userData, {Key? key}) : super(key: key);

  final UserData userData;

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final BorderRadius kBorderRadius = BorderRadius.circular(7);

  void _closePopup() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _closePopup(),
      child: Material(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: ClipRRect(
            borderRadius: kBorderRadius,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
                minHeight: MediaQuery.of(context).size.height * 0.65,
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              child: Container(
                color: Colors.grey[850],
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Hero(
                        tag: ValueKey(widget.userData.uid),
                        child: SizedBox(
                          height: 130,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                            child: Text(
                              widget.userData.firstName + ' ' + widget.userData.lastName,
                              style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 6),
                              Text(widget.userData.email != null && widget.userData.email!.isNotEmpty ? widget.userData.email as String : 'No Email #',
                                  style: Theme.of(context).textTheme.headline6!),
                              Divider(height: 16, thickness: 2, endIndent: 200),
                              Text(
                                  widget.userData.phoneNumber != null && widget.userData.phoneNumber!.isNotEmpty
                                      ? widget.userData.phoneNumber as String
                                      : 'No Phone #',
                                  style: Theme.of(context).textTheme.headline6!),
                              SizedBox(height: 6),
                              Text(widget.userData.birthDate == null ? 'No Birthday' : DateFormat('yyyy-MM-dd').format(widget.userData.birthDate!.toDate()),
                                  style: Theme.of(context).textTheme.headline6!),
                              Divider(height: 16, thickness: 2, endIndent: 200),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Has Registered?', style: Theme.of(context).textTheme.headline6!),
                                    Checkbox(value: widget.userData.isActive, onChanged: null),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(widget.userData.uid,
                                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white30, fontStyle: FontStyle.italic))),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
