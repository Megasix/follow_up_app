import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:provider/provider.dart';

class ProfileSettingForm extends StatefulWidget {
  @override
  _ProfileSettingFormState createState() => _ProfileSettingFormState();
}

class _ProfileSettingFormState extends State<ProfileSettingForm> {
  @override
  Widget build(BuildContext context) {
    final UserData user = Provider.of<UserData?>(context)!;
    final double contextWidth = MediaQuery.of(context).size.width;
    final countryOptions = ['Canada', 'France'];
    String firstName = user.firstName, lastName = user.lastName;
    String? country = user.country;
    Timestamp? birthDate = user.birthDate;

    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: <Widget>[
              Text(
                'Verify your Personal Informations',
                textScaleFactor: 1.2,
              ),
              SizedBox(height: 20),
              FormBuilder(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                        width: contextWidth,
                        child: FormBuilderTextField(
                          name: 'FirstName',
                          initialValue: firstName,
                          onSaved: (value){
                            firstName = value ?? firstName;
                          },
                        )),
                    SizedBox(height: 10),
                    SizedBox(
                        width: contextWidth,
                        child: FormBuilderTextField(
                          name: 'LastName',
                          initialValue: lastName,
                          onSaved: (value){
                            lastName = value ?? lastName;
                          },
                        )),
                    SizedBox(height: 10),
                    SizedBox(
                        width: contextWidth,
                        child: FormBuilderDropdown(
                          name: 'Country',
                          initialValue: country,
                          allowClear: true,
                          items: countryOptions
                              .map((country) => DropdownMenuItem(
                                    value: country,
                                    child: Text(country),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            country = value as String?;
                          },
                        )),
                    SizedBox(height: 10),
                    SizedBox(
                        width: contextWidth,
                        child: FormBuilderDateTimePicker(
                          name: 'BirthDate',
                          initialValue:
                              birthDate?.toDate() ?? DateTime.now(),
                          onSaved: (value){
                            birthDate = new Timestamp.fromDate(value!);
                          },
                        )),
                    SizedBox(height: 10),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 20.0,
                        child: TextButton(
                          onPressed: () {
                            DatabaseService.updateUser(new UserData(
                                user.uid, user.type,
                                firstName: firstName, lastName: lastName));
                          },
                          child: Text('Submit'),
                        )),
                  ],
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
  }
}
