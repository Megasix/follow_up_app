import 'package:flutter/material.dart';
import 'package:follow_up_app/models/setting.dart';
import 'package:follow_up_app/screens/home/setting_list.dart';
import 'package:follow_up_app/screens/home/settings_form.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();

    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingsForm(),
            );
          });
    }

    return StreamProvider<List<Setting>>.value(
      value: DatabaseService().usersSettings,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Home'),
          backgroundColor: Colors.blueGrey,
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () async {
                  _authService.signOut();
                },
                icon: Icon(Icons.person),
                label: Text('Sign Out')),
            FlatButton.icon(onPressed: () => _showSettingsPanel(), icon: Icon(Icons.settings), label: Text('Settings'))
          ],
        ),
        body: SettingList(),
      ),
    );
  }
}
