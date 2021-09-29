import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        child: Center(
          child: SpinKitChasingDots(
            color: Theme.of(context).secondaryHeaderColor,
            size: 50.0,
          ),
        ),
      ),
    );
  }
}
