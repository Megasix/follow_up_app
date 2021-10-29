import 'package:flutter/material.dart';
import 'package:follow_up_app/screens/mainMenu/settings/display_settings_form.dart';
import 'package:follow_up_app/screens/mainMenu/settings/profile_settings_form.dart';
import 'package:follow_up_app/screens/mainMenu/settings/unit_setting_form.dart';
import 'package:follow_up_app/services/auth.dart';

class SettingsPage extends StatelessWidget {
  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel(Widget settingPanel) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: settingPanel,
            );
          });
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        color: Theme.of(context).backgroundColor,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'Personal settings',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                            ),
                          ),
                          SettingButton(Icons.alternate_email, 'Account Informations', context, (){}),
                          SettingButton(Icons.account_circle, 'Edit profile', context, (){_showSettingsPanel(ProfileSettingForm());}),
                          SettingButton(Icons.school, 'School', context, (){}),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        color: Theme.of(context).backgroundColor,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'Application settings',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                            ),
                          ),
                          SettingButton(Icons.settings_display, 'Display', context, (){_showSettingsPanel(DisplaySettingsForm());}),
                          SettingButton(Icons.notifications, 'Notifications', context, (){}),
                          SettingButton(Icons.poll, 'Unit system', context, (){_showSettingsPanel(UnitSettingForm());}),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 20.0,
              child: TextButton(
                onPressed: () {
                  AuthService.signOutAll();
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

Widget SettingButton (IconData icon, String title, BuildContext context,void Function()? function ){
  return TextButton(
    style: TextButton.styleFrom(primary: Theme.of(context).accentColor),
      onPressed: function,
      child: Row(
        children: <Widget>[
          Icon(icon),
          SizedBox(width: 8.0),
          Text(title),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            size: 15.0,
          ),
        ],
      ));
}