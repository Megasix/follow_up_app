import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:follow_up_app/screens/mainMenu/rides/mapData.dart';
import 'package:follow_up_app/screens/mainMenu/settings/settings_page.dart';
import 'package:follow_up_app/shared/loading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  bool _isDrawerOpen = false;
  bool isPlaying = false;

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentLatLng = LatLng(position.latitude, position.longitude);
    });
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _handleOnPressed() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  @override
  void initState() {
    _getUserLocation();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        elevation: 0,
        leading: TextButton.icon(
            onPressed: () {
              if (!_isDrawerOpen) {
                _openDrawer();
              } else {
                Navigator.pop(context);
              }
              setState(() {
                _isDrawerOpen = !_isDrawerOpen;
              });
              _handleOnPressed();
            },
            icon: AnimatedIcon(
              icon: AnimatedIcons.menu_arrow,
              color: Colors.white,
              progress: _animationController,
            ),
            label: Text("")),
      ),
      body: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        drawer: Drawer(
          child: SettingsPage(),
        ),
        onDrawerChanged: (onDrawerChanged) {
          debugPrint('onDrawerChanged? $onDrawerChanged');
          // onDrawerChanged is called on changes in drawer direction
          // true - gesture that the Drawer is being opened
          // false - gesture that the Drawer is being closed
          onDrawerChanged
              ? _animationController.forward()
              : _animationController.reverse();
        },
        body: Container(
          padding: EdgeInsets.only(top: 20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(50.0)),
            color: Theme.of(context).backgroundColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 60,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 25),
                child: Text(
                  "Welcome back \n" +
                      Provider.of<UserData?>(context)!.firstName,
                ),
              ),
              MapWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class MapWidget extends StatelessWidget {
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
      color: Colors.transparent,
      child: SizedBox(
        child: currentLatLng == null
            ? Loading()
            : GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          maintainState: false, builder: (context) => Map()));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                  child: AbsorbPointer(
                    absorbing: true,
                    child: GoogleMap(
                      initialCameraPosition:
                          CameraPosition(target: currentLatLng!, zoom: 15),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      tiltGesturesEnabled: false,
                      compassEnabled: false,
                      scrollGesturesEnabled: false,
                      zoomGesturesEnabled: false,
                      zoomControlsEnabled: false,
                      onMapCreated: (GoogleMapController controller) {
                        isMapCreated = true;
                        _controller = controller;
                        changeMapMode();
                      },
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
