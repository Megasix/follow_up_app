import 'package:flutter/material.dart';
import 'package:follow_up_app/models/setting.dart';
import 'package:follow_up_app/screens/home/setting_tile.dart';
import 'package:provider/provider.dart';

class SettingList extends StatefulWidget {
  @override
  _SettingListState createState() => _SettingListState();
}

class _SettingListState extends State<SettingList> {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<List<Setting>>(context) ?? [];

    return ListView.builder(
      itemCount: settings.length,
      itemBuilder: (context, index){
      return SettingTile(setting: settings[index]);
      },);
  }
}