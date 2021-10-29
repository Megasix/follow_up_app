import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;

class SpeedLimit {
  Future<String?> getSpeedLimitAtPos(LatLng position) async {
    String apiKey = "AIzaSyDGZS96VClnydF0jjbf9M4bevRHHya8r1I";
    String placeUrl =
        "https://nominatim.openstreetmap.org/reverse?format=json&lat=" +
            position.latitude.toString() +
            "&lon=" +
            position.longitude.toString() +
            "&zoom=17";
    String speedLimitUrl = "";
    //http request to get the max speed on the road
    await http.post(Uri.parse(placeUrl)).then((place_request) {
      Map placeMap = jsonDecode(place_request.body);
      //print(placeMap);
      speedLimitUrl =
          "http://overpass-api.de/api/interpreter?data=[out:json];way(" +
              placeMap["osm_id"].toString() +
              ");out%3b";
      //print(speedLimitUrl);
      //print(Uri.parse(speedLimitUrl));
      http.get(Uri.parse(speedLimitUrl)).then((speedLimit_request) {
        //print(speedLimit_request.body);
        Map speedLimit = jsonDecode(speedLimit_request.body);
        print(speedLimit);
        List roadInfo = speedLimit.values.elementAt(3);
        Map<String, dynamic> roadInfoElements = roadInfo.last;
        Map<String, dynamic> roadInfoTags = roadInfoElements.values.elementAt(3);
        String speedLimitOnPos = roadInfoTags.values.elementAt(2).toString();
        return speedLimitOnPos;
      });
    });
  }
}