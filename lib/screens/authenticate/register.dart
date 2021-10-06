import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:follow_up_app/models/enums.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/shared/extensions.dart';
import 'package:follow_up_app/shared/style_constants.dart';
import 'package:follow_up_app/shared/features/apple.dart';
import 'package:follow_up_app/shared/features/facebook.dart';
import 'package:follow_up_app/shared/features/google.dart';
import 'package:follow_up_app/shared/features/twitter.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:follow_up_app/shared/shared.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:uuid/uuid.dart';

class Register extends StatefulWidget {
  final UserType userType;
  final Function toggleAuth;

  Register({required this.userType, required this.toggleAuth});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isFormValid = ValueNotifier<bool>(false);

  bool loading = false;

// text field state
  Timestamp birthDate = Timestamp.now();
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  String phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : PhysicalModel(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.rectangle,
            elevation: 70,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              floatingActionButton: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.yellow[700],
                      radius: 30,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Get.isDarkMode ? Colors.black : Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.yellow[700],
                      radius: 25,
                      child: IconButton(
                        icon: Icon(Icons.app_registration_rounded, color: Get.isDarkMode ? Colors.black : Colors.white),
                        onPressed: () => widget.toggleAuth(),
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _isFormValid,
                      builder: (context, isValid, child) {
                        return AnimatedScale(
                          duration: const Duration(milliseconds: 250),
                          scale: isValid ? 1 : 0,
                          curve: Curves.easeInOutQuart,
                          child: CircleAvatar(
                            backgroundColor: Colors.yellow[900],
                            radius: 30,
                            child: IconButton(
                              icon: Icon(Icons.check_rounded, color: Get.isDarkMode ? Colors.black : Colors.white),
                              onPressed: () {},
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  onChanged: () => _isFormValid.value = _formKey.currentState!.validate(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 40),
                            Text('REGISTER', style: Theme.of(context).textTheme.headline3),
                            SizedBox(height: 20),
                            Text('Welcome ${widget.userType.stringify()}!', style: Theme.of(context).textTheme.headline4),
                            Spacer(flex: 1),
                            Padding(padding: const EdgeInsets.only(right: 15), child: Text('First Name', style: Theme.of(context).textTheme.headline5)),
                            SizedBox(height: 5),
                            TextFormField(
                              style: Theme.of(context).textTheme.headline5,
                              cursorColor: Colors.yellow[900],
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: textInputDecoration,
                              validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
                            ),
                            SizedBox(height: 15),
                            Padding(padding: const EdgeInsets.only(right: 15), child: Text('Last Name', style: Theme.of(context).textTheme.headline5)),
                            SizedBox(height: 5),
                            TextFormField(
                              style: Theme.of(context).textTheme.headline5,
                              cursorColor: Colors.yellow[900],
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: textInputDecoration,
                              validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
                            ),
                            SizedBox(height: 15),
                            Padding(padding: const EdgeInsets.only(right: 15), child: Text('Phone Number', style: Theme.of(context).textTheme.headline5)),
                            SizedBox(height: 5),
                            TextFormField(
                              style: Theme.of(context).textTheme.headline5,
                              cursorColor: Colors.yellow[900],
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: textInputDecoration,
                              inputFormatters: [],
                              validator: FormBuilderValidators.compose([FormBuilderValidators.match(context, '^(1-)?\d{3}-\d{3}-\d{4}\$')]),
                            ),
                            Divider(height: 40, thickness: 2, indent: 100, endIndent: 100),
                            Padding(padding: const EdgeInsets.only(right: 15), child: Text('Email', style: Theme.of(context).textTheme.headline5)),
                            SizedBox(height: 5),
                            TextFormField(
                              style: Theme.of(context).textTheme.headline5,
                              cursorColor: Colors.yellow[900],
                              obscureText: false,
                              enableSuggestions: true,
                              autocorrect: true,
                              decoration: textInputDecoration,
                              validator: FormBuilderValidators.compose([FormBuilderValidators.email(context), FormBuilderValidators.required(context)]),
                            ),
                            SizedBox(height: 25),
                            Padding(padding: const EdgeInsets.only(right: 15), child: Text('Password', style: Theme.of(context).textTheme.headline5)),
                            SizedBox(height: 5),
                            TextFormField(
                              style: Theme.of(context).textTheme.headline5,
                              cursorColor: Colors.yellow[900],
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: textInputDecoration,
                              validator: FormBuilderValidators.compose([FormBuilderValidators.minLength(context, 6)]),
                            ),
                            Divider(height: 40, thickness: 2, indent: 100, endIndent: 100),
                            Padding(padding: const EdgeInsets.only(right: 15), child: Text('Activation Code', style: Theme.of(context).textTheme.headline5)),
                            SizedBox(height: 5),
                            TextFormField(
                              style: Theme.of(context).textTheme.headline5,
                              cursorColor: Colors.yellow[900],
                              obscureText: false,
                              enableSuggestions: true,
                              autocorrect: true,
                              decoration: textInputDecoration,
                              validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
                            ),
                            Spacer(flex: 2),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
