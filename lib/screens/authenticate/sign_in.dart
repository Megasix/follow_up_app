import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:follow_up_app/models/enums.dart';
import 'package:follow_up_app/shared/extensions.dart';
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

  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

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
                        onPressed: () {
                          Navigator.pop(context);
                        },
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
                            Text('SIGN IN', style: Theme.of(context).textTheme.headline3),
                            SizedBox(height: 20),
                            Text('Welcome Back ${widget.userType.stringify()}!', style: Theme.of(context).textTheme.headline4),
                            Spacer(flex: 1),
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

  /* @override
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 75.0, bottom: 75.0, left: 50.0, right: 50.0),
                        child: Image(
                          image: AssetImage(
                            "assets/images/${Shared.lightThemeEnabled ? "Dark_" : ""}Follow_Up_logo-01.png",
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 40.0),
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

                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 40.0,
                                child: ElevatedButton(
                                    child: Text('Sign In', style: TextStyle(color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).secondaryHeaderColor,
                                    ),
                                    onPressed: () async {
                                      setState(() => loading = true);
                                      dynamic result = await AuthService.signInWithEmailAndPassword(context, email, password);
                                      if (result == null)
                                        setState(() {
                                          error = 'There was an error using these credentials please retry';
                                          loading = false;
                                        });
                                    }),
                              ),

                              Text('OR SIGN IN WITH'),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  GoogleSignInButton(onPressed: () async {
                                    await AuthService.signInWithGoogle(context);
                                  }),
                                  SizedBox(width: 15),
                                  FacebookSignInButton(onPressed: () async {
                                    await AuthService.signInWithFacebook(context);
                                  }),
                                  SizedBox(width: 15),
                                  TwitterSignInButton(onPressed: () async {}),
                                  SizedBox(width: 15),
                                  AppleSignInButton(onPressed: () async {}, darkMode: !Shared.lightThemeEnabled),
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
            );
          });
  } */
}
