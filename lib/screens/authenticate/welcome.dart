import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:follow_up_app/generated/assets.gen.dart';
import 'package:follow_up_app/models/enums.dart';
import 'package:follow_up_app/shared/page_routes.dart';
import 'package:follow_up_app/shared/style_constants.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Welcome extends StatefulWidget {
  Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final ScrollController _controller = ScrollController();

  void _toggleUserType(bool showSignIn) {
    Navigator.push(context, Routes.authPage(showSignIn));
  }

  bool _onEndScroll(ScrollEndNotification notif) {
    final scrollDistance = Get.height + 70; //this offset must be equal to total vertical padding of the page
    final double scrollDelta = _controller.offset / scrollDistance;
    double snapOffset = 0;

    print(_controller.offset);
    print(scrollDelta);

    if (_controller.offset > 0 && _controller.offset < scrollDistance) {
      if (_controller.position.userScrollDirection == ScrollDirection.reverse)
        snapOffset = scrollDelta > 0.15 ? scrollDistance : 0;
      else if (_controller.position.userScrollDirection == ScrollDirection.forward) snapOffset = scrollDelta < 0.7 ? 0 : scrollDistance;

      Future.microtask(() => _controller.animateTo(snapOffset, duration: Duration(milliseconds: 200), curve: Curves.easeInOutCubic));
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.backgroundColor,
      body: NotificationListener<ScrollEndNotification>(
        onNotification: _onEndScroll,
        child: CustomScrollView(
          controller: _controller,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.black54,
              expandedHeight: Get.height,
              pinned: false,
              collapsedHeight: 0,
              toolbarHeight: 0,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                centerTitle: true,
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Transform.rotate(angle: pi, child: Lottie.asset(Assets.lottie.arrowLight, height: 55)),
                ),
                background: Container(
                  decoration: Get.isDarkMode
                      ? null
                      : BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter, end: Alignment.center, colors: [Colors.black45.withOpacity(0.6), Colors.black45.withOpacity(0)])),
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Image.asset(
                    Get.isDarkMode ? Assets.images.followUpLogo01.path : Assets.images.darkFollowUpLogo01.path,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(35),
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                child: SizedBox(
                  height: Get.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(),
                      Lottie.asset(Assets.lottie.carVrooming, height: Get.height * 0.3),
                      Text('WELCOME TO\nFOLLOW UP', textAlign: TextAlign.center, style: Get.textTheme.headline4),
                      SizedBox(height: 15),
                      Text('To continue, please select your account type :)', textAlign: TextAlign.center, style: Get.textTheme.headline6),
                      Spacer(),
                      SizedBox(
                        height: 150,
                        width: Get.width * 0.85,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              child: TextButton(
                                style: Get.isDarkMode ? darkLoginButtonStyle : lightLoginButtonStyle,
                                onPressed: () => _toggleUserType(true),
                                child: Text('SIGN IN', style: Get.textTheme.headline5!.copyWith(color: Colors.yellow[700])),
                              ),
                            ),
                            SizedBox(width: 25),
                            Expanded(
                              child: TextButton(
                                style: Get.isDarkMode ? darkLoginButtonStyle : lightLoginButtonStyle,
                                onPressed: () => _toggleUserType(false),
                                child: Text('REGISTER', style: Get.textTheme.headline5!.copyWith(color: Colors.yellow[700])),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
