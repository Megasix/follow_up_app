import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:follow_up_app/services/acceleration.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:follow_up_app/services/localisation.dart';
import 'package:follow_up_app/shared/constants.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sensors/sensors.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:intl/intl.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

StreamSubscription accelerometer;
LatLng currentPostion;
final panelController = PanelController();
double x, y, z, _vitesse, _accelerationVecteur;
String _address, _dateTime;
Stream<Position> positionStream;
final Localisation _localisation = Localisation();
final Acceleration _acceleration = Acceleration();
final DatabaseService _databaseService =
    new DatabaseService(email: UserInformations.userEmail);
DateTime now = DateTime.now();
Timestamp myTimeStamp = Timestamp.fromDate(now);
StreamSubscription accelerometerSubscription;
Stream<int> timerStream;
StreamSubscription<int> timerSubscription;
String hoursStr = '00';
String minutesStr = '00';
String secondsStr = '00';
List<LatLng> listePosition = [];
List<List<double>> listePositionNum = [[]];
Position _latLng;
Completer<GoogleMapController> _controllerCam = Completer();

class Map extends StatefulWidget {
  @override
  _MapData createState() => _MapData();
}

class _MapData extends State<Map> {
  final AuthService _authService = AuthService();
  StreamSubscription<Position> positionStream;

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  void initState() {
    super.initState();
    timerStream = stopWatchStream();
    timerSubscription = timerStream.listen((int newTick) {
      if (mounted)
        setState(() {
          hoursStr =
              ((newTick / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
          minutesStr = ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
          secondsStr = (newTick % 60).floor().toString().padLeft(2, '0');
        });
    });
    _getUserLocation();
    accelerometerSubscription =
        userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      if (this.mounted)
        setState(() {
          x = event.x;
          y = event.y;
          z = event.z;
          _dateTime = DateFormat('EEE d MMM kk:mm:ss ').format(now);
          _accelerationVecteur = _acceleration.verifyAcceleration(event);
        });
    });
    positionStream = Geolocator.getPositionStream().listen((Position position) {
      if (this.mounted)
        setState(() {
          _latLng = position;
          if (_latLng != null) {
            LatLng point = LatLng(_latLng.latitude, _latLng.longitude);
            listePosition.add(point);
            listePositionNum.add([_latLng.latitude, _latLng.longitude]);
            centerScreen(_latLng);
          }
          _vitesse = position.speed;
          _localisation.geocodePosition(_latLng).then((value) async {
            _address = value;
          });
        });
    });
  }

  @override
  void dispose() {
    listePositionNum.removeAt(0);
    _databaseService.addNewRide(
        now.toString(),
        (hoursStr + ":" + minutesStr + ":" + secondsStr),
        myTimeStamp,
        encodePolyline(listePositionNum));
    accelerometerSubscription.cancel();
    positionStream.cancel();
    timerSubscription.cancel();
    listePosition = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    return Scaffold(
      body: _address == null || _vitesse == null || _accelerationVecteur == null
          ? Text("loading...")
          : SlidingUpPanel(
              maxHeight: MediaQuery.of(context).size.height / 3,
              minHeight: 80,
              panel: Center(
                  child: Container(
                child: Column(
                  children: [
                    Text(
                      _address,
                      style: TextStyle(color: Colors.black),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Vitesse: " + _vitesse.toString(),
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          "Acceleration: " +
                              _accelerationVecteur.toStringAsPrecision(3),
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          "Temps écoulé: " +
                              "$hoursStr:$minutesStr:$secondsStr",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
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
  GoogleMapController _controller;
  bool isMapCreated = false;

  changeMapMode() {
    if (ThemeMode.system == ThemeMode.light)
      getJsonMapData('assets/googleMapsThemes/light.json').then(setMapStyle);
    else
      getJsonMapData('assets/googleMapsThemes/dark.json').then(setMapStyle);
  }

  Future<String> getJsonMapData(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyleData) {
    _controller.setMapStyle(mapStyleData);
  }

  @override
  Widget build(BuildContext context) {
    if (isMapCreated) {
      changeMapMode();
    }

    return Material(
      child: SizedBox(
        child: currentPostion == null
            ? Loading()
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
                  polylines: {
                    if (listePosition != null)
                      Polyline(
                          polylineId: const PolylineId('trajet'),
                          color: Theme.of(context).buttonColor,
                          width: 4,
                          points: listePosition),
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _controllerCam.complete(controller);
                    isMapCreated = true;
                    _controller = controller;
                    changeMapMode();
                  },
                ),
              ),
      ),
    );
  }
}

Stream<int> stopWatchStream() {
  StreamController<int> streamController;
  Timer timer;
  Duration timerInterval = Duration(seconds: 1);
  int counter = 0;

  void stopTimer() {
    if (timer != null) {
      timer.cancel();
      timer = null;
      counter = 0;
      streamController.close();
    }
  }

  void tick(_) {
    counter++;
    streamController.add(counter);
  }

  void startTimer() {
    timer = Timer.periodic(timerInterval, tick);
  }

  streamController = StreamController<int>(
    onListen: startTimer,
    onCancel: stopTimer,
    onResume: startTimer,
    onPause: stopTimer,
  );

  return streamController.stream;
}

Future<void> centerScreen(Position position) async {
  final GoogleMapController controller = await _controllerCam.future;
  controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(position.latitude, position.longitude), zoom: 18.0)));
}
