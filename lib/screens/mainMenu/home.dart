import 'dart:async';

import 'package:flutter/material.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _address, _dateTime;
  bool status = true;
  final AuthService _authService = AuthService();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Position positioninit;
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _camPos = CameraPosition(
    target: LatLng(45.5167, -73.65),
    zoom: 14.4746,
  );
  @override
  void initState() {
    super.initState();

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _geocodePosition(position).then((value) {
          _address = value;
          print(position.speed);
        });
        DateTime now = DateTime.now();
        _dateTime = DateFormat('EEE d MMM kk:mm:ss ').format(now);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 75.0),
      child: Container(
        padding: EdgeInsets.only(bottom: 40.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RaisedButton(
                    onPressed: () {
                      status = true;
                      print("Start");
                      positioninit = _determinePosition();
                    },
                    child: Text("Start"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      status = false;
                      print("Stop");
                      _determinePosition().then((value) {
                        _getPolyline(value);
                      });
                    },
                    child: Text("Stop"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 3,
                  ),
                  if (_dateTime != null)
                    Text(
                      "Date/Time: $_dateTime",
                    ),
                  SizedBox(
                    height: 3,
                  ),
                  if (_address != null)
                    Text(
                      "Address: $_address",
                    ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: _authService.signOut,
              child: Text("signout"),
            ),
          ],
        ),
      ),
    );
  }

  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("pas service");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      print("demande");
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        print("tjr non");
      }

      if (permission == LocationPermission.denied) {
        print("refuser");
      }
    }
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  _geocodePosition(Position coordinate) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        coordinate.latitude, coordinate.longitude);
    Placemark place = placemarks[0];
    String _currentAddress =
        "${place.street},${place.locality}, ${place.postalCode}, ${place.country}";
    return _currentAddress;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline(Position position) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyCE2L8QxWYSXlydQlVCsLpkqt9e8B8N080",
        PointLatLng(positioninit.latitude, positioninit.longitude),
        PointLatLng(position.latitude, position.longitude),
        travelMode: TravelMode.walking);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}
