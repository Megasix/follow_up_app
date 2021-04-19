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

  /// `Lets Go over some information regarding your account`
  String get verifInfo {
    return Intl.message(
      'Lets Go over some information regarding your account',
      name: 'verifInfo',
      desc: '',
      args: [],
    );
  }

  /// `country`
  String get country {
    return Intl.message(
      'country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `date of birth`
  String get birth {
    return Intl.message(
      'date of birth',
      name: 'birth',
      desc: '',
      args: [],
    );
  }

  /// `continue`
  String get continue {
    return Intl.message(
      'continue',
      name: 'continue',
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