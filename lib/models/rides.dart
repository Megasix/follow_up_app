import 'package:cloud_firestore/cloud_firestore.dart';

class RideData {
  final String rideId; //works as doc id and ride id

  String? name;
  String? polylines;
  String? duration;
  Timestamp? date;

  RideData(this.rideId, {this.name, this.duration, this.date, this.polylines});

  RideData.fromMap(String id, Map<String, dynamic>? map)
      : this(id,
            name: map?["name"],
            duration: map?["duration"],
            date: map?["date"],
            polylines: map?["polylines"]);

  Map<String, dynamic> toMap() => {
        "name": name,
        "polylines": polylines,
        "duration": duration,
        "date": date,
      };
}
