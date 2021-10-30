import 'package:flutter/material.dart';
import 'package:follow_up_app/generated/assets.gen.dart';
import 'package:follow_up_app/models/enums.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/screens/admin/_widgets/user_card.dart';
import 'package:follow_up_app/screens/admin/_widgets/student_card.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:follow_up_app/shared/page_routes.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  bool _isShowingStudents = true;

  void _showCreateUser() {
    Navigator.push(context, Routes.userEditorPage(_isShowingStudents ? UserType.STUDENT : UserType.INSTRUCTOR));
  }

  @override
  Widget build(BuildContext context) {
    final SchoolData? schoolData = Provider.of<SchoolData?>(context); //the signed in school
    Stream<List<UserData>> _schoolStudents(String id) => DatabaseService.streamSchoolStudents(id);
    Stream<List<UserData>> _schoolInstructors(String id) => DatabaseService.streamSchoolInstructors(id);

    return schoolData == null
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('${schoolData.name} - ${_isShowingStudents ? 'Students' : 'Instructors'}'),
              actions: [
                IconButton(onPressed: () => _showCreateUser(), icon: Icon(Icons.plus_one_rounded)), //to add a new instructor
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
                  DrawerHeader(
                    child: const SizedBox(width: 150),
                    decoration: BoxDecoration(image: DecorationImage(image: Get.isDarkMode ? Assets.images.followUpLogo01 : Assets.images.darkFollowUpLogo01)),
                  ),
                  //Rest of Drawer's Info
                  const SizedBox(height: 5),
                  Text('SCHOOL CODE', style: Theme.of(context).textTheme.headline6),
                  const SizedBox(height: 3),
                  Text(schoolData.displayCode, style: Theme.of(context).textTheme.subtitle1),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: StreamBuilder<List<UserData>>(
                  key: UniqueKey(),
                  initialData: null,
                  stream: _isShowingStudents ? _schoolStudents(schoolData.displayCode) : _schoolInstructors(schoolData.displayCode),
                  builder: (context, asyncSnap) {
                    if (asyncSnap.connectionState != ConnectionState.active) {
                      return Loading();
                    }

                    List<UserData>? matchingUsers = asyncSnap.data;

                    return matchingUsers == null || matchingUsers.isEmpty
                        ? Center(child: Text('No ${_isShowingStudents ? 'Students' : 'Instructors'} to show...'))
                        : GridView.builder(
                            itemCount: matchingUsers.length,
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 400, mainAxisSpacing: 12, crossAxisSpacing: 12),
                            itemBuilder: (context, index) {
                              return UserCard(key: ValueKey(index), userData: matchingUsers[index]);
                            });
                  }),
            ),
          );
  }
}
