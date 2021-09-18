import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:follow_up_app/main.dart';
import 'package:follow_up_app/shared/features/twitter.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/shared/style_constants.dart';
import 'package:follow_up_app/shared/features/apple.dart';
import 'package:follow_up_app/shared/features/google.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:follow_up_app/shared/features/facebook.dart';
import 'package:follow_up_app/shared/shared.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  Alignment childAlignement = Alignment.center;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    //default gap between two elements
    const _referenceHeight = 820.5714285714286;
    const _referenceWidth = 411.42857142857144;
    final double contextHeight = MediaQuery.of(context).size.height;
    final double contextWidth = MediaQuery.of(context).size.width;
    final double contextAspectRatio = MediaQuery.of(context).devicePixelRatio;
    var sameTypeVerticalPadding = 10.0 * contextHeight / _referenceHeight;
    var generalVerticalPadding = 30.0 * contextHeight / _referenceHeight;
    var heightRatio = contextHeight / _referenceHeight;
    var widthRatio = contextWidth / _referenceWidth;

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
                    SizedBox(
                      height: 350.0 * heightRatio,
                      child: Padding(
                        padding: EdgeInsets.only(top: 75.0 * heightRatio, bottom: 50.0 * heightRatio, left: 50.0 * widthRatio, right: 50.0 * widthRatio),
                        child: AspectRatio(
                          aspectRatio: contextAspectRatio,
                          child: Image(
                            image: AssetImage(
                              "assets/images/${Shared.lightThemeEnabled ? "Dark_" : ""}Follow_Up_logo-01.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 40.0 * heightRatio, right: 40.0 * widthRatio, left: 40.0 * widthRatio),
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
                              decoration: textInputDecoration.copyWith(hintText: 'Account Email'),
                              keyboardType: TextInputType.text,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                                FormBuilderValidators.email(context),
                              ]),
                              onChanged: (val) {
                                setState(() => email = val as String);
                              },
                            ),
                            SizedBox(height: sameTypeVerticalPadding),
                            // password field
                            FormBuilderTextField(
                              name: 'Password',
                              decoration: textInputDecoration.copyWith(hintText: 'Password'),
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                                FormBuilderValidators.maxLength(context, 20),
                                FormBuilderValidators.minLength(context, 5),
                              ]),
                              onChanged: (val) {
                                setState(() => password = val as String);
                              },
                            ),
                            SizedBox(height: generalVerticalPadding),

                            SizedBox(
                              width: contextWidth,
                              height: 40.0,
                              child: ElevatedButton(
                                  child: Text('Sign In', style: TextStyle(color: Colors.white)),
                                  onPressed: () async {
                                    setState(() => loading = true);
                                    dynamic result = await AuthService.signInWithEmailAndPassword(email, password);
                                    if (result == null)
                                      setState(() {
                                        error = 'There was an error using these credential please retry';
                                        loading = false;
                                      });
                                  }),
                            ),

                            SizedBox(height: generalVerticalPadding),

                            Text('OR SIGN IN WITH'),

                            SizedBox(height: generalVerticalPadding),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GoogleSignInButton(onPressed: () async {
                                  await AuthService.signInWithGoogle();
                                }),
                                SizedBox(width: sameTypeVerticalPadding),
                                FacebookSignInButton(onPressed: () async {
                                  await AuthService.signInWithFacebook();
                                }),
                                SizedBox(width: sameTypeVerticalPadding),
                                TwitterSignInButton(onPressed: () async {}),
                                SizedBox(width: sameTypeVerticalPadding),
                                AppleSignInButton(onPressed: () async {}, darkMode: !Shared.lightThemeEnabled),
                              ],
                            ),

                            SizedBox(height: generalVerticalPadding),

                            TextButton(
                              child: Text('CREATE A FREE ACCOUNT'),
                              onPressed: () {
                                widget.toggleView();
                              },
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
