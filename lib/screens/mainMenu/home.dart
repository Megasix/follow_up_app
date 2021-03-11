import 'package:flutter/material.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Home extends StatelessWidget {
  bool status;
  final AuthService _authService = AuthService();
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
                      _determinePosition().then((location) {
                        print(location);
                      });
                    },
                    child: Text("Start"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      status = false;
                      print("Stop");
                      _authService.signOut();
                    },
                    child: Text("Stop"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Text('Location'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String> _determinePosition() async {
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
  Position coordinate = await Geolocator.getCurrentPosition();
  List<Placemark> placemarks =
      await placemarkFromCoordinates(coordinate.latitude, coordinate.longitude);
  Placemark place = placemarks[0];
  String _currentAddress =
      "${place.street},${place.locality}, ${place.postalCode}, ${place.country}";
  return _currentAddress;
}

Future<String> _geocodePosition(Position coordinate) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(coordinate.latitude, coordinate.longitude);
  Placemark place = placemarks[0];
  String _currentAddress =
      "${place.street},${place.locality}, ${place.postalCode}, ${place.country}";
  return _currentAddress;
}
