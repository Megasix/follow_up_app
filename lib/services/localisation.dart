import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:follow_up_app/models/geoData.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Localisation {
  List<positionData> positions = [];
  DatabaseService _databaseService = new DatabaseService();
  checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    Geolocator.requestPermission();
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("pas service");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      serviceEnabled == false;
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        serviceEnabled == false;
      }
      if (permission == LocationPermission.denied) {
        serviceEnabled == false;
      }
    }
    return serviceEnabled;
  }

  determinePosition() async {
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  geocodePosition(Position coordinate) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        coordinate.latitude, coordinate.longitude);
    Placemark place = placemarks[0];

    String _currentAddress =
        "${place.street},${place.locality}, ${place.postalCode}, ${place.country}";
    return _currentAddress;
  }

  storePosition(Position position) {
    GeoPoint geoPoint = new GeoPoint(position.latitude, position.longitude);
    positions.add(positionData(
        geoPoint: geoPoint, time: Timestamp.now(), speed: position.speed));
    //_databaseService.storePosition(positions);
  }
}
