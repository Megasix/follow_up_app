import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:follow_up_app/generated/l10n.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;

class SpeedLimitApiServices {
  Future<double> getSpeedLimitAtPlace(Future<Map> placeMap) async {
    double speedLimit = 0;
    await placeMap.then((value) async {
      String speedLimitUrl =
          "http://overpass-api.de/api/interpreter?data=[out:json];way(" +
              value["osm_id"].toString() +
              ");out%3b";
      await http.get(Uri.parse(speedLimitUrl)).then((speedLimit_request) {
        Map speedLimitMap = jsonDecode(speedLimit_request.body);
        speedLimit =
            double.parse(speedLimitMap["elements"][0]["tags"]["maxspeed"]);
      });
    });
    return speedLimit;
  }

  Future<Map> getPlaceInfosAtPos(Position position) async {
    String placeUrl =
        "https://nominatim.openstreetmap.org/reverse?format=json&lat=" +
            position.latitude.toString() +
            "&lon=" +
            position.longitude.toString() +
            "&zoom=17";
    Map placeMap = new Map();
    await http.post(Uri.parse(placeUrl)).then((place_request) {
      placeMap = jsonDecode(place_request.body);
    });
    return placeMap;
  }
}
