import 'package:flutter/material.dart';
import 'package:follow_up_app/models/setting.dart';

class SettingTile extends StatelessWidget {

  final Setting setting;
  SettingTile({this.setting});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(top: 8.0),
    child: Card(
      margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.blueGrey[(double.parse(((setting.age) / 100).toStringAsFixed(1)) * 1000).toInt()],
        backgroundImage: AssetImage('assets/marianne.jpg'),
        ),
        title: Text(setting.name),
        subtitle: Text('Likes ${setting.hobby}'),
      ),
    ),);
  }
}
