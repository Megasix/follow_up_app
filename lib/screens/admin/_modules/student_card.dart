import 'dart:math';

import 'package:flutter/material.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:intl/intl.dart';

class StudentCard extends StatelessWidget {
  StudentCard({Key? key, required this.userData}) : super(key: key);

  final UserData userData;

  final BorderRadius kBorderRadius = BorderRadius.circular(7);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      elevation: 5,
      borderRadius: kBorderRadius,
      color: Theme.of(context).colorScheme.background,
      child: ClipRRect(
        borderRadius: kBorderRadius,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 125,
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                child: Text(
                  userData.firstName + ' ' + userData.lastName,
                  style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.white),
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
                    Text(userData.email as String, style: Theme.of(context).textTheme.headline6!),
                    SizedBox(height: 12),
                    Text(userData.phoneNumber != null && userData.phoneNumber!.isNotEmpty ? userData.phoneNumber as String : 'No Phone #',
                        style: Theme.of(context).textTheme.headline6!),
                    SizedBox(height: 5),
                    Text(userData.birthDate == null ? 'No Birthday' : DateFormat('yyyy-MM-dd').format(userData.birthDate!.toDate()),
                        style: Theme.of(context).textTheme.headline6!),
                    Expanded(
                      child: Align(
                          alignment: Alignment.bottomLeft,
                          child:
                              Text(userData.uid, style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white30, fontStyle: FontStyle.italic))),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
