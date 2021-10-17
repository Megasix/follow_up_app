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
}
