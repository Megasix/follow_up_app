import 'dart:math';

import 'package:flutter/material.dart';
import 'package:follow_up_app/models/enums.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:follow_up_app/shared/snackbar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class InstructorCreator extends StatefulWidget {
  InstructorCreator({Key? key}) : super(key: key);

  @override
  _InstructorCreatorState createState() => _InstructorCreatorState();
}

class _InstructorCreatorState extends State<InstructorCreator> {
  final _formKey = GlobalKey<FormState>();

  String code = '######';
  String firstName = '';
  String lastName = '';

  //generates a random 6 alpha-numeric characters string (generated by Copilot btw)
  void _generateCode() {
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    var tempCode = '';
    for (var i = 0; i < 6; i++) {
      tempCode += possible[((Random().nextDouble() * possible.length).floor())];
    }

    setState(() => code = tempCode);
  }

  void _closePopup() {
    Navigator.pop(context, true);
  }

  void _submitInstructor() async {
    UserData newInstructor = new UserData(Uuid().v4(), UserType.INSTRUCTOR,
        activationCode: code, schoolCode: Provider.of<SchoolData>(context, listen: false).displayCode, firstName: firstName, lastName: lastName);

    await DatabaseService.updateUser(newInstructor);

    CustomSnackbar.showBar(context, newInstructor.firstName + ' ' + newInstructor.lastName + ' has been added to the database.');

    _closePopup();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _closePopup(),
      child: Material(
        key: UniqueKey(),
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 2 / 3,
                minHeight: MediaQuery.of(context).size.height * 1 / 2,
                maxHeight: MediaQuery.of(context).size.height * 2 / 3,
              ),
              child: Container(
                color: Colors.grey[850],
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text('New Instructor', style: Theme.of(context).textTheme.headline4!),
                      SizedBox(height: 16),
                      ElevatedButton(
                        child: Text('Generate New Instructor Code'),
                        onPressed: () => _generateCode(),
                      ),
                      Center(
                        heightFactor: 3,
                        child: SelectableText(code, style: Get.textTheme.headline1!),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Form(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Tooltip(
                                message: 'Instructor\'s First Name',
                                child: TextFormField(
                                  onChanged: (val) => setState(() => firstName = val),
                                  validator: (val) => val == null || val.isEmpty || val.length > 15 ? 'First name must be 15 characters or less' : null,
                                  decoration: const InputDecoration(
                                    hintText: "First Name",
                                  ),
                                ),
                              ),
                              Tooltip(
                                message: 'Instructor\'s Last Name',
                                child: TextFormField(
                                  onFieldSubmitted: (val) => _submitInstructor(),
                                  onChanged: (val) => setState(() => lastName = val),
                                  validator: (val) => val == null || val.isEmpty || val.length > 15 ? 'Last name must be 15 characters or less' : null,
                                  decoration: const InputDecoration(
                                    hintText: "Last Name",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        child: Text('Submit Instructor'),
                        onPressed: code == '######' || !(_formKey.currentState?.validate() ?? false) ? null : () => _submitInstructor(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
