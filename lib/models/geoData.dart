import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class positionData {
  final GeoPoint geoPoint;
  final Timestamp time;
  final double speed;
  positionData({this.geoPoint, this.time, this.speed});
}
