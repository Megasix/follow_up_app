import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerData {
  String markerId;
  String infoWindow;
  String type;
  GeoPoint position;
  Timestamp time;

  MarkerData(
      {required this.markerId,
        required this.infoWindow,
        required this.type,
        required this.position,
        required this.time});

  MarkerData.fromMap(Map<String, dynamic>? map)
      : this(
      markerId: map?["markerId"],
      infoWindow: map?["infoWindow"],
      type: map?["type"],
      position: map?["position"],
      time: map?["time"]);

  Map<String, dynamic> toMap() => {
    "markerId": markerId,
    "infoWindow": infoWindow,
    "type": type,
    "position": position,
    "time": time
  };

  Marker toMarkerGoogle() {
    return Marker(
        markerId: MarkerId(this.markerId),
        infoWindow: InfoWindow(title: infoWindow),
        position: LatLng(this.position.latitude, this.position.longitude));
  }
}
