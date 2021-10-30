import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
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
      currentPostion = LatLng(position.latitude, position.longitude);
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
          padding: EdgeInsets.only(top: 50.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(50.0)),
            color: Theme.of(context).backgroundColor,
          ),
          child: Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Welcome back \n" +
                            Provider.of<UserData?>(context)!.firstName,
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          Get.to(SettingsPage());
                        },
                        child: Container(
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).secondaryHeaderColor),
                        ),
                      ),
                    ],
                  ),
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
        width: MediaQuery.of(context).size.width,
        child: currentPostion == null
            ? Loading()
            : GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          maintainState: false, builder: (context) => Map()));
                },
                child: AbsorbPointer(
                  absorbing: true,
                  child: GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: currentPostion!, zoom: 15),
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
    );
  }
}
