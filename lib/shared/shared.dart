import 'package:follow_up_app/shared/style_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  static const String USER_LOGGED_IN_KEY = 'ISLOGGEDIN';
  static const String USER_NAME_KEY = 'USERNAMEKEY';
  static const String USER_EMAIL_KEY = 'USEREMAILKEY';

  static bool lightThemeEnabled = true;

  //Theme methods!
  static bool getTheme() {
    return lightThemeEnabled;
  }

  static void setTheme(bool enableLightTheme) {
    lightThemeEnabled = enableLightTheme;
  }

  static void fillUserInfo() async {
    UserInformations.userFirstName = await Shared.getUserNameSharedPreference();
    UserInformations.userEmail = await Shared.getUserEmailSharedPreference();
  }

  //Preference saving methods!
  static Future<bool> saveUserLoggedInSharedPreference(bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(USER_LOGGED_IN_KEY, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSharedPreference(String userFirstName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(USER_NAME_KEY, userFirstName);
  }

  static Future<bool> saveUserEmailSharedPreference(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(USER_EMAIL_KEY, userEmail);
  }

  //Preference retrieving methods!
  static Future getUserLoggedInSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(USER_LOGGED_IN_KEY);
  }

  static Future getUserNameSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_NAME_KEY);
  }

  static Future getUserEmailSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_EMAIL_KEY);
  }
}
