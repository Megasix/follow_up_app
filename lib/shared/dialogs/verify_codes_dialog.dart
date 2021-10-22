import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:follow_up_app/shared/features/sizeable_button.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:follow_up_app/shared/snackbar.dart';
import 'package:follow_up_app/shared/style_constants.dart';
import 'package:get/get.dart';

class VerifyCodesDialogBox extends StatefulWidget {
  const VerifyCodesDialogBox({Key? key}) : super(key: key);

  @override
  State<VerifyCodesDialogBox> createState() => _VerifyCodesDialogBoxState();
}

class _VerifyCodesDialogBoxState extends State<VerifyCodesDialogBox> {
  static const double FIELD_SPACE = 10;

  bool _loading = false;

  String schoolCode = '';
  String activationCode = '';

  void _checkCodes() async {
    setState(() => _loading = true);

    //TODO: change web code so that the collection is correctly named
    final String? schoolId = await DatabaseService.isSchoolCodeValid(schoolCode);

    if (schoolId != null) {
      final UserData? userData = await DatabaseService.isActivationCodeValid(activationCode);
      Navigator.pop(context, userData);
    } else {
      CustomSnackbar.showBar(context, 'School or Activation Code are invalid...');
    }

    setState(() => _loading = false);
  }

  Future<bool> _closePopup(BuildContext context) {
    if (!_loading) Navigator.pop(context); //avoid closing the popup while processing information
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _closePopup(context),
      child: Scaffold(
        key: UniqueKey(),
        backgroundColor: Colors.black.withOpacity(0.7),
        body: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: Get.width * 9 / 10,
                minHeight: Get.height * 1 / 2,
                maxHeight: Get.size.height * 5 / 6,
              ),
              child: _loading
                  ? Loading()
                  : Container(
                      color: Get.theme.backgroundColor,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('BEFORE WE FORGET', style: Get.textTheme.headline3),
                          SizedBox(height: 10),
                          Text('Your codes!', style: Get.textTheme.headline4),
                          Spacer(),
                          Padding(padding: const EdgeInsets.only(right: 15), child: Text('School Code', style: Get.textTheme.headline5)),
                          TextFormField(
                            style: Get.textTheme.bodyText1,
                            cursorColor: Colors.yellow[900],
                            obscureText: false,
                            enableSuggestions: true,
                            autocorrect: true,
                            initialValue: schoolCode,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) => schoolCode = value,
                            decoration: textInputDecoration,
                            validator: FormBuilderValidators.compose([FormBuilderValidators.required(context), FormBuilderValidators.email(context)]),
                          ),
                          SizedBox(height: FIELD_SPACE),
                          Padding(padding: const EdgeInsets.only(right: 15), child: Text('Activation Code', style: Get.textTheme.headline5)),
                          TextFormField(
                            style: Get.textTheme.bodyText1,
                            cursorColor: Colors.yellow[900],
                            obscureText: false,
                            enableSuggestions: true,
                            autocorrect: true,
                            initialValue: activationCode,
                            textInputAction: TextInputAction.done,
                            onChanged: (value) => activationCode = value,
                            decoration: textInputDecoration,
                            validator: FormBuilderValidators.compose([FormBuilderValidators.required(context), FormBuilderValidators.email(context)]),
                          ),
                          SizedBox(height: FIELD_SPACE * 2),
                          SizeableButton(
                            onPressed: () => _checkCodes(),
                            buttonBorderColor: Colors.yellow[700]!,
                            centered: true,
                            children: [Text('Submit!', style: Get.textTheme.bodyText1)],
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
