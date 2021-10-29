import 'dart:math';

import 'package:sensors/sensors.dart';

class Acceleration {
  verifyAcceleration(UserAccelerometerEvent event) {
    double acceleration =
        sqrt(pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2));
    return acceleration > 3;
  }
}
