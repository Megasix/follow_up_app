class CustomUser {
  final String uid;

  CustomUser({this.uid});
}

class UserData {
  final String uid;
  final String name;
  final String hobby;
  final int age;

  UserData({this.uid, this.name, this.hobby, this.age});
}

class UserDisplaySetting{
  final bool theme;

  UserDisplaySetting(this.theme);
}
