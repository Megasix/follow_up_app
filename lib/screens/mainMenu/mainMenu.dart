import 'dart:async';

import 'package:flutter/material.dart';
import 'package:follow_up_app/screens/mainMenu/home.dart';
import 'package:follow_up_app/screens/mainMenu/statistics.dart';
import 'package:follow_up_app/services/localisation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:sensors/sensors.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

final Localisation _localisation = Localisation();

class _MainMenuState extends State<MainMenu> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    Statistics(),
    Text(
      'Index 2: Messages',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Theme.of(context).secondaryHeaderColor,
          width: double.infinity,
          height: double.infinity,
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              label: 'Statistics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined),
              label: 'Messages',
            )
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).buttonColor,
          onTap: _onItemTapped,
        ));
  }
}
