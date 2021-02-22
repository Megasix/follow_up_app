import 'package:flutter/material.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:follow_up_app/shared/constants.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> hobbies = ['sports', 'litterature', 'video games', 'music', 'nothing'];

  //form values
  String _currentName;
  String _currentHobby;
  int _currentAge;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;

            return Form(
              child: Column(
                children: <Widget>[
                  Text(
                    'Update your User Settings.',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: userData.name,
                    decoration: textInputDecoration.copyWith(hintText: 'Name'),
                    validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  SizedBox(height: 20.0),
                  DropdownButtonFormField(
                    decoration: textInputDecoration.copyWith(prefixText: 'Hobby : '),
                    value: _currentHobby ?? userData.hobby,
                    items: hobbies.map((hobby) {
                      return DropdownMenuItem(value: hobby, child: Text('$hobby'));
                    }).toList(),
                    onChanged: (val) => setState(() => _currentHobby = val),
                  ),
                  SizedBox(height: 20.0),
                  Slider(
                    value: (_currentAge ?? userData.age).toDouble(),
                    inactiveColor: Colors.brown[50],
                    activeColor: Colors.blueGrey[(double.parse(((_currentAge ?? 16) / 100).toStringAsFixed(1)) * 1000).toInt()],
                    min: 16.0,
                    max: 80.0,
                    divisions: 64,
                    label: (_currentAge ?? userData.age).round().toString(),
                    onChanged: (val) => setState(() => _currentAge = val.round()),
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                      color: Colors.blueGrey,
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await DatabaseService(uid: user.uid).updateUserData(
                              _currentName ?? userData.name,
                              _currentAge ?? userData.age,
                              _currentHobby ?? userData.hobby);
                          Navigator.pop(context);
                        }
                      })
                ],
              ),
              key: _formKey,
            );
          } else {
            return Loading();
          }
        });
  }
}
