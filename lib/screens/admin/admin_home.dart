import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:follow_up_app/shared/loading.dart';

class AdminHome extends StatefulWidget {
  AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final Future<List<UserData>> _users =
      DatabaseService.getUsersBySchool('b'); //TODO: create school object, get school object on login and use that to get users

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.plus_one_rounded)),
          IconButton(onPressed: () => AuthService.signOutAll(), icon: Icon(Icons.logout_rounded)),
        ],
      ),
      body: Container(
          child: FutureBuilder<List<UserData>>(
              future: _users,
              builder: (context, asyncSnap) {
                if (asyncSnap.connectionState != ConnectionState.done) {
                  return Loading();
                }

                List<UserData>? matchingUsers = asyncSnap.data;

                return GridView.builder(
                    itemCount: matchingUsers?.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 400),
                    itemBuilder: (context, index) {
                      return Card(
                        child: Text('This is ${matchingUsers?[index].firstName}'),
                      );
                    });
              })),
    );
  }
}
