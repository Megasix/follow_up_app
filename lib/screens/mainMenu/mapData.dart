import 'dart:async';
import 'package:flutter/material.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

StreamSubscription accelerometer;
LatLng currentPostion;
Completer<GoogleMapController> _controller = Completer();
final panelController = PanelController();

class Map extends StatefulWidget {
  @override
  _MapData createState() => _MapData();
}

class _MapData extends State<Map> {
  final AuthService _authService = AuthService();

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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    return Scaffold(
      body: SlidingUpPanel(
        maxHeight: MediaQuery.of(context).size.height / 3,
        minHeight: 80,
        panel: Center(
          child: Text("pending"),
        ),
        collapsed: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.orange,
                  Colors.yellow,
                ],
              ),
              color: Colors.blueGrey,
              borderRadius: radius),
          child: Center(
            child: Text(
              "Statistiques",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: Center(
          child: bottomWidget(),
        ),
        borderRadius: radius,
      ),
    );
  }
}

class bottomWidget extends StatelessWidget {
  const bottomWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        child: currentPostion == null
            ? Container(
                child: Center(
                  child: Text(
                    'loading map..',
                    style: TextStyle(
                        fontFamily: 'Avenir-Medium', color: Colors.grey[400]),
                  ),
                ),
              )
            : Container(
                child: GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: currentPostion, zoom: 15),
                  myLocationEnabled: true,
                  tiltGesturesEnabled: true,
                  compassEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
      ),
    );
  }
}
