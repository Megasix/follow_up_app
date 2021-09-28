import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:follow_up_app/gen/assets.gen.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    final SchoolData? schoolData = Provider.of<SchoolData?>(context); //the signed in school
    Future<List<UserData>> _schoolUsers(String id) => DatabaseService.getUsersBySchool(id);

    return schoolData == null
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('${schoolData.name} - Admin Home'),
              actions: [
                IconButton(onPressed: () {}, icon: Icon(Icons.plus_one_rounded)),
                IconButton(onPressed: () => AuthService.signOutAll(), icon: Icon(Icons.logout_rounded)),
              ],
            ),
            drawer: Drawer(
                child: Column(children: <Widget>[
              //Drawer's Header
              DrawerHeader(child: const SizedBox(width: 150), decoration: BoxDecoration(image: DecorationImage(image: Assets.images.followUpLogo01))),

              //Rest of Drawer's Info
              const SizedBox(height: 5),
              Text('SCHOOL ID', style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 3),
              Text(schoolData.displayId ?? 'None', style: Theme.of(context).textTheme.subtitle1),
            ])),
            body: Container(
                child: FutureBuilder<List<UserData>>(
                    future: _schoolUsers(schoolData.uid),
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
