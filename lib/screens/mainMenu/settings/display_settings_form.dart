import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:follow_up_app/main.dart';
import 'package:follow_up_app/models/setting.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/shared/constants.dart';
import 'package:follow_up_app/shared/shared.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DisplaySettingsForm extends StatefulWidget {
  @override
  _DisplaySettingsFormState createState() => _DisplaySettingsFormState();
}

class _DisplaySettingsFormState extends State<DisplaySettingsForm> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser>(context);
    final themeOptions = [ThemeMode.light, ThemeMode.dark];
    final double contextWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<UserDisplaySetting>(
      stream: null, //methode de database.dart qui permet de set cette valeur
      builder: (context, snapshot) {
        /* if (snapshot.hasData) {
          UserDisplaySetting userDisplaySetting = snapshot.data;*/

        return Scaffold(
          body: Center(
            child: Container(
              padding: EdgeInsets.only(top: 5.0, left: 15.0, right: 15.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Update your Display Setting',
                    textScaleFactor: 1.2,
                  ),
                  SizedBox(height: 20),
                  FormBuilder(
                    child: SizedBox(
                      width: contextWidth,
                      child: FormBuilderDropdown(
                        name: 'Theme choice',
                        decoration: textInputDecoration.copyWith(labelText: 'Theme'),
                        allowClear: true,
                        items: themeOptions
                            .map((theme) => DropdownMenuItem(
                                  value: theme,
                                  child: Text("${theme == ThemeMode.light ? "Light" : "Dark"}"),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _themeMode = value as ThemeMode;
                            Get.changeThemeMode(_themeMode);
                            Shared.setTheme(_themeMode == ThemeMode.light);
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
        /* } else {
          return Loading();
        }*/
      },
    );
  }
}
