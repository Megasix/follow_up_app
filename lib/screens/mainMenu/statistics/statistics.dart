import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:follow_up_app/screens/mainMenu/statistics/tracker.dart';
import 'package:follow_up_app/services/database.dart';
import 'package:follow_up_app/shared/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Completer<GoogleMapController> _controller = Completer();

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DatabaseService _databaseService = new DatabaseService(email: UserInformations.userEmail);

  QuerySnapshot rideSnapshot;

  void initRideStream() async {
    await _databaseService.getRides().then((value) => setState(() => rideSnapshot = value));
  }

  Widget rideList() {
    return rideSnapshot != null
        ? ListView.builder(
            itemCount: rideSnapshot.docs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: RideTile(
                  date: rideSnapshot.docs[index].get('date'),
                  duration: rideSnapshot.docs[index].get('duration'),
                  polylines: rideSnapshot.docs[index].get('polylines'),
                ),
              );
            },
          )
        : Container();
  }

  @override
  void initState() {
    initRideStream();
    super.initState();
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

class RideTile extends StatelessWidget {
  final Timestamp date;
  final String duration;
  final String polylines;

  const RideTile({this.date, this.duration, this.polylines});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => RideMap()));
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
                Text((date.toDate().day.toString() + " / " + date.toDate().month.toString() + " / " + date.toDate().year.toString()), style: TextStyle(color: Theme.of(context).textSelectionColor)),
                Spacer(),
                Text(("Duration : " + duration), style: TextStyle(color: Theme.of(context).textSelectionColor))
              ],
            ),
            SizedBox(height: 5.0),
            MapWidget(),
          ],
        ),
      ),
    );
  }
}

class MapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 100.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25.0),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(target: LatLng(45.503995, -73.593681), zoom: 10),
            myLocationEnabled: false,
            tiltGesturesEnabled: false,
            compassEnabled: false,
            scrollGesturesEnabled: false,
            zoomGesturesEnabled: false,
            zoomControlsEnabled: false,
            /*polylines: {
          Polyline(
              polylineId: const PolylineId('trajet'),
              color: Theme.of(context).buttonColor,
              width: 4,
              points: listePosition),
      },*/
            //polylines
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
      ),
    );
  }
}
