import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:follow_up_app/shared/constants.dart';
import 'package:follow_up_app/shared/features/apple.dart';
import 'package:follow_up_app/shared/features/facebook.dart';
import 'package:follow_up_app/shared/features/google.dart';
import 'package:follow_up_app/shared/features/twitter.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final DatabaseService _databaseService = DatabaseService();
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormBuilderState>();
  final PageController _pageController = PageController(initialPage: 0);

// text field state
  DateTime dateTime;
  String country;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String password = '';
  String error = '';

  bool loading = false;
  Alignment childAlignement = Alignment.center;

  @override
  _RegisterState() {
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
    const sameTypePadding = 10.0;
    const generalPadding = 20.0;
    final countriesOptions = ['Canada', 'France'];
    final double screenWidth = MediaQuery.of(context).size.width;
    final int firstDate = DateTime.now().year - 80,
        lastDate = DateTime.now().year - 15;

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
                  children: <Widget>[
                    SizedBox(height: 100),

                    Text('FOLLOW UP LOGO'),

                    SizedBox(height: 75),
                    // email field
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 40.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0),
                          ),
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: PageView(
                                controller: _pageController,
                                //physics: NeverScrollableScrollPhysics(),
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 40.0, top: 40.0, right: 40.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Get Started',
                                          textScaleFactor: 2.5,
                                        ),
                                        SizedBox(height: sameTypePadding),
                                        Text(
                                          'Lets verify some information about you to help set up your account.',
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: generalPadding),
                                        FormBuilderDropdown(
                                          name: 'Country',
                                          decoration: textInputDecoration
                                              .copyWith(hintText: 'Country'),
                                          allowClear: true,
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                                context)
                                          ]),
                                          items: countriesOptions
                                              .map(
                                                  (country) => DropdownMenuItem(
                                                        value: country,
                                                        child: Text('$country'),
                                                      ))
                                              .toList(),
                                          onChanged: (val) {
                                            setState(() => country = val);
                                          },
                                        ),
                                        SizedBox(height: sameTypePadding),
                                        FormBuilderDateTimePicker(
                                          name: 'Date of Birth',
                                          cursorColor:
                                              Theme.of(context).buttonColor,
                                          firstDate: DateTime(firstDate),
                                          lastDate: DateTime(lastDate),
                                          initialDate: DateTime(lastDate),
                                          inputType: InputType.date,
                                          decoration:
                                              textInputDecoration.copyWith(
                                                  hintText: 'Date of Birth'),
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                                context)
                                          ]),
                                          onChanged: (val) {
                                            setState(() => dateTime = val);
                                          },
                                        ),
                                        SizedBox(height: 50.0),
                                        SizedBox(
                                          width: screenWidth,
                                          height: 40.0,
                                          child: RaisedButton(
                                              child: Text('Continue',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              onPressed: () async {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  _pageController.animateToPage(
                                                      1,
                                                      duration: Duration(
                                                          milliseconds: 400),
                                                      curve: Curves.ease);
                                                }
                                              }),
                                        ),
                                        SizedBox(height: generalPadding),
                                        Text('OR SIGN UP WITH'),
                                        SizedBox(height: generalPadding),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            GoogleSignInButton(
                                                onPressed: () async {
                                              await _authService
                                                  .signInWithGoogle();
                                            }),
                                            SizedBox(width: sameTypePadding),
                                            FacebookSignInButton(
                                                onPressed: () async {
                                              await _authService
                                                  .signInWithFacebook();
                                            }),
                                            SizedBox(width: sameTypePadding),
                                            TwitterSignInButton(
                                                onPressed: () async {}),
                                            SizedBox(width: sameTypePadding),
                                            AppleSignInButton(
                                                onPressed: () async {},
                                                darkMode: !lightThemeEnabled),
                                          ],
                                        ),
                                        SizedBox(height: generalPadding),
                                        FlatButton(
                                          child: Text(
                                              'Already have an account ? Login'),
                                          onPressed: () {
                                            widget.toggleView();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 40.0, top: 40.0, right: 40.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          "What's Your Name ?",
                                          textScaleFactor: 2.5,
                                        ),
                                        SizedBox(height: sameTypePadding),
                                        Text(
                                          'Your real name may be used later to verify your identity when contacting your driving school.',
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: generalPadding),
                                        FormBuilderTextField(
                                          name: 'First Name',
                                          decoration: textInputDecoration
                                              .copyWith(hintText: 'First Name'),
                                          keyboardType: TextInputType.text,
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                                context),
                                            FormBuilderValidators.maxLength(
                                                context, 20),
                                            FormBuilderValidators.minLength(
                                                context, 2),
                                          ]),
                                          onChanged: (val) {
                                            setState(() => firstName = val);
                                          },
                                        ),
                                        SizedBox(height: sameTypePadding),
                                        FormBuilderTextField(
                                          name: 'Last Name',
                                          decoration: textInputDecoration
                                              .copyWith(hintText: 'Last Name'),
                                          keyboardType: TextInputType.text,
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                                context),
                                            FormBuilderValidators.maxLength(
                                                context, 20),
                                            FormBuilderValidators.minLength(
                                                context, 2),
                                          ]),
                                          onChanged: (val) {
                                            setState(() => lastName = val);
                                          },
                                        ),
                                        SizedBox(height: 150.0),
                                        SizedBox(
                                          width: screenWidth,
                                          height: 40.0,
                                          child: RaisedButton(
                                              child: Text('Continue',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              onPressed: () async {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  _pageController.animateToPage(
                                                      2,
                                                      duration: Duration(
                                                          milliseconds: 400),
                                                      curve: Curves.ease);
                                                }
                                              }),
                                        ),
                                        SizedBox(height: sameTypePadding),
                                        FlatButton(
                                          child: Text('Go Back'),
                                          onPressed: () {
                                            _pageController.animateToPage(0,
                                                duration:
                                                    Duration(milliseconds: 400),
                                                curve: Curves.ease);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 40.0, top: 40.0, right: 40.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Identify Your Account',
                                          textAlign: TextAlign.center,
                                          textScaleFactor: 2.5,
                                        ),
                                        SizedBox(height: sameTypePadding),
                                        Text(
                                          'This is what you will use when you log in to Follow Up app.',
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: generalPadding),
                                        FormBuilderTextField(
                                          name: 'Account Email',
                                          decoration:
                                              textInputDecoration.copyWith(
                                                  hintText: 'Account Email'),
                                          keyboardType: TextInputType.text,
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                                context),
                                            FormBuilderValidators.email(
                                                context),
                                          ]),
                                          onChanged: (val) {
                                            setState(() => email = val);
                                          },
                                        ),
                                        SizedBox(height: sameTypePadding),
                                        FormBuilderTextField(
                                          name: 'Phone Number',
                                          decoration:
                                              textInputDecoration.copyWith(
                                                  hintText:
                                                      '(Optional) Phone Number'),
                                          keyboardType: TextInputType.text,
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.numeric(
                                                context),
                                            FormBuilderValidators.maxLength(
                                                context, 10),
                                          ]),
                                          onChanged: (val) {
                                            setState(() => phoneNumber = val);
                                          },
                                        ),
                                        SizedBox(height: 110.0),
                                        SizedBox(
                                          width: screenWidth,
                                          height: 40.0,
                                          child: RaisedButton(
                                              child: Text('Continue',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              onPressed: () async {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  _pageController.animateToPage(
                                                      3,
                                                      duration: Duration(
                                                          milliseconds: 400),
                                                      curve: Curves.ease);
                                                }
                                              }),
                                        ),
                                        SizedBox(height: sameTypePadding),
                                        FlatButton(
                                          child: Text('Go Back'),
                                          onPressed: () {
                                            _pageController.animateToPage(1,
                                                duration:
                                                    Duration(milliseconds: 400),
                                                curve: Curves.ease);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 40.0, top: 40.0, right: 40.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Review Terms',
                                          textAlign: TextAlign.center,
                                          textScaleFactor: 2.5,
                                        ),
                                        SizedBox(height: sameTypePadding),
                                        Text(
                                          'Please review the terms below.',
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: generalPadding),
                                        FormBuilderCheckbox(
                                          name: 'Terms and Conditions',
                                          initialValue: false,
                                          title: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                    text:
                                                        'I have read and agree to the ',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .accentColor)),
                                                TextSpan(
                                                    text:
                                                        'Terms and Conditions',
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () async {
                                                            final url =
                                                                'https://www.youtube.com/watch?v=dQw4w9WgXcQ';
                                                            if (await canLaunch(
                                                                url)) {
                                                              await launch(
                                                                url,
                                                                forceSafariVC:
                                                                    false,
                                                              );
                                                            }
                                                          }),
                                              ],
                                            ),
                                          ),
                                          validator: FormBuilderValidators.equal(
                                              context, true,
                                              errorText:
                                                  'You must accept terms and conditions to continue'),
                                        ),
                                        SizedBox(height: 202.0),
                                        SizedBox(
                                          width: screenWidth,
                                          height: 40.0,
                                          child: RaisedButton(
                                              child: Text('Continue',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              onPressed: () async {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  _pageController.animateToPage(
                                                      4,
                                                      duration: Duration(
                                                          milliseconds: 400),
                                                      curve: Curves.ease);
                                                }
                                              }),
                                        ),
                                        SizedBox(height: sameTypePadding),
                                        FlatButton(
                                          child: Text('Go Back'),
                                          onPressed: () {
                                            _pageController.animateToPage(2,
                                                duration:
                                                    Duration(milliseconds: 400),
                                                curve: Curves.ease);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 40.0, top: 40.0, right: 40.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Set Your Password',
                                          textAlign: TextAlign.center,
                                          textScaleFactor: 2.5,
                                        ),
                                        SizedBox(height: sameTypePadding),
                                        Text(
                                          'Secure your account and choose a strong password.',
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: generalPadding),
                                        FormBuilderTextField(
                                          name: 'Password',
                                          decoration: textInputDecoration
                                              .copyWith(hintText: 'Password'),
                                          obscureText: true,
                                          keyboardType: TextInputType.text,
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.required(
                                                context),
                                            FormBuilderValidators.maxLength(
                                                context, 20),
                                            FormBuilderValidators.minLength(
                                                context, 6),
                                          ]),
                                          onChanged: (val) {
                                            setState(() => password = val);
                                          },
                                        ),
                                        SizedBox(height: 225.0),
                                        SizedBox(
                                          width: screenWidth,
                                          height: 40.0,
                                          child: RaisedButton(
                                              child: Text('Register',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              onPressed: () async {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  setState(
                                                      () => loading = true);
                                                  dynamic result =
                                                      await _authService
                                                          .registerWithEmailAndPassword(
                                                              email, password);
                                                  if (result == null)
                                                    setState(() {
                                                      error =
                                                          'There was an error using these credential please retry';
                                                      loading = false;
                                                    });
                                                  else {
                                                    _databaseService
                                                        .dataInitialisation(
                                                            dateTime,
                                                            country,
                                                            firstName,
                                                            lastName,
                                                            email,
                                                            phoneNumber);
                                                  }
                                                }
                                              }),
                                        ),
                                        SizedBox(height: sameTypePadding),
                                        FlatButton(
                                          child: Text('Go Back'),
                                          onPressed: () {
                                            _pageController.animateToPage(3,
                                                duration:
                                                    Duration(milliseconds: 400),
                                                curve: Curves.ease);
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: sameTypePadding),
                            SmoothPageIndicator(
                              controller: _pageController,
                              count: 5,
                              effect: ExpandingDotsEffect(
                                activeDotColor: Theme.of(context).buttonColor,
                                dotWidth: 10.0,
                                dotHeight: 10.0,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(error,
                                style: TextStyle(
                                    color: Colors.red, fontSize: 14.0)),
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
