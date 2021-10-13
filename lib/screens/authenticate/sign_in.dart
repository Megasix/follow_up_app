import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:follow_up_app/models/enums.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/shared/extensions.dart';
import 'package:follow_up_app/shared/features/email.dart';
import 'package:follow_up_app/shared/features/facebook.dart';
import 'package:follow_up_app/shared/features/google.dart';
import 'package:follow_up_app/shared/style_constants.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:get/get.dart';

class SignIn extends StatefulWidget {
  final UserType userType;
  final Function toggleAuth;

  SignIn({required this.userType, required this.toggleAuth});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isFormValid = ValueNotifier<bool>(false);

  bool _isSigningInEmail = false;
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  void _goBack() {
    if (!_isSigningInEmail) {
      Navigator.pop(context);
    } else {
      setState(() => _isSigningInEmail = false);
    }
  }

  void _signIn() {
    AuthService.signInWithEmailAndPassword(context, email, password);
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : PhysicalModel(
            color: Colors.black,
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
                        icon: Stack(
                          children: [
                            AnimatedScale(
                                duration: const Duration(milliseconds: 100),
                                scale: _isSigningInEmail ? 1.0 : 0.0,
                                child: Icon(Icons.close_rounded, color: Get.isDarkMode ? Colors.black : Colors.white)),
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
                    CircleAvatar(
                      backgroundColor: Colors.yellow[700],
                      radius: 25,
                      child: IconButton(
                        icon: Icon(Icons.app_registration_rounded, color: Get.isDarkMode ? Colors.black : Colors.white),
                        onPressed: () {
                          widget.toggleAuth();
                        },
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
                              onPressed: () => _signIn(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Stack(children: [
                  //TODO: this needs refinement
                  AnimatedOpacity(duration: const Duration(milliseconds: 300), opacity: _isSigningInEmail ? 1.0 : 0.0, child: _buildSignInEmail()),
                  AnimatedOpacity(duration: const Duration(milliseconds: 300), opacity: _isSigningInEmail ? 0.0 : 1.0, child: _buildSignInOptions()),
                ]),
              ),
            ),
          );
  }

  Widget _buildSignInOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 40),
        Text('SIGN IN', style: Theme.of(context).textTheme.headline3),
        SizedBox(height: 20),
        Text('Welcome Back ${widget.userType.stringify()}!', style: Theme.of(context).textTheme.headline4),
        Spacer(flex: 9),
        FacebookSignInButton(onPressed: () {
          setState(() => loading = true);
          AuthService.signInWithFacebook(context);
        }),
        SizedBox(height: 15),
        GoogleSignInButton(onPressed: () {
          setState(() => loading = true);
          AuthService.signInWithGoogle(context);
        }),
        SizedBox(height: 15),
        EmailSignInButton(onPressed: () => setState(() => _isSigningInEmail = true)),
        SizedBox(height: 100),
      ],
    );
  }

  Widget _buildSignInEmail() {
    return OverflowBox(
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Form(
              key: _formKey,
              onChanged: () => _isFormValid.value = _formKey.currentState!.validate(),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 40),
                  Text('EMAIL', style: Get.textTheme.headline3),
                  SizedBox(height: 20),
                  Text('Welcome Back ${widget.userType.stringify()}!', style: Get.textTheme.headline4),
                  SizedBox(height: 20),
                  Spacer(flex: 6), //this spacer is surrounded by SizedBoxes to offset the squeezing when the keyboard is brought up
                  SizedBox(height: 20),
                  Padding(padding: const EdgeInsets.only(right: 15, bottom: 5), child: Text('Email', style: Get.textTheme.headline5)),
                  TextFormField(
                    style: Get.textTheme.headline5,
                    scrollPadding: MediaQuery.of(context).viewInsets,
                    cursorColor: Colors.yellow[900],
                    obscureText: false,
                    enableSuggestions: true,
                    autocorrect: true,
                    decoration: textInputDecoration,
                    validator: FormBuilderValidators.compose([FormBuilderValidators.email(context), FormBuilderValidators.required(context)]),
                  ),
                  SizedBox(height: 15),
                  Padding(padding: const EdgeInsets.only(right: 15, bottom: 5), child: Text('Password', style: Get.textTheme.headline5)),
                  TextFormField(
                    style: Get.textTheme.headline5,
                    scrollPadding: MediaQuery.of(context).viewInsets,
                    cursorColor: Colors.yellow[900],
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: textInputDecoration,
                    validator: FormBuilderValidators.compose([FormBuilderValidators.minLength(context, 6)]),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
