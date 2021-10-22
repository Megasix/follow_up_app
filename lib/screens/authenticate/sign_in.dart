import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:follow_up_app/generated/assets.gen.dart';
import 'package:follow_up_app/models/enums.dart';
import 'package:follow_up_app/screens/authenticate/register.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/shared/extensions.dart';
import 'package:follow_up_app/shared/features/email.dart';
import 'package:follow_up_app/shared/features/facebook.dart';
import 'package:follow_up_app/shared/features/google.dart';
import 'package:follow_up_app/shared/page_routes.dart';
import 'package:follow_up_app/shared/style_constants.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:get/get.dart';

class SignIn extends StatefulWidget {
  final Function toggleAuth;

  SignIn({required this.toggleAuth});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with TickerProviderStateMixin {
  static const double H_PADDING = 15.0;

  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isFormValid = ValueNotifier<bool>(false);

  bool _isSigningInEmail = false;
  bool _loading = false;

  // text field state
  String email = '';
  String password = '';

  void _goBack() {
    if (!_isSigningInEmail) {
      Navigator.pop(context);
    } else {
      FocusScope.of(context).unfocus();
      setState(() => _isSigningInEmail = false);
    }
  }

  void _socialLogin(SignInType signInType) async {
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

    //there has been an error and we haven't been able to sign in, go back to the sign in page
    if (!isSuccess) setState(() => _loading = false);
  }

  void _emailLogin() async {
    setState(() => _loading = true);

    //there has been an error and we haven't been able to sign in, go back to the sign in page
    if (!await AuthService.signInWithEmailAndPassword(context, email, password)) {
      setState(() => _loading = false);
    }
  }

  void _forgotPassword() {
    Navigator.push(context, Routes.forgotPassDialog());
  }

  @override
  Widget build(BuildContext context) {
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
                      icon: Stack(
                        children: [
                          AnimatedScale(
                            duration: const Duration(milliseconds: 100),
                            scale: _isSigningInEmail ? 1.0 : 0.0,
                            child: Icon(Icons.close_rounded, color: Get.isDarkMode ? Colors.black : Colors.white),
                          ),
                          AnimatedScale(
                            duration: const Duration(milliseconds: 100),
                            scale: _isSigningInEmail ? 0.0 : 1.0,
                            child: Icon(Icons.arrow_back_rounded, color: Get.isDarkMode ? Colors.black : Colors.white),
                          )
                        ],
                      ),
                      onPressed: () => _goBack(),
                    ),
                  ),
                  AnimatedScale(
                    duration: const Duration(milliseconds: 200),
                    scale: _isSigningInEmail ? 1.0 : 0.0,
                    child: CircleAvatar(
                      backgroundColor: Colors.yellow[700],
                      radius: 25,
                      child: IconButton(
                        icon: Icon(Icons.restore_rounded, color: Get.isDarkMode ? Colors.black : Colors.white),
                        onPressed: () => _isSigningInEmail ? _forgotPassword() : widget.toggleAuth(),
                      ),
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
                            onPressed: () => _emailLogin(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: H_PADDING),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: Get.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 40),
                      Text(
                        'SIGN IN',
                        style: Get.textTheme.headline3,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Welcome Back!',
                        style: Get.textTheme.headline4,
                      ),
                      Flexible(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOutQuart,
                              width: Get.width - (H_PADDING) * 2,
                              left: _isSigningInEmail ? -Get.width : 0,
                              bottom: Get.height * 0.12,
                              child: _buildSignInOptions(),
                            ),
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOutQuart,
                              width: Get.width - (H_PADDING) * 2,
                              left: _isSigningInEmail ? 0 : Get.width,
                              bottom: Get.height * 0.12,
                              child: _buildSignInEmail(),
                            ),
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

  Widget _buildSignInOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        FacebookSignInButton(onPressed: () => _socialLogin(SignInType.FACEBOOK)),
        SizedBox(height: 15),
        GoogleSignInButton(onPressed: () => _socialLogin(SignInType.GOOGLE)),
        SizedBox(height: 15),
        EmailSignInButton(onPressed: () => setState(() => _isSigningInEmail = true)),
      ],
    );
  }

  Widget _buildSignInEmail() {
    return Form(
      key: _formKey,
      onChanged: () => _isFormValid.value = _formKey.currentState!.validate(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(padding: const EdgeInsets.only(right: 15, bottom: 2), child: Text('Email', style: Get.textTheme.headline5)),
          TextFormField(
            style: Get.textTheme.bodyText1,
            cursorColor: Colors.yellow[900],
            obscureText: false,
            enableSuggestions: true,
            autocorrect: true,
            decoration: textInputDecoration,
            onChanged: (value) => email = value,
            validator: FormBuilderValidators.compose([FormBuilderValidators.email(context), FormBuilderValidators.required(context)]),
          ),
          SizedBox(height: 10),
          Padding(padding: const EdgeInsets.only(right: 15, bottom: 2), child: Text('Password', style: Get.textTheme.headline5)),
          TextFormField(
            style: Get.textTheme.bodyText1,
            cursorColor: Colors.yellow[900],
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: textInputDecoration,
            onChanged: (value) => password = value,
            validator: FormBuilderValidators.compose([FormBuilderValidators.minLength(context, 6)]),
          ),
        ],
      ),
    );
  }
}
