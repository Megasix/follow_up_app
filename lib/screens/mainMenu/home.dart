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

Position positioninit =
    new Position(latitude: 45.501861, longitude: -73.593889);
Map<MarkerId, Marker> markers = {};
PolylinePoints polylinePoints = PolylinePoints();
Map<PolylineId, Polyline> polylines = {};

class _HomeState extends State<Home> {
  final Set<Polyline> polyline = {};
  String _address, _dateTime;
  bool status = true;
  final AuthService _authService = AuthService();
  Completer<GoogleMapController> _controller = Completer();

  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  void initState() {
    super.initState();
    _determinePosition().then((value) {
      _getPolyline(value);
    });

    // ignore: cancel_subscriptions
    _addMarker(LatLng(positioninit.latitude, positioninit.longitude), "origin",
        BitmapDescriptor.defaultMarker);

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
                      _determinePosition().then((value) {
                        positioninit = value;
                      });
                    },
                    child: Text("Start"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      status = false;
                      print("Stop");
                      _determinePosition().then((value) {
                        _addMarker(
                            LatLng(value.latitude, value.longitude),
                            "destination",
                            BitmapDescriptor.defaultMarkerWithHue(90));
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
            SizedBox(
              height: 400,
              child: Container(
                child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(
                            positioninit.latitude, positioninit.longitude),
                        zoom: 15),
                    myLocationEnabled: true,
                    tiltGesturesEnabled: true,
                    compassEnabled: true,
                    scrollGesturesEnabled: true,
                    zoomGesturesEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    polylines: Set<Polyline>.of(polylines.values),
                    markers: Set<Marker>.of(markers.values)),
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

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  void _getPolyline(Position position) async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyCE2L8QxWYSXlydQlVCsLpkqt9e8B8N080",
      PointLatLng(45.6383, -73.7298),
      PointLatLng(position.latitude, position.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }
}
