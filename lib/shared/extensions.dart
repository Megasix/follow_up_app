import 'package:follow_up_app/models/enums.dart';

extension Stringify on UserType {
  String stringify() {
    switch (this) {
      case UserType.STUDENT:
        return 'Student';
      case UserType.INSTRUCTOR:
        return 'Instructor';
    }
  }
}
