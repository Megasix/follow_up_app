import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:follow_up_app/main.dart';
import 'package:follow_up_app/shared/features/twitter.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/shared/constants.dart';
import 'package:follow_up_app/shared/features/apple.dart';
import 'package:follow_up_app/shared/features/google.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:follow_up_app/shared/features/facebook.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  bool loading = false;
  Alignment childAlignement = Alignment.center;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  _SignInState() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          childAlignement = visible ? Alignment.topCenter : Alignment.center;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //default gap between two elements
    const sameTypePadding = 10.0;
    const generalPadding = 20.0;
    final double contextWidth = MediaQuery.of(context).size.width;

    bool lightThemeEnabled = getTheme();

    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeOut,
              alignment: childAlignement,
              color: Theme.of(context).secondaryHeaderColor,
              width: double.infinity,
              height: double.infinity,
              child: FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 75),
                    Image(
                      image: AssetImage(
                        "assets/images/${lightThemeEnabled ? "Dark_" : ""}Follow_Up_logo-01.png",
                      ),
                      height: 200.0,
                      width: 200.0,
                    ),
                    SizedBox(height: 50),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(40.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0),
                          ),
                          color: Theme.of(context).backgroundColor,
                        ),
                        child: Column(
                          children: <Widget>[
                            FormBuilderTextField(
                              name: 'Account Email',
                              decoration: textInputDecoration.copyWith(hintText: (AppLocalizations.of(context).email)),
                              keyboardType: TextInputType.text,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                                FormBuilderValidators.email(context),
                              ]),
                              onChanged: (val) {
                                setState(() => email = val);
                              },
                            ),
                            SizedBox(height: sameTypePadding),
                            // password field
                            FormBuilderTextField(
                              name: 'Password',
                              decoration: textInputDecoration.copyWith(hintText: (AppLocalizations.of(context).password)),
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                                FormBuilderValidators.maxLength(context, 20),
                                FormBuilderValidators.minLength(context, 5),
                              ]),
                              onChanged: (val) {
                                setState(() => password = val);
                              },
                            ),
                            SizedBox(height: generalPadding),

                            SizedBox(
                              width: contextWidth,
                              height: 40.0,
                              child: RaisedButton(
                                  child: Text((AppLocalizations.of(context).logIn)),
                                  onPressed: () async {
                                    setState(() => loading = true);
                                    dynamic result = await _authService.signInWithEmailAndPassword(email, password);
                                    if (result == null)
                                      setState(() {
                                        Text((AppLocalizations.of(context).error));
                                        loading = false;
                                      });
                                  }),
                            ),

                            SizedBox(height: generalPadding),

                            Text((AppLocalizations.of(context).signOther)),

                            SizedBox(height: generalPadding),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GoogleSignInButton(onPressed: () async {
                                  await _authService.signInWithGoogle();
                                }),
                                SizedBox(width: sameTypePadding),
                                FacebookSignInButton(onPressed: () async {
                                  await _authService.signInWithFacebook();
                                }),
                                SizedBox(width: sameTypePadding),
                                TwitterSignInButton(onPressed: () async {}),
                                SizedBox(width: sameTypePadding),
                                AppleSignInButton(onPressed: () async {}, darkMode: !lightThemeEnabled),
                              ],
                            ),

                            SizedBox(height: generalPadding),

                            FlatButton(
                              child: Text((AppLocalizations.of(context).createACC)),
                              onPressed: () {
                                widget.toggleView();
                              },
                            ),

                            SizedBox(height: 8.0),
                            Text(
                              error,
                              style: TextStyle(color: Colors.red, fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
