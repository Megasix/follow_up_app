import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:follow_up_app/models/rides.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/screens/mainMenu/statistics/tracker.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:follow_up_app/shared/shared.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:provider/provider.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //todo: check if late is the right way to do this
  late Future<List<RideData>> _ridesFuture = DatabaseService.getRides(Provider.of<UserData?>(context)!.uid as String);

  Widget rideList() {
    return FutureBuilder<List<RideData>?>(
        future: _ridesFuture,
        builder: (context, asyncSnap) {
          //todo: add more cases (i.e. show an error msg if an error occurs)
          if (asyncSnap.connectionState != ConnectionState.done) {
            return Loading();
          }

          List<RideData>? rides = asyncSnap.data;

          return rides != null && rides.isNotEmpty
              ? ListView.builder(
                  itemCount: rides.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RideTile(
                        date: rides[index].date as Timestamp,
                        duration: rides[index].duration as Duration,
                        polylines: rides[index].polylines as String,
                      ),
                    );
                  },
                )
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    const _referenceHeight = 820.5714285714286;
    const _referenceWidth = 411.42857142857144;
    final double contextHeight = MediaQuery.of(context).size.height;
    final double contextWidth = MediaQuery.of(context).size.width;
    var heightRatio = contextHeight / _referenceHeight;
    var widthRatio = contextWidth / _referenceWidth;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      appBar: AppBar(
        title: Text('Statistics'),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 50.0 * heightRatio, bottom: 30.0 * heightRatio, left: 25.0 * widthRatio, right: 25.0 * widthRatio),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0)),
          color: Theme.of(context).backgroundColor,
        ),
        child: rideList(),
      ),
    );
  }
}

//todo: separate every widget in its own file, for organization purposes
class RideTile extends StatelessWidget {
  final Timestamp date;
  final Duration duration;
  final String polylines;

  const RideTile({required this.date, required this.duration, required this.polylines});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RideMap(
                      polyline: polylines,
                    )));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Theme.of(context).accentColor,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text((date.toDate().day.toString() + " / " + date.toDate().month.toString() + " / " + date.toDate().year.toString()),
                    style: TextStyle(color: Theme.of(context).textSelectionColor)),
                Spacer(),
                Text(("Duration : " + duration.toString()), style: TextStyle(color: Theme.of(context).textSelectionColor))
              ],
            ),
            SizedBox(height: 5.0),
            MapWidget(polylines),
          ],
        ),
      ),
    );
  }
}

class MapWidget extends StatelessWidget {
  late GoogleMapController _controller;
  bool isMapCreated = false;
  final String polyline;

  MapWidget(this.polyline);

  changeMapMode() {
    if (Shared.getTheme())
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

  void _setMapFitToTour(List<LatLng> p) {
    double minLat = p[0].latitude;
    double minLong = p[0].longitude;
    double maxLat = p[0].latitude;
    double maxLong = p[0].longitude;
    p.forEach((point) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLong) minLong = point.longitude;
      if (point.longitude > maxLong) maxLong = point.longitude;
    });
    _controller.moveCamera(CameraUpdate.newLatLngBounds(LatLngBounds(southwest: LatLng(minLat, minLong), northeast: LatLng(maxLat, maxLong)), 20));
  }

  @override
  Widget build(BuildContext context) {
    List<LatLng> polylines = decodePolylines(polyline);

    if (isMapCreated) {
      changeMapMode();
      _setMapFitToTour(polylines);
    }

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 100.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25.0),
          child: AbsorbPointer(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: LatLng(45.503995, -73.593681), zoom: 10),
              myLocationEnabled: false,
              tiltGesturesEnabled: false,
              compassEnabled: false,
              scrollGesturesEnabled: false,
              zoomGesturesEnabled: false,
              zoomControlsEnabled: false,
              polylines: {
                Polyline(polylineId: const PolylineId('trajet'), color: Theme.of(context).buttonColor, width: 4, points: polylines),
              },
              //polylines
              onMapCreated: (GoogleMapController controller) {
                isMapCreated = true;
                _controller = controller;
                _setMapFitToTour(polylines);
                changeMapMode();
              },
            ),
          ),
        ),
      ),
    );
  }
}

List<LatLng> decodePolylines(String polyline) {
  List<LatLng> points = [];
  List<List<num>> pointsNum = decodePolyline(polyline);
  if (pointsNum.length != null)
    for (int i = 0; i < pointsNum.length; i++) {
      LatLng point = LatLng(pointsNum[i][0] as double, pointsNum[i][1] as double);
      points.add(point);
    }
  points.removeAt(0);
  return points;
}
