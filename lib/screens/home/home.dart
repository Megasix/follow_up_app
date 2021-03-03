import 'package:flutter/material.dart';
import 'package:follow_up_app/models/setting.dart';
import 'package:follow_up_app/screens/home/setting_list.dart';
import 'package:follow_up_app/screens/home/settings_form.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Theme.of(context).secondaryHeaderColor,
          width: double.infinity,
          height: double.infinity,
        ));
  }
}
