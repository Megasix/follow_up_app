import 'package:flutter/material.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/screens/mainMenu/rides/home.dart';
import 'package:follow_up_app/screens/mainMenu/statistics/statistics.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:provider/provider.dart';
import 'messaging/messaging.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    Statistics(),
    Messaging(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    UserData? user = Provider.of<UserData?>(context);

    return user == null
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
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
            ),
          );
  }
}
