import "package:flutter/material.dart";
import 'package:tamdan_kon_mobile_flutter/views/splash_screen.dart';
import 'package:tamdan_kon_mobile_flutter/views/login_screen.dart';
import 'package:tamdan_kon_mobile_flutter/views/parent/parent_screen.dart';
import 'package:tamdan_kon_mobile_flutter/views/driver/driver_screen.dart';
import 'package:tamdan_kon_mobile_flutter/views/admin/admin_screen.dart';

// get_screen_parse composable functions, is design for parsing the String-like screen name to actual screen


// parsing the string value of current currentRootScreen of RootApp widget to actual screen widget value
Widget getRootScreenParse(
  String currentRootScreen, 
  void Function(String rootScreen) rootAppScreenSwitcher,
) {
  if(currentRootScreen == 'splash_screen'){
      return SplashScreen(
        onRootScreenChange: rootAppScreenSwitcher,
      );
    } 
    else if(currentRootScreen == 'login_screen'){
      return LoginScreen(
        onRootScreenChange: rootAppScreenSwitcher,
      );
    }
    else if(currentRootScreen == 'driver_screen'){
      return DriverScreen(
        onRootScreenChange: rootAppScreenSwitcher,
      );
    }
    else if(currentRootScreen == 'parent_screen'){
      return ParentScreen(
        onRootScreenChange: rootAppScreenSwitcher,
      );
    }
    else{
      return AdminScreen(
        onRootScreenChange: rootAppScreenSwitcher,
      );
  }
}

// parsing the parent-screen index value to the actual parent-screen 
// Widget getParentScreenParse(int parentScreenIndex, GoogleMap googleMap) {
//   if(parentScreenIndex == 0){
//     return ParentMapScreen();
//   }
//   else if(parentScreenIndex == 1){
//     return ParentAttendanceScreen();
//   }
//   else if(parentScreenIndex == 2){
//     return ParentChatScreen();
//   }
//   else {
//     return ParentMyAccountScreen();
//   }
// }