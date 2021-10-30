import 'dart:math';

import 'package:flutter/material.dart';
import 'package:follow_up_app/models/enums.dart';
import 'package:follow_up_app/models/rides.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/screens/mainMenu/statistics/statistics.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
    late Future<List<RideData>> _ridesFuture = DatabaseService.getRides(widget.userData.uid);

    return GestureDetector(
      onTap: () => _closePopup(),
      child: Material(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
                minHeight: MediaQuery.of(context).size.height * 0.7,
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              color: Colors.grey[850],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Hero(
                    tag: ValueKey(widget.userData.uid),
                    child: SizedBox(
                      height: 125,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FittedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.userData.firstName + ' ' + widget.userData.lastName,
                                    style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.white),
                                  ),
                                  SelectableText(widget.userData.uid,
                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white60, fontStyle: FontStyle.italic)),
                                ],
                              ),
                            ),
                            if (widget.userData.profilePictureUrl != null)
                              ClipRRect(borderRadius: kBorderRadius, child: Image.network(widget.userData.profilePictureUrl!)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 6),
                          SelectableText(widget.userData.type == UserType.STUDENT ? 'Student' : 'Instructor',
                              style: Theme.of(context).textTheme.headline6!.copyWith(fontStyle: FontStyle.italic)),
                          SelectableText(widget.userData.email != null && widget.userData.email!.isNotEmpty ? widget.userData.email as String : 'No Email #',
                              style: Theme.of(context).textTheme.headline6!),
                          Divider(height: 24, thickness: 2, endIndent: 200),
                          SelectableText(
                              widget.userData.phoneNumber != null && widget.userData.phoneNumber!.isNotEmpty
                                  ? widget.userData.phoneNumber as String
                                  : 'No Phone #',
                              style: Theme.of(context).textTheme.headline6!),
                          SizedBox(height: 6),
                          SelectableText(
                              widget.userData.birthDate == null ? 'No Birthday' : DateFormat('yyyy-MM-dd').format(widget.userData.birthDate!.toDate()),
                              style: Theme.of(context).textTheme.headline6!),
                          Divider(height: 24, thickness: 2, endIndent: 200),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Has Activated?', style: Theme.of(context).textTheme.headline6!),
                              Checkbox(value: widget.userData.isActive, onChanged: null),
                            ],
                          ),
                          SelectableText(widget.userData.activationCode, style: Theme.of(context).textTheme.headline6!),
                          Divider(height: 24, thickness: 2, endIndent: 200),
                          SizedBox(height: 18),
                          Expanded(
                            child: FutureBuilder<List<RideData>?>(
                                future: _ridesFuture,
                                builder: (context, asyncSnap) {
                                  //todo: add more cases (i.e. show an error msg if an error occurs)
                                  if (asyncSnap.connectionState != ConnectionState.done) {
                                    return Loading();
                                  }

                                  List<RideData>? rides = asyncSnap.data;
                                  print(rides);

                                  return rides != null && rides.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: rides.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: RideTile(
                                                rideData: rides[index],
                                              ),
                                            );
                                          },
                                        )
                                      : Container();
                                }),
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
    );
  }
}
