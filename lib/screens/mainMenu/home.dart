import 'dart:async';
import 'package:flutter/material.dart';
import 'package:follow_up_app/services/acceleration.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/services/localisation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sensors/sensors.dart';

double x;
double y;
double z;
String _address, _dateTime;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

Position positioninit =
    new Position(latitude: 45.501861, longitude: -73.593889);
final Localisation _localisation = Localisation();
final Acceleration _acceleration = Acceleration();

class _HomeState extends State<Home> {
  final AuthService _authService = AuthService();
  Completer<GoogleMapController> _controller = Completer();
  StreamSubscription<Position> positionStream;

  @override
  void initState() {
    super.initState();
    gyroscopeEvents.listen((GyroscopeEvent event) {
      DateTime now = DateTime.now();
      if (this.mounted)
        setState(() {
          // x = event.x;
          // y = event.y;
          //  z = event.z;
          _dateTime = DateFormat('EEE d MMM kk:mm:ss ').format(now);
        });
      //_acceleration.verifyAcceleration(event);
    });
    positionStream = Geolocator.getPositionStream().listen((Position position) {
      if (this.mounted)
        setState(() {
          _localisation.geocodePosition(position).then((value) async {
            _address = value;
          });
        });
    });
  }

  @override
  void dispose() {
    positionStream.cancel();
    super.dispose();
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
                      _localisation.checkPermission();
                      print("Start");
                      _localisation.determinePosition().then((value) {
                        positioninit = value;
                      });
                    },
                    child: Text("Start"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      print("Stop");
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
                  SizedBox(
                    height: 3,
                  ),
                  if (x != null)
                    Text('x: ${x.toStringAsFixed(2)}' +
                        ' y: ${y.toStringAsFixed(2)}' +
                        ' z: ${z.toStringAsFixed(2)}'),
                ],
              ),
            ),
            SizedBox(
              height: 400,
              child: Container(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target:
                          LatLng(positioninit.latitude, positioninit.longitude),
                      zoom: 15),
                  myLocationEnabled: true,
                  tiltGesturesEnabled: true,
                  compassEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
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
}
