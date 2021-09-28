import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:follow_up_app/gen/assets.gen.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/screens/admin/_modules/student_card.dart';
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
  bool _isShowingStudents = true;

  @override
  Widget build(BuildContext context) {
    final SchoolData? schoolData = Provider.of<SchoolData?>(context); //the signed in school
    Future<List<UserData>> _schoolStudents(String id) => DatabaseService.getStudentsBySchool(id);
    Future<List<UserData>> _schoolInstructors(String id) => DatabaseService.getInstructorsBySchool(id);

    return schoolData == null
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('${schoolData.name} - ${_isShowingStudents ? 'Students' : 'Instructors'}'),
              actions: [
                if (!_isShowingStudents) IconButton(onPressed: () {}, icon: Icon(Icons.plus_one_rounded)), //to add a new instructor
                IconButton(onPressed: () => AuthService.signOutAll(), icon: Icon(Icons.logout_rounded)), //to sign out
              ],
            ),
            floatingActionButton: CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).accentColor,
              child: IconButton(
                iconSize: 30,
                color: Colors.white,
                alignment: Alignment.center,
                icon: Icon(Icons.change_circle_rounded),
                onPressed: () => setState(() => _isShowingStudents = !_isShowingStudents),
              ),
            ),
            drawer: Drawer(
              child: Column(
                children: <Widget>[
                  //Drawer's Header
                  DrawerHeader(child: const SizedBox(width: 150), decoration: BoxDecoration(image: DecorationImage(image: Assets.images.followUpLogo01))),

                  //Rest of Drawer's Info
                  const SizedBox(height: 5),
                  Text('SCHOOL ID', style: Theme.of(context).textTheme.headline6),
                  const SizedBox(height: 3),
                  Text(schoolData.displayId ?? 'None', style: Theme.of(context).textTheme.subtitle1),
                ],
              ),
            ),
            body: Container(
              padding: const EdgeInsets.all(12),
              child: FutureBuilder<List<UserData>>(
                  future: _isShowingStudents ? _schoolStudents(schoolData.uid) : _schoolInstructors(schoolData.uid),
                  builder: (context, asyncSnap) {
                    if (asyncSnap.connectionState != ConnectionState.done) {
                      return Loading();
                    }

                    List<UserData>? matchingUsers = asyncSnap.data;

                    return matchingUsers == null || matchingUsers.isEmpty
                        ? Center(child: Text('No ${_isShowingStudents ? 'Students' : 'Instructors'} to show...'))
                        : GridView.builder(
                            itemCount: matchingUsers?.length,
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 400, mainAxisSpacing: 12, crossAxisSpacing: 12),
                            itemBuilder: (context, index) {
                              return StudentCard(userData: matchingUsers![index]);
                            });
                  }),
            ),
          );
  }
}
