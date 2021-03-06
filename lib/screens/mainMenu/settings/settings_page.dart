import 'package:flutter/material.dart';
import 'package:follow_up_app/screens/mainMenu/settings/display_settings_form.dart';
import 'package:follow_up_app/services/auth.dart';

class SettingsPage extends StatelessWidget {
  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final double sameTypePadding = 10.0;
    final double generalTypePadding = 20.0;
    final double contextWidth = MediaQuery.of(context).size.width;

    void _showSettingsPanel(Widget settingPanel) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: settingPanel,
            );
          });
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0, bottom: 50.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: contextWidth,
              child: Container(
                padding: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0, bottom: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  color: Theme.of(context).backgroundColor,
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Personal settings',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                      ),
                    ),
                    SizedBox(height: sameTypePadding),
                    FlatButton(
                        onPressed: () {},
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.account_circle),
                            SizedBox(width: 8.0),
                            Text('Edit profile'),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 15.0,
                            ),
                          ],
                        )),
                    FlatButton(
                        onPressed: () {},
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.poll),
                            SizedBox(width: 8.0),
                            Text('Unit type'),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 15.0,
                            ),
                          ],
                        )),
                    FlatButton(
                        onPressed: () {},
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.notifications),
                            SizedBox(width: 8.0),
                            Text('Notifications'),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 15.0,
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            SizedBox(height: generalTypePadding),
            SizedBox(
              width: contextWidth,
              child: Container(
                padding: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0, bottom: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  color: Theme.of(context).backgroundColor,
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Application settings',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                      ),
                    ),
                    SizedBox(height: sameTypePadding),
                    FlatButton(
                        onPressed: () {
                          _showSettingsPanel(DisplaySettingsForm());
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.settings_display),
                            SizedBox(width: 8.0),
                            Text('Display'),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 15.0,
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: contextWidth,
              height: 20.0,
              child: FlatButton(
                onPressed: () async {
                  await _authService.signOut();
                },
                child: Text('Sign Out'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
