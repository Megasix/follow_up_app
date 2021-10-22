import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:follow_up_app/main.dart';
import 'package:follow_up_app/models/rides.dart';
import 'package:follow_up_app/shared/shared.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

class RideMap extends StatefulWidget {
  final RideData rideData;

  const RideMap({Key? key, required this.rideData}) : super(key: key);

  @override
  _RideMapState createState() => _RideMapState();
}

class _RideMapState extends State<RideMap> {
  _RideMapState();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MapWidget(widget.rideData),
    );
  }
}

class MapWidget extends StatelessWidget {
  late GoogleMapController _controller;
  bool isMapCreated = false;
  final RideData rideData;

  MapWidget(this.rideData);

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
    _controller.moveCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(minLat, minLong),
            northeast: LatLng(maxLat, maxLong)),
        20));
  }

  @override
  Widget build(BuildContext context) {
    List<LatLng> polylines = decodePolylines(rideData.polylines);

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
          child: GoogleMap(
            markers: rideData.markersData
                    ?.map((mark) => mark.toMarkerGoogle())
                    .toSet() ??
                Set(),
            initialCameraPosition:
                CameraPosition(target: LatLng(45.503995, -73.593681), zoom: 10),

            polylines: {
              Polyline(
                  polylineId: const PolylineId('trajet'),
                  color: Theme.of(context).buttonColor,
                  width: 4,
                  points: polylines),
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
    );
  }
}

List<LatLng> decodePolylines(String polyline) {
  List<LatLng> points = [];
  List<List<num>> pointsNum = decodePolyline(polyline);
  if (pointsNum.length != null)
    for (int i = 0; i < pointsNum.length; i++) {
      LatLng point =
          LatLng(pointsNum[i][0] as double, pointsNum[i][1] as double);
      points.add(point);
    }
  points.removeAt(0);
  return points;
}
