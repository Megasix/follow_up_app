import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:follow_up_app/models/markers.dart';
import 'package:follow_up_app/models/rides.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/services/acceleration.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:follow_up_app/services/localisation.dart';
import 'package:follow_up_app/services/speed_limit_api_call.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sensors/sensors.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:uuid/uuid.dart';

Completer<GoogleMapController> _controllerCam = Completer();
LatLng? currentLatLng;
List<LatLng> listLatLng = [];

class Map extends StatefulWidget {
  @override
  _MapData createState() => _MapData();
}

class _MapData extends State<Map> {
  final Acceleration _acceleration = Acceleration();
  final SpeedLimitApiServices _speedLimitApiServices = SpeedLimitApiServices();
  final PanelController panelController = PanelController();

  late Stream<int> timerStream;
  late StreamSubscription accelerometerSubscription;
  late StreamSubscription<Position> positionSubscription;
  late StreamSubscription<int> timerSubscription;

  double? _accelerationVector;
  double? _currentSpeed;
  double? x;
  double? y;
  double? z;
  double _speedLimit = 0;
  List<MarkerData> listeMarkers = [];
  List<List<double>> listePositionNum = [[]]; //to encode polylines
  Position? currentPosition;
  String _address = "";
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';
  Timestamp lastMarkerTime = Timestamp.now();
  Timestamp startTimestamp = Timestamp.now();

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentLatLng = LatLng(position.latitude, position.longitude);
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
          if (double.parse(secondsStr) % 2 == 0) {
            (_speedLimitApiServices.getSpeedLimitAtPlace(_speedLimitApiServices
                .getPlaceInfosAtPos(currentPosition!)))
                .then((value) {
              setState(() {
                _speedLimit = value;
              });
            });
          }
        });
    });
    _getUserLocation();
    accelerometerSubscription =
        userAccelerometerEvents.listen((UserAccelerometerEvent event) {
          bool suddenAcc = false;
          if (this.mounted)
            setState(() {
              x = event.x;
              y = event.y;
              z = event.z;
              _accelerationVector =
                  sqrt(pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2));
              ;
            });

          double mainEventAxis;
          if (_accelerationVector! - event.x.abs() <
              _accelerationVector! - event.y.abs() &&
              _accelerationVector! - event.x.abs() <
                  _accelerationVector! - event.z.abs())
            mainEventAxis = event.x;
          else if (_accelerationVector! - event.y.abs() <
              _accelerationVector! - event.z.abs())
            mainEventAxis = event.y;
          else
            mainEventAxis = event.z;

          String infoWindow;
          if (mainEventAxis < 0) {
            infoWindow = "sudden braking";
            suddenAcc = mainEventAxis.abs() > 3;
          } else {
            infoWindow = "sudden acceleration";
            suddenAcc = mainEventAxis.abs() > 4.5;
          }


          lastMarkerTime =
          !listeMarkers.isEmpty ? listeMarkers.lastWhere((element) => element.type == "acceleration").time : lastMarkerTime;
          if (DateTime.now().difference(lastMarkerTime.toDate()).inSeconds > 2 &&
              suddenAcc) {
            listeMarkers.add(new MarkerData(
                markerId: (listeMarkers.length).toString(),
                infoWindow: infoWindow,
                type: "acceleration",
                position: new GeoPoint(
                    currentPosition!.latitude, currentPosition!.longitude),
                time: Timestamp.now()));
            print("acce");
          }
        });
    positionSubscription =
        Geolocator.getPositionStream().listen((Position position) {
          if (this.mounted)
            setState(() {
              currentPosition = position;
              if (currentPosition != null) {
                LatLng point =
                LatLng(currentPosition!.latitude, currentPosition!.longitude);
                listLatLng.add(point);
                listePositionNum
                    .add([currentPosition!.latitude, currentPosition!.longitude]);
                centerScreen(currentPosition!);
              }
              var speed = position.speed.roundToDouble() * 3.6;
              _currentSpeed = speed < 0 ? 0 : speed;
              Localisation.geocodePosition(currentPosition!).then((value) async {
                _address = value;
              });
            });
          lastMarkerTime =
          !listeMarkers.isEmpty ? listeMarkers.lastWhere((element) => element.type == "highSpeed").time : lastMarkerTime;
          if (DateTime.now().difference(lastMarkerTime.toDate()).inSeconds > 5 &&
              _currentSpeed! > _speedLimit) {
            listeMarkers.add(new MarkerData(
                markerId: (listeMarkers.length).toString(),
                infoWindow: ("Speed to high : " +
                    _currentSpeed.toString() +
                    "\nSpeed Limit : " +
                    _speedLimit.toString()),
                type: "highSpeed",
                position: new GeoPoint(
                    currentPosition!.latitude, currentPosition!.longitude),
                time: Timestamp.now()));
            print("highSpeed");
          }
        });
  }

  Future<bool> _willPopCallback() async {
    listePositionNum.removeAt(0);
    try {
      await DatabaseService.addRide(
          Provider.of<UserData?>(context, listen: false)!.uid,
          RideData(Uuid().v4(),
              name: DateTime.now().toString(),
              duration: hoursStr + ":" + minutesStr + ":" + secondsStr,
              date: startTimestamp,
              polylines: encodePolyline(listePositionNum),
              markersData: listeMarkers));
    } on Exception catch (e) {
      print(e.toString());
    }
    ;

    accelerometerSubscription.cancel();
    positionSubscription.cancel();
    timerSubscription.cancel();
    listLatLng = [];
    listePositionNum = [];
    Navigator.of(context).pop(true);
    print("exit");
    return true; // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        body: _address == null ||
            _currentSpeed == null ||
            _accelerationVector == null
            ? Loading()
            : SlidingUpPanel(
          color: Theme.of(context).secondaryHeaderColor,
          maxHeight: MediaQuery.of(context).size.height / 3,
          minHeight: 80,
          panel: Center(
              child: Container(
                color: Colors.transparent,
                padding:
                EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                child: Column(
                  children: [
                    Text(
                      _address,
                      style: TextStyle(
                          color: Theme.of(context).textSelectionColor),
                    ),
                    Text(
                      "Vitesse: " + _currentSpeed.toString() + " km/h",
                      style: TextStyle(
                          color: Theme.of(context).textSelectionColor),
                    ),
                    Text(
                      "Acceleration: " +
                          _accelerationVector!.toStringAsPrecision(3) +
                          " m/s²",
                      style: TextStyle(
                          color: Theme.of(context).textSelectionColor),
                    ),
                    Text(
                      "Temps écoulé: " + "$hoursStr:$minutesStr:$secondsStr",
                      style: TextStyle(
                          color: Theme.of(context).textSelectionColor),
                    ),
                    Text(
                      "Limite de vitesse: " + _speedLimit.toString(),
                      style: TextStyle(
                          color: Theme.of(context).textSelectionColor),
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
            child: Stack(
              children: [
                Center(
                  child: Text(
                    "Statistiques",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red),
                          child: Text("Exit"),
                          onPressed: _willPopCallback,
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        (_speedLimitApiServices.getSpeedLimitAtPlace(
                            _speedLimitApiServices.getPlaceInfosAtPos(
                                currentPosition!)))
                            .then((value) {
                          print(value);
                        });
                      },
                      backgroundColor: Colors.red,
                      child: Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: Center(
            child: bottomWidget(),
          ),
          borderRadius: radius,
        ),
      ),
    );
  }
}

class bottomWidget extends StatelessWidget {
  late GoogleMapController _controller;

  bool isMapCreated = false;

  changeMapMode() {
    if (!Get.isDarkMode)
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
        child: currentLatLng == null
            ? Loading()
            : Container(
          child: GoogleMap(
            initialCameraPosition:
            CameraPosition(target: currentLatLng!, zoom: 15),
            myLocationEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            polylines: {
              if (listLatLng != null)
                Polyline(
                    polylineId: const PolylineId('trajet'),
                    color: Theme.of(context).buttonColor,
                    width: 4,
                    points: listLatLng),
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
  late StreamController<int> streamController;
  Timer? timer;
  Duration timerInterval = Duration(seconds: 1);
  int counter = 0;

  void stopTimer() {
    if (timer != null) {
      timer!.cancel();
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
