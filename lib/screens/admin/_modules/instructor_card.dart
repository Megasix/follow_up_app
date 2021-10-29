import 'dart:math';

import 'package:flutter/material.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/shared/page_routes.dart';
import 'package:intl/intl.dart';

class InstructorCard extends StatelessWidget {
  InstructorCard({Key? key, required this.userData}) : super(key: key);

  final BorderRadius kBorderRadius = BorderRadius.circular(7);

  final UserData userData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, Routes.userInfoPage(userData)),
      child: PhysicalModel(
        elevation: 5,
        borderRadius: kBorderRadius,
        color: Theme.of(context).colorScheme.background,
        child: ClipRRect(
          borderRadius: kBorderRadius,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: ValueKey(userData.uid),
                child: SizedBox(
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
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 6),
                      Text(userData.email != null && userData.email!.isNotEmpty ? userData.email as String : 'No Email #',
                          style: Theme.of(context).textTheme.headline6!),
                      Divider(height: 16, thickness: 2, endIndent: 200),
                      Text(userData.phoneNumber != null && userData.phoneNumber!.isNotEmpty ? userData.phoneNumber as String : 'No Phone #',
                          style: Theme.of(context).textTheme.headline6!),
                      SizedBox(height: 6),
                      Text(userData.birthDate == null ? 'No Birthday' : DateFormat('yyyy-MM-dd').format(userData.birthDate!.toDate()),
                          style: Theme.of(context).textTheme.headline6!),
                      Divider(height: 16, thickness: 2, endIndent: 200),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Has Registered?', style: Theme.of(context).textTheme.headline6!),
                            Checkbox(value: userData.isActive, onChanged: null),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
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
      ),
    );
  }
}
