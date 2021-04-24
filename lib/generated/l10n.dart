// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hello World!`
  String get helloWorld {
    return Intl.message(
      'Hello World!',
      name: 'helloWorld',
      desc: 'The conventional newborn programmer greeting',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get logIn {
    return Intl.message(
      'Log In',
      name: 'logIn',
      desc: '',
      args: [],
    );
  }

  /// `Or Sign Up With`
  String get signOther {
    return Intl.message(
      'Or Sign Up With',
      name: 'signOther',
      desc: 'To sign up with other platforms  ',
      args: [],
    );
  }

  /// `Wrong email or password! Please try again`
  String get error {
    return Intl.message(
      'Wrong email or password! Please try again',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Create a account for free`
  String get createACC {
    return Intl.message(
      'Create a account for free',
      name: 'createACC',
      desc: '',
      args: [],
    );
  }

  /// `Let's Begin!`
  String get letsBegin {
    return Intl.message(
      'Let\'s Begin!',
      name: 'letsBegin',
      desc: '',
      args: [],
    );
  }

  /// `Let's go over some information regarding your account`
  String get verifInfo {
    return Intl.message(
      'Let\'s go over some information regarding your account',
      name: 'verifInfo',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `Date of birth`
  String get birth {
    return Intl.message(
      'Date of birth',
      name: 'birth',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continuer {
    return Intl.message(
      'Continue',
      name: 'continuer',
      desc: '',
      args: [],
    );
  }

  /// `Do you already have an Account ? Please Sign In`
  String get alreadyACC {
    return Intl.message(
      'Do you already have an Account ? Please Sign In',
      name: 'alreadyACC',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNb {
    return Intl.message(
      'Phone Number',
      name: 'phoneNb',
      desc: '',
      args: [],
    );
  }

  /// `I accept the terms and conditions`
  String get accept {
    return Intl.message(
      'I accept the terms and conditions',
      name: 'accept',
      desc: 'The user confirms that he accepts the terms and conditions for using our app',
      args: [],
    );
  }

  /// `You need to read the terms and conditions`
  String get acceptError {
    return Intl.message(
      'You need to read the terms and conditions',
      name: 'acceptError',
      desc: 'The user is told to read the terms and conditions if they haven\'t done it yet',
      args: [],
    );
  }

  /// `What is your name ?`
  String get name {
    return Intl.message(
      'What is your name ?',
      name: 'name',
      desc: 'We ask the user for his name',
      args: [],
    );
  }

  /// `First name`
  String get firstName {
    return Intl.message(
      'First name',
      name: 'firstName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message(
      'Last Name',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `Your real name can be used to verify your identity by contacting your driving school`
  String get infoName {
    return Intl.message(
      'Your real name can be used to verify your identity by contacting your driving school',
      name: 'infoName',
      desc: 'We inform the user that using their real name can help them communicate with their school',
      args: [],
    );
  }

  /// `Identifie your account`
  String get idCompte {
    return Intl.message(
      'Identifie your account',
      name: 'idCompte',
      desc: '',
      args: [],
    );
  }

  /// `This is the information that will be used for Follow Up`
  String get infoCount {
    return Intl.message(
      'This is the information that will be used for Follow Up',
      name: 'infoCount',
      desc: '',
      args: [],
    );
  }

  /// `Please read the conditions for securitie reasons`
  String get secLec {
    return Intl.message(
      'Please read the conditions for securitie reasons',
      name: 'secLec',
      desc: '',
      args: [],
    );
  }

  /// `terms and condition`
  String get terms {
    return Intl.message(
      'terms and condition',
      name: 'terms',
      desc: '',
      args: [],
    );
  }

  /// `Put your Password Here`
  String get titreMDP {
    return Intl.message(
      'Put your Password Here',
      name: 'titreMDP',
      desc: '',
      args: [],
    );
  }

  /// `For security reasons please put a complicated Password`
  String get secMDP {
    return Intl.message(
      'For security reasons please put a complicated Password',
      name: 'secMDP',
      desc: '',
      args: [],
    );
  }

  /// `Connect Yourself`
  String get connect {
    return Intl.message(
      'Connect Yourself',
      name: 'connect',
      desc: '',
      args: [],
    );
  }

  /// `There was an error with your information please try again `
  String get phError {
    return Intl.message(
      'There was an error with your information please try again ',
      name: 'phError',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}