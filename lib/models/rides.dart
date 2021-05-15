import 'package:cloud_firestore/cloud_firestore.dart';

class Ride {
  Timestamp date;
  String duration;
  String polylines;
  String name;

  Ride({this.name, this.duration, this.date, this.polylines});
}