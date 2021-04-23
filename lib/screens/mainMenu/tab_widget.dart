import 'package:flutter/material.dart';

class TabWidget extends StatelessWidget {
  const TabWidget({
    Key key,
    @required this.scrollController,
  }) : super(key: key);
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) => ListView(
        padding: EdgeInsets.all(16),
        controller: scrollController,
        children: [
          Text(
            'test',
            textAlign: TextAlign.center,
          ),
        ],
      );
}
