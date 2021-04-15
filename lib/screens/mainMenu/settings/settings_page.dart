import 'package:flutter/material.dart';
import 'package:follow_up_app/screens/mainMenu/settings/display_settings_form.dart';
import 'package:follow_up_app/services/auth.dart';

class SettingsPage extends StatelessWidget {
  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    const _referenceHeight = 820.5714285714286;
    const _referenceWidth = 411.42857142857144;
    final double contextHeight = MediaQuery.of(context).size.height;
    final double contextWidth = MediaQuery.of(context).size.width;
    var sameTypeVerticalPadding = 10.0 * contextHeight / _referenceHeight;
    var generalVerticalPadding = 30.0 * contextHeight / _referenceHeight;
    var heightRatio = contextHeight / _referenceHeight;
    var widthRatio = contextWidth / _referenceWidth;

    void _showSettingsPanel(Widget settingPanel) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.only(left: 10.0*widthRatio, top: 10.0*heightRatio, right: 10.0*widthRatio, bottom: 10.0*heightRatio),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: settingPanel,
            );
          });
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 50.0*heightRatio, left: 10.0*widthRatio, right: 10.0*widthRatio, bottom: 50.0*heightRatio),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: contextWidth,
              child: Container(
                padding: EdgeInsets.only(top: 10.0*heightRatio, left: 5.0*widthRatio, right: 5.0*widthRatio, bottom: 10.0*heightRatio),
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
                    SizedBox(height: sameTypeVerticalPadding),
                    FlatButton(
                        onPressed: () {},
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.account_circle),
                            SizedBox(width: 8.0*widthRatio),
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
                            SizedBox(width: 8.0*widthRatio),
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
            SizedBox(height: generalVerticalPadding),
            SizedBox(
              width: contextWidth,
              child: Container(
                padding: EdgeInsets.only(top: 10.0*heightRatio, left: 5.0*widthRatio, right: 5.0*widthRatio, bottom: 10.0*heightRatio),
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
                    SizedBox(height: sameTypeVerticalPadding),
                    FlatButton(
                        onPressed: () {
                          _showSettingsPanel(DisplaySettingsForm());
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.settings_display),
                            SizedBox(width: 8.0*widthRatio),
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
