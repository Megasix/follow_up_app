import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Localisation {
  static List positions = [];

  static void getPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log('Pas de service GPS', name: 'Localisation', level: 1500);
    }

    // Check if we have permission to access location.
    permission = await Geolocator.checkPermission();
    while (!(permission == LocationPermission.always || permission == LocationPermission.whileInUse)) {
      Geolocator.requestPermission();
    }
  }

  static Future<Position> determinePosition() async {
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  static Future<String> geocodePosition(Position coordinate) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(coordinate.latitude, coordinate.longitude);
    Placemark place = placemarks[0];

    String _currentAddress = "${place.street},${place.locality}, ${place.postalCode}, ${place.country}";
    return _currentAddress;
  }

  static void appendToPositionList(Position position) {
    if (positions.last != position) positions.add(position);
  }
}
