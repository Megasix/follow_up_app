import 'dart:async';
import 'package:flutter/material.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:follow_up_app/screens/mainMenu/mapData.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

LatLng currentPostion;

class _HomeState extends State<Home> {
  final AuthService _authService = AuthService();
  Completer<GoogleMapController> _controller = Completer();

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  void initState() {
    _getUserLocation();
    super.initState();
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return Map();
                        }),
                      );
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
            SizedBox(
              height: 400,
              child: currentPostion == null
                  ? Container(
                      child: Center(
                        child: Text(
                          'loading map..',
                          style: TextStyle(
                              fontFamily: 'Avenir-Medium',
                              color: Colors.grey[400]),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        print("test");
                      },
                      child: Container(
                        child: GoogleMap(
                          initialCameraPosition:
                              CameraPosition(target: currentPostion, zoom: 15),
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
            ),
            RaisedButton(
              onPressed: () {
                _authService.signOut();
              },
              child: Text("signout"),
            ),
          ],
        ),
      ),
    );
  }
}
