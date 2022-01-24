import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:follow_up_app/models/enums.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/shared/features/facebook.dart';
import 'package:follow_up_app/shared/features/google.dart';
import 'package:follow_up_app/shared/style_constants.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

//TODO: refocus correct text fields when submitted
//TODO: keep keyboard afloat when submitting through the keyboard
class Register extends StatefulWidget {
  final Function toggleAuth;

  Register({required this.toggleAuth});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  static const double H_PADDING = 15.0;
  static const double INITIAL_H_SPACE = 40;
  static const double INDICATOR_SPACE = 90;
  static const double FIELD_SPACE = 10;
  static const int PAGE_COUNT = 3;

  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<NextButtonState> _nextButtState = ValueNotifier<NextButtonState>(NextButtonState.NEXT);
  final PageController _pageController = PageController(viewportFraction: 1.2, initialPage: 0);

  bool _loading = false;

// text field state
  Timestamp birthDate = Timestamp.now();
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  String schoolCode = '';
  String activationCode = '';

  void _setButtonState(int page) {
    print(page);
    _nextButtState.value = page == PAGE_COUNT - 1 ? NextButtonState.DONE : NextButtonState.NEXT;
  }

  void _submitForm() async {
    if (_pageController.page != PAGE_COUNT - 1) {
      final int pageNumb = _pageController.page!.floor() + 1;
      _pageController.animateToPage(pageNumb, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
      _setButtonState(pageNumb);
    } else {
      setState(() => _loading = true);

      if (!await AuthService.registerWithEmailAndPassword(context, email, password)) {
        setState(() => _loading = false);
      }
    }
  }

  void _socialRegister(SignInType signInType) async {
    setState(() => _loading = true);
    bool isSuccess = false;
    switch (signInType) {
      case SignInType.FACEBOOK:
        isSuccess = await AuthService.signInWithFacebook(context);
        break;
      case SignInType.GOOGLE:
        isSuccess = await AuthService.signInWithGoogle(context);
        break;
      default:
    }

    //there has been an error and we haven't been able to register, go back to the register page
    if (!isSuccess) setState(() => _loading = false);
  }

  void _goBack() {
    if (_pageController.page != 0) {
      final int pageNumb = _pageController.page!.floor() - 1;
      _pageController.animateToPage(pageNumb, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
      _setButtonState(pageNumb);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _pageWidthFactor = 1 / _pageController.viewportFraction;
    return _loading
        ? Loading()
        : Scaffold(
            backgroundColor: Get.theme.backgroundColor,
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
                      icon: Icon(Icons.arrow_back_rounded, color: Get.isDarkMode ? Colors.black : Colors.white),
                      onPressed: () => _goBack(),
                    ),
                  ),
                  ValueListenableBuilder<NextButtonState>(
                    valueListenable: _nextButtState,
                    builder: (context, state, child) => CircleAvatar(
                      backgroundColor: Colors.yellow[900],
                      radius: 30,
                      child: IconButton(
                        icon: Stack(
                          children: [
                            AnimatedScale(
                                duration: const Duration(milliseconds: 100),
                                scale: state == NextButtonState.DONE ? 1.0 : 0.0,
                                child: Icon(Icons.check_rounded, color: Get.isDarkMode ? Colors.black : Colors.white)),
                            AnimatedScale(
                              duration: const Duration(milliseconds: 100),
                              scale: state == NextButtonState.DONE ? 0.0 : 1.0,
                              child: Transform.rotate(angle: pi, child: Icon(Icons.arrow_back_rounded, color: Get.isDarkMode ? Colors.black : Colors.white)),
                            )
                          ],
                        ),
                        onPressed: () => _submitForm(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: SizedBox(
                height: Get.height,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: H_PADDING),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: PageView.custom(
                            physics: NeverScrollableScrollPhysics(),
                            controller: _pageController,
                            childrenDelegate: SliverChildListDelegate.fixed(
                              [
                                _buildInfo(_pageWidthFactor),
                                _buildPersonalForm(_pageWidthFactor),
                                _buildCredentialsForm(_pageWidthFactor),
                                //_buildSchoolForm(_pageWidthFactor),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: INDICATOR_SPACE),
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: PAGE_COUNT,
                          effect: WormEffect(
                            activeDotColor: Colors.yellow[700]!,
                            dotColor: Colors.grey[300]!,
                            dotHeight: 10,
                            dotWidth: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildInfo(double _pageWidthFactor) {
    return FractionallySizedBox(
      widthFactor: _pageWidthFactor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: INITIAL_H_SPACE),
          Text('REGISTER', style: Get.textTheme.headline3),
          SizedBox(height: INITIAL_H_SPACE / 2),
          Text('Welcome!', style: Get.textTheme.headline4),
          Spacer(),
          FacebookSignInButton(
            onPressed: () => _socialRegister(SignInType.FACEBOOK),
          ),
          SizedBox(height: FIELD_SPACE),
          GoogleSignInButton(
            onPressed: () => _socialRegister(SignInType.GOOGLE),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalForm(double _pageWidthFactor) {
    return FractionallySizedBox(
      widthFactor: _pageWidthFactor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: INITIAL_H_SPACE),
          Text('First things first...', style: Get.textTheme.headline4),
          Spacer(),
          Padding(padding: const EdgeInsets.only(right: 15), child: Text('First Name', style: Get.textTheme.headline5)),
          TextFormField(
            style: Get.textTheme.bodyText1,
            cursorColor: Colors.yellow[900],
            obscureText: false,
            enableSuggestions: true,
            autocorrect: true,
            initialValue: firstName,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              setState(() => firstName = value);
            },
            decoration: textInputDecoration,
            validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
          ),
          SizedBox(height: FIELD_SPACE),
          Padding(padding: const EdgeInsets.only(right: 15), child: Text('Last Name', style: Get.textTheme.headline5)),
          TextFormField(
            style: Get.textTheme.bodyText1,
            cursorColor: Colors.yellow[900],
            obscureText: false,
            enableSuggestions: true,
            autocorrect: true,
            initialValue: lastName,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              setState(() => lastName = value);
            },
            onFieldSubmitted: (_) {
              _submitForm();
            },
            decoration: textInputDecoration,
            validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
          ),
        ],
      ),
    );
  }

  Widget _buildCredentialsForm(double _pageWidthFactor) {
    return FractionallySizedBox(
      widthFactor: _pageWidthFactor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: INITIAL_H_SPACE),
          Text('Some login info...', style: Theme.of(context).textTheme.headline4),
          Spacer(),
          Padding(padding: const EdgeInsets.only(right: 15, bottom: 5), child: Text('Email', style: Theme.of(context).textTheme.headline5)),
          TextFormField(
            style: Get.textTheme.bodyText1,
            cursorColor: Colors.yellow[900],
            obscureText: false,
            enableSuggestions: true,
            autocorrect: true,
            initialValue: email,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              setState(() => email = value);
            },
            decoration: textInputDecoration,
            validator: FormBuilderValidators.compose([FormBuilderValidators.email(context), FormBuilderValidators.required(context)]),
          ),
          SizedBox(height: FIELD_SPACE),
          Padding(padding: const EdgeInsets.only(right: 15, bottom: 5), child: Text('Password', style: Theme.of(context).textTheme.headline5)),
          TextFormField(
            style: Get.textTheme.bodyText1,
            cursorColor: Colors.yellow[900],
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            initialValue: password,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.done, //after this form is submitted, we're done!
            onChanged: (value) {
              setState(() => password = value);
            },
            onFieldSubmitted: (_) => _submitForm(),
            decoration: textInputDecoration,
            validator: FormBuilderValidators.compose([FormBuilderValidators.minLength(context, 7)]),
          ),
        ],
      ),
    );
  }

  //this is currently not in use, as we ask for the codes afterwards
  Widget _buildSchoolForm(double _pageWidthFactor) {
    return FractionallySizedBox(
      widthFactor: _pageWidthFactor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: INITIAL_H_SPACE),
          Text('Your codes!', style: Theme.of(context).textTheme.headline4),
          Spacer(),
          Padding(padding: const EdgeInsets.only(right: 15, bottom: 5), child: Text('School Code', style: Theme.of(context).textTheme.headline5)),
          TextFormField(
            style: Get.textTheme.bodyText1,
            cursorColor: Colors.yellow[900],
            obscureText: false,
            enableSuggestions: true,
            autocorrect: true,
            initialValue: schoolCode,
            autofocus: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              setState(() => schoolCode = value);
            },
            decoration: textInputDecoration,
            validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
          ),
          SizedBox(height: FIELD_SPACE),
          Padding(padding: const EdgeInsets.only(right: 15, bottom: 5), child: Text('Activation Code', style: Theme.of(context).textTheme.headline5)),
          TextFormField(
            style: Get.textTheme.bodyText1,
            cursorColor: Colors.yellow[900],
            obscureText: false,
            enableSuggestions: true,
            autocorrect: true,
            initialValue: activationCode,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              setState(() => activationCode = value);
            },
            onFieldSubmitted: (_) => _submitForm(),
            decoration: textInputDecoration,
            validator: FormBuilderValidators.compose([FormBuilderValidators.required(context)]),
          ),
        ],
      ),
    );
  }
}
