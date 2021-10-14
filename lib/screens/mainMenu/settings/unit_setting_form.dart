import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:follow_up_app/models/setting.dart';
import 'package:follow_up_app/shared/style_constants.dart';
import 'package:follow_up_app/shared/unit_system.dart';

class UnitSettingForm extends StatefulWidget {
  @override
  _UnitSettingFormState createState() => _UnitSettingFormState();
}

class _UnitSettingFormState extends State<UnitSettingForm> {
  @override
  Widget build(BuildContext context) {
    final double contextWidth = MediaQuery.of(context).size.width;
    final unitSystemOptions = ['Metric', 'Imperial'];

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
                    'Update your Unit System',
                    textScaleFactor: 1.2,
                  ),
                  SizedBox(height: 20),
                  FormBuilder(
                    child: SizedBox(
                      width: contextWidth,
                      child: FormBuilderDropdown(
                        name: 'Unit system',
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Unit system'),
                        allowClear: true,
                        items: unitSystemOptions
                            .map((unitSystem) => DropdownMenuItem(
                                  value: unitSystem,
                                  child: Text(unitSystem),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {});
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
