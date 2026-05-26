import 'package:shared_preferences/shared_preferences.dart';

void logoutUser(Function onRootScreenChange) async {
  // instantiate sharePreferences class
  // purpose: removing all user credential, which sotre in local-storage, when they logout
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // all credetial that need to be remove
  prefs.remove('user_id');
  prefs.remove('username');
  prefs.remove('user_role');
  prefs.remove('user_email');
  prefs.remove('phone_number');
  prefs.remove('user_token');
  // return the user back to login-screen
  onRootScreenChange('login_screen');
}