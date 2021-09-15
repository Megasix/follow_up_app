import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/shared/style_constants.dart';
import 'package:follow_up_app/shared/features/apple.dart';
import 'package:follow_up_app/shared/features/facebook.dart';
import 'package:follow_up_app/shared/features/google.dart';
import 'package:follow_up_app/shared/features/twitter.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:follow_up_app/shared/shared.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormBuilderState>();
  final PageController _pageController = PageController(initialPage: 0);

// text field state
  Timestamp birthDate = Timestamp.now();
  String country = '';
  String firstName = '';
  String lastName = '';
  String email = '';
  String phoneNumber = '';
  String password = '';
  String error = '';

  bool loading = false;
  Alignment childAlignement = Alignment.center;

  @override
  Widget build(BuildContext context) {
    const _referenceHeight = 820.5714285714286;
    const _referenceWidth = 411.42857142857144;
    final double contextHeight = MediaQuery.of(context).size.height;
    final double contextWidth = MediaQuery.of(context).size.width;
    final double contextAspectRatio = MediaQuery.of(context).devicePixelRatio;
    var sameTypeVerticalPadding = 10.0 * contextHeight / _referenceHeight;
    var generalVerticalPadding = 20.0 * contextHeight / _referenceHeight;
    var heightRatio = contextHeight / _referenceHeight;
    var widthRatio = contextWidth / _referenceWidth;

    final countriesOptions = ['Canada', 'France'];
    final int firstDate = DateTime.now().year - 80, lastDate = DateTime.now().year - 15;

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
                    Padding(
                      padding: EdgeInsets.only(top: 40.0 * heightRatio, bottom: 30.0 * heightRatio, left: 20.0 * widthRatio, right: 20.0 * widthRatio),
                      child: AspectRatio(
                        aspectRatio: contextAspectRatio,
                        child: Image(
                          image: AssetImage(
                            "assets/images/${Shared.lightThemeEnabled ? "Dark_" : ""}Follow_Up_logo-01.png",
                          ),
                        ),
                      ),
                    ),
                    // email field
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 40.0 * heightRatio),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0),
                          ),
                          color: Theme.of(context).backgroundColor,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: PageView(
                                controller: _pageController,
                                //physics: NeverScrollableScrollPhysics(),
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 40.0 * widthRatio, top: 40.0 * heightRatio, right: 40.0 * widthRatio),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Get Started',
                                          textScaleFactor: 2.5,
                                        ),
                                        SizedBox(height: sameTypeVerticalPadding),
                                        Text(
                                          'Lets verify some information about you to help set up your account.',
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: generalVerticalPadding),
                                        FormBuilderDropdown(
                                          name: 'Country',
                                          decoration: textInputDecoration.copyWith(hintText: 'Country'),
                                          allowClear: true,
                                          validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
                                          items: countriesOptions
                                              .map((country) => DropdownMenuItem(
                                                    value: country,
                                                    child: Text('$country'),
                                                  ))
                                              .toList(),
                                          onChanged: (String? val) {
                                            setState(() => country = val as String);
                                          },
                                        ),
                                        SizedBox(height: sameTypeVerticalPadding),
                                        FormBuilderDateTimePicker(
                                          name: 'Date of Birth',
                                          cursorColor: Theme.of(context).buttonColor,
                                          firstDate: DateTime(firstDate),
                                          lastDate: DateTime(lastDate),
                                          initialDate: DateTime(lastDate),
                                          inputType: InputType.date,
                                          decoration: textInputDecoration.copyWith(hintText: 'Date of Birth'),
                                          validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
                                          onChanged: (val) {
                                            setState(() => birthDate = Timestamp.fromDate(val as DateTime));
                                          },
                                        ),
                                        SizedBox(height: 50.0 * heightRatio),
                                        SizedBox(
                                          width: contextWidth,
                                          height: 40.0,
                                          child: ElevatedButton(
                                              child: Text('Continue', style: TextStyle(color: Colors.white)),
                                              onPressed: () async {
                                                if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                                                  _pageController.animateToPage(1, duration: Duration(milliseconds: 400), curve: Curves.ease);
                                                }
                                              }),
                                        ),
                                        SizedBox(height: generalVerticalPadding),
                                        Text('OR SIGN UP WITH'),
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
                                            AppleSignInButton(onPressed: () async {}, darkMode: Shared.lightThemeEnabled),
                                          ],
                                        ),
                                        SizedBox(height: generalVerticalPadding),
                                        TextButton(
                                          child: Text('Already have an account ? Login'),
                                          onPressed: () {
                                            widget.toggleView();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 40.0 * widthRatio, top: 40.0 * heightRatio, right: 40.0 * widthRatio),
                                    child: Column(
                                      children: [
                                        Text(
                                          "What's Your Name ?",
                                          textScaleFactor: 2.5,
                                        ),
                                        SizedBox(height: sameTypeVerticalPadding),
                                        Text(
                                          'Your real name may be used later to verify your identity when contacting your driving school.',
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: generalVerticalPadding),
                                        FormBuilderTextField(
                                          name: 'First Name',
                                          decoration: textInputDecoration.copyWith(hintText: 'First Name'),
                                          keyboardType: TextInputType.text,
                                          validator: FormBuilderValidators.compose([
                                            FormBuilderValidators.required(context),
                                            FormBuilderValidators.maxLength(context, 20),
                                            FormBuilderValidators.minLength(context, 2),
                                          ]),
                                          onChanged: (val) {
                                            setState(() => firstName = val as String);
                                          },
                                        ),
                                        SizedBox(height: sameTypeVerticalPadding),
                                        FormBuilderTextField(
                                          name: 'Last Name',
                                          decoration: textInputDecoration.copyWith(hintText: 'Last Name'),
                                          keyboardType: TextInputType.text,
                                          validator: FormBuilderValidators.compose([
                                            FormBuilderValidators.required(context),
                                            FormBuilderValidators.maxLength(context, 20),
                                            FormBuilderValidators.minLength(context, 2),
                                          ]),
                                          onChanged: (val) {
                                            setState(() => lastName = val as String);
                                          },
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          width: contextWidth,
                                          height: 40.0,
                                          child: ElevatedButton(
                                              child: Text('Continue', style: TextStyle(color: Colors.white)),
                                              onPressed: () async {
                                                if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                                                  _pageController.animateToPage(2, duration: Duration(milliseconds: 400), curve: Curves.ease);
                                                }
                                              }),
                                        ),
                                        SizedBox(height: sameTypeVerticalPadding),
                                        TextButton(
                                          child: Text('Go Back'),
                                          onPressed: () {
                                            _pageController.animateToPage(0, duration: Duration(milliseconds: 400), curve: Curves.ease);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 40.0 * widthRatio, top: 40.0 * heightRatio, right: 40.0 * widthRatio),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Identify Your Account',
                                          textAlign: TextAlign.center,
                                          textScaleFactor: 2.5,
                                        ),
                                        SizedBox(height: sameTypeVerticalPadding),
                                        Text(
                                          'This is what you will use when you log in to Follow Up app.',
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: generalVerticalPadding),
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
                                        FormBuilderTextField(
                                          name: 'Phone Number',
                                          decoration: textInputDecoration.copyWith(hintText: '(Optional) Phone Number'),
                                          keyboardType: TextInputType.text,
                                          validator: FormBuilderValidators.compose([
                                            FormBuilderValidators.numeric(context),
                                            FormBuilderValidators.maxLength(context, 10),
                                          ]),
                                          onChanged: (val) {
                                            setState(() => phoneNumber = val as String);
                                          },
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          width: contextWidth,
                                          height: 40.0,
                                          child: ElevatedButton(
                                              child: Text('Continue', style: TextStyle(color: Colors.white)),
                                              onPressed: () async {
                                                if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                                                  _pageController.animateToPage(3, duration: Duration(milliseconds: 400), curve: Curves.ease);
                                                }
                                              }),
                                        ),
                                        SizedBox(height: sameTypeVerticalPadding),
                                        TextButton(
                                          child: Text('Go Back'),
                                          onPressed: () {
                                            _pageController.animateToPage(1, duration: Duration(milliseconds: 400), curve: Curves.ease);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 40.0 * widthRatio, top: 40.0 * heightRatio, right: 40.0 * widthRatio),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Review Terms',
                                          textAlign: TextAlign.center,
                                          textScaleFactor: 2.5,
                                        ),
                                        SizedBox(height: sameTypeVerticalPadding),
                                        Text(
                                          'Please review the terms below.',
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: generalVerticalPadding),
                                        FormBuilderCheckbox(
                                          name: 'Terms and Conditions',
                                          initialValue: false,
                                          title: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(text: 'I have read and agree to the ', style: TextStyle(color: Theme.of(context).accentColor)),
                                                TextSpan(
                                                    text: 'Terms and Conditions',
                                                    style: TextStyle(color: Colors.blue),
                                                    recognizer: TapGestureRecognizer()
                                                      ..onTap = () async {
                                                        final url = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';
                                                        if (await canLaunch(url)) {
                                                          await launch(
                                                            url,
                                                            forceSafariVC: false,
                                                          );
                                                        }
                                                      }),
                                              ],
                                            ),
                                          ),
                                          validator: FormBuilderValidators.equal(context, true, errorText: 'You must accept terms and conditions to continue'),
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          width: contextWidth,
                                          height: 40.0,
                                          child: ElevatedButton(
                                              child: Text('Continue', style: TextStyle(color: Colors.white)),
                                              onPressed: () async {
                                                if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                                                  _pageController.animateToPage(4, duration: Duration(milliseconds: 400), curve: Curves.ease);
                                                }
                                              }),
                                        ),
                                        SizedBox(height: sameTypeVerticalPadding),
                                        TextButton(
                                          child: Text('Go Back'),
                                          onPressed: () {
                                            _pageController.animateToPage(2, duration: Duration(milliseconds: 400), curve: Curves.ease);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 40.0 * widthRatio, top: 40.0 * heightRatio, right: 40.0 * widthRatio),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Set Your Password',
                                          textAlign: TextAlign.center,
                                          textScaleFactor: 2.5,
                                        ),
                                        SizedBox(height: sameTypeVerticalPadding),
                                        Text(
                                          'Secure your account and choose a strong password.',
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: generalVerticalPadding),
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
                                        Spacer(),
                                        SizedBox(
                                          width: contextWidth,
                                          height: 40.0,
                                          child: ElevatedButton(
                                              child: Text('Register', style: TextStyle(color: Colors.white)),
                                              onPressed: () async {
                                                if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                                                  setState(() => loading = true);
                                                  dynamic result = await AuthService.registerWithEmailAndPassword(
                                                      firstName, lastName, country, email, phoneNumber, birthDate, password);
                                                  if (result == null)
                                                    setState(() {
                                                      error = 'There was an error using these credential please retry';
                                                      loading = false;
                                                    });
                                                }
                                              }),
                                        ),
                                        SizedBox(height: sameTypeVerticalPadding),
                                        TextButton(
                                          child: Text('Go Back'),
                                          onPressed: () {
                                            _pageController.animateToPage(3, duration: Duration(milliseconds: 400), curve: Curves.ease);
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: generalVerticalPadding),
                            SmoothPageIndicator(
                              controller: _pageController,
                              count: 5,
                              effect: ExpandingDotsEffect(
                                activeDotColor: Theme.of(context).buttonColor,
                                dotWidth: 10.0,
                                dotHeight: 10.0,
                              ),
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
