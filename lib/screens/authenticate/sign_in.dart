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
    return loading
        ? Loading()
        : LayoutBuilder(builder: (context, constraints) {
            return Scaffold(
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
                  child: Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 75.0, bottom: 50.0, left: 50.0, right: 50.0),
                          child: AspectRatio(
                            aspectRatio:
                                MediaQuery.of(context).devicePixelRatio,
                            child: Image(
                              image: AssetImage(
                                "assets/images/${Shared.lightThemeEnabled ? "Dark_" : ""}Follow_Up_logo-01.png",
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 25.0, horizontal: 40.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50.0),
                                topRight: Radius.circular(50.0),
                              ),
                              color: Theme.of(context).backgroundColor,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                // email field
                                FormBuilderTextField(
                                  name: 'Account Email',
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'Account Email'),
                                  keyboardType: TextInputType.text,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(context),
                                    FormBuilderValidators.email(context),
                                  ]),
                                  onChanged: (val) {
                                    setState(() => email = val as String);
                                  },
                                ),

                                // password field
                                FormBuilderTextField(
                                  name: 'Password',
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'Password'),
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(context),
                                    FormBuilderValidators.maxLength(
                                        context, 20),
                                    FormBuilderValidators.minLength(
                                        context, 5),
                                  ]),
                                  onChanged: (val) {
                                    setState(
                                        () => password = val as String);
                                  },
                                ),

                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40.0,
                                  child: ElevatedButton(
                                      child: Text('Sign In',
                                          style: TextStyle(
                                              color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        primary: Theme.of(context)
                                            .secondaryHeaderColor,
                                      ),
                                      onPressed: () async {
                                        setState(() => loading = true);
                                        dynamic result = await AuthService
                                            .signInWithEmailAndPassword(
                                                email, password);
                                        if (result == null)
                                          setState(() {
                                            error =
                                                'There was an error using these credential please retry';
                                            loading = false;
                                          });
                                      }),
                                ),

                                Text('OR SIGN IN WITH'),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    GoogleSignInButton(onPressed: () async {
                                      await AuthService.signInWithGoogle();
                                    }),
                                    FacebookSignInButton(onPressed: () async {
                                      await AuthService.signInWithFacebook();
                                    }),
                                    TwitterSignInButton(onPressed: () async {}),
                                    AppleSignInButton(
                                        onPressed: () async {},
                                        darkMode: !Shared.lightThemeEnabled),
                                  ],
                                ),

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
              ),
            );
          });
  }
}
