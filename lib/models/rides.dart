import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:follow_up_app/models/markers.dart';
import 'package:uuid/uuid.dart';

class RideData {
  final String? rideId; //works as doc id and ride id

  String name;
  String polylines;
  String duration;
  Timestamp date;
  List<MarkerData>? markersData;

  RideData(this.rideId,
      {required this.name,
      required this.duration,
      required this.date,
      required this.polylines,
      this.markersData});

  RideData.fromMap(String id, Map<String, dynamic>? map)
      : this(id,
            name: map?["name"],
            duration: map?["duration"],
            date: map?["date"],
            polylines: map?["polylines"],
            markersData: (map?['Markers'] as List)
                .map<MarkerData>((item) => MarkerData.fromMap(item))
                .toList());

  Map<String, dynamic> toMap() => {
        'Markers': this.markersData?.map((marker) => marker.toMap()).toList(),
        "name": name,
        "polylines": polylines,
        "duration": duration,
        "date": date,
      };
}
