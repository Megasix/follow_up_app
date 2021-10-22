import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/shared/features/sizeable_button.dart';
import 'package:follow_up_app/shared/style_constants.dart';
import 'package:get/get.dart';

class ForgotPassDialogBox extends StatefulWidget {
  const ForgotPassDialogBox({Key? key}) : super(key: key);

  @override
  State<ForgotPassDialogBox> createState() => _ForgotPassDialogBoxState();
}

class _ForgotPassDialogBoxState extends State<ForgotPassDialogBox> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? email;

  void _closePopup(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _closePopup(context),
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
                maxHeight: Get.height * 7 / 8,
              ),
              child: Container(
                color: Get.theme.backgroundColor,
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('FORGOT PASSWORD?', style: Get.textTheme.headline3),
                      SizedBox(height: 10),
                      Text('We can help!', style: Get.textTheme.headline4),
                      Spacer(),
                      Padding(padding: const EdgeInsets.only(right: 15), child: Text('Email', style: Get.textTheme.headline5)),
                      SizedBox(height: 5),
                      TextFormField(
                        style: Get.textTheme.bodyText1,
                        cursorColor: Colors.yellow[900],
                        enableSuggestions: true,
                        autocorrect: true,
                        initialValue: email,
                        autovalidateMode: AutovalidateMode.always,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) => email = value,
                        decoration: textInputDecoration,
                        validator: FormBuilderValidators.compose([FormBuilderValidators.required(context), FormBuilderValidators.email(context)]),
                      ),
                      SizedBox(height: 20),
                      SizeableButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            AuthService.forgotPassword(context, email as String);
                            Navigator.pop(context);
                          }
                        },
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
      ),
    );
  }
}
