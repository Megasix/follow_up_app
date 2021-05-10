import 'dart:async';
import 'package:flutter/material.dart';
import 'package:follow_up_app/services/acceleration.dart';
import 'package:follow_up_app/services/auth.dart';
import 'package:follow_up_app/services/localisation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sensors/sensors.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:intl/intl.dart';

StreamSubscription accelerometer;
LatLng currentPostion;
Completer<GoogleMapController> _controller = Completer();
final panelController = PanelController();
double x, y, z, _vitesse, _accelerationVecteur;
String _address, _dateTime;
Stream<Position> positionStream;
final Localisation _localisation = Localisation();
final Acceleration _acceleration = Acceleration();
DateTime now = DateTime.now();
StreamSubscription accelerometerSubscription;
Stream<int> timerStream;
StreamSubscription<int> timerSubscription;
String hoursStr = '00';
String minutesStr = '00';
String secondsStr = '00';
List<LatLng> listePosition = [];
Position _latLng;

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
                    )
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
  const bottomWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        child: currentPostion == null
            ? Container(
                child: Center(
                  child: Text(
                    "loading map..",
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
                  polylines: {
                    if (listePosition != null)
                      Polyline(
                          polylineId: const PolylineId('trajet'),
                          color: Colors.black,
                          width: 3,
                          points: listePosition),
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
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
